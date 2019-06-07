//
//  JokeController.swift
//  DadJokes
//
//  Created by Thomas Cacciatore on 6/3/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import Foundation

class JokeController {
    
    var jokes: [DadJoke] = []
    var privateJokes: [DadJoke] = []
    var joke: DadJoke?
    var bearer: Bearer?
    var searchArray: [DadJoke] = []
    let defaults = UserDefaults.standard
    
    let baseURL = URL(string: "https://icanhazdadjoke.com/")!
    
    init() {
        
        loadFromPersistentStore()
        loadFromPrivatePersistentStore()
        
        guard let savedToken = defaults.object(forKey: "bearerToken") as? String else {return}
        bearer?.token = savedToken
        
        //bearer?.token = defaultStorage(token)
        //let shouldShowPluto = UserDefaults.standard.bool(forKey: .shouldShowPlutoKey)
    }
    
    func automatedLoginSuccess() {

        defaults.set("success", forKey: "bearerToken")
    }
    
    func fetchJoke(completion: @escaping (Error?) -> Void) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching joke: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error: no data returned")
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let requestJoke = try decoder.decode(DadJoke.self, from: data)
                self.joke = requestJoke
                
                completion(nil)
            } catch {
                    NSLog("Error decoding joke from data: \(error)")
                    completion(error)
            }
            
        }.resume()
        
    }
    
//    func signUp(with username: String, password: String, completion: @escaping (Error?) -> Void) {
//
//        let requestURL = signinURL
//
//
//        //var request = URLRequest(url: requestURL)
//
//        request.httpMethod = HTTPMethod.post.rawValue
//
//        // The body of our request is JSON.
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        let user = User(username: username, password: password)
//
//        // Base64( usernamepassword) hash
//
//
//
//        do {
//            request.httpBody = try JSONEncoder().encode(user)
//        } catch {
//            NSLog("Error encoding User: \(error)")
//            completion(error)
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { (_, response, error) in
//
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//
//                // Something went wrong
//                completion(NSError())
//                return
//            }
//
//            if let error = error {
//                NSLog("Error signing up: \(error)")
//                completion(error)
//                return
//            }
//
//            completion(nil)
//            }.resume()
//    }
    
    // login = adminpassword
    
    func logIn(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        
        // Content-Type: "application/x-
        
        let middleURL = signinURL.appendingPathComponent("grant_type=password&username=admin&password=password")
        
        // let extraURLStuff = "Basicdadjoke-client:lambda-secret
        
        let requestURL = middleURL.appendingPathComponent("Basic " + "dadjoke-client:lambda-secret".toBase64() + "Content-Type" + "application/x-www-form-urlencoded")
        print(requestURL)
        
        
        
        
        var request = URLRequest(url: requestURL)
        
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        // The body of our request is JSON.
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        
//        let user = User(username: username, password: password)
//
//        do {
//            //request.httpBody = try JSONEncoder().encode(user)
//        } catch {
//            NSLog("Error encoding User: \(error)")
//            completion(error)
//            return
//        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                // Something went wrong
                completion(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(error)
                return
            }
            
            // Get the bearer token by decoding it.
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            //let decoder = JSONDecoder()
            
            
//            func fromBase64() -> String? {
//                guard let data = Data(base64Encoded: self) else { return nil }
//                return String(data: data, encoding: .utf8)
            
            //let bearer = try JSONDecoder.decode(Bearer.self, from: data)
            
            //let bearer = try Base64Encoded.utf8(Bearer.self, from: data)
            
            //let decodedData = data.utf8
            
            
            
            
            do {
                let bearer = try String(data: data, encoding: .utf8)
                let x = Bearer.init(token: bearer!)
                
                // We now have the bearer to authenticate the other requests
                self.bearer = x
                // store bearer.token as "success"
                completion(nil)
            } catch {
                NSLog("Error decoding Bearer: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    func filterArray(searchTerm: String) -> [DadJoke] {
        searchArray = jokes.filter({ $0.joke.lowercased().contains(searchTerm) })
        return searchArray
    }
    
    func filterPrivateArray(searchTerm: String) -> [DadJoke] {
        searchArray = privateJokes.filter({ $0.joke.lowercased().contains(searchTerm) })
        return searchArray
    }
    
    func resetArray() {
        loadFromPersistentStore()
    }
    
    func resetPrivateArray() {
        loadFromPrivatePersistentStore()
    }
    
    //CRUD methods
    
    func createJoke(with joke:String) {
        let joke = DadJoke(joke: joke)
        jokes.append(joke)
        
        saveToPersisentStore()
    }
    
    func createPrivateJoke(with joke:String) {
        let joke = DadJoke(joke: joke)
        privateJokes.append(joke)
        
        saveToPrivatePersisentStore()
    }
    
    func deleteJoke(joke: DadJoke) {
        guard let index = jokes.firstIndex(of: joke) else { return }
        jokes.remove(at: index)
        
        saveToPersisentStore()
    }
    
    func deletePrivateJoke(joke: DadJoke) {
        guard let index = privateJokes.firstIndex(of: joke) else { return }
        privateJokes.remove(at: index)
        
        saveToPrivatePersisentStore()
    }
    
    
    func update(joke: DadJoke, with newJoke: String) {
        guard let index = jokes.firstIndex(of: joke) else { return }
        jokes[index].joke = newJoke
        
        saveToPersisentStore()
    }
    
    func updatePrivate(joke: DadJoke, with newJoke: String) {
        guard let index = privateJokes.firstIndex(of: joke) else { return }
        privateJokes[index].joke = newJoke
        
        saveToPrivatePersisentStore()
    }
    
    func saveToPersisentStore() {
        guard let url = jokesURL else {return}
        
        do {
            let encoder = PropertyListEncoder()
            let jokesData = try encoder.encode(jokes)
            try jokesData.write(to: url)
        } catch {
            print("error savings joke(s?): \(error)")
        }
        
    }
    
    func saveToPrivatePersisentStore() {
        guard let url = jokesPrivateURL else {return}
        
        do {
            let encoder = PropertyListEncoder()
            let jokesData = try encoder.encode(privateJokes)
            try jokesData.write(to: url)
        } catch {
            print("error savings joke(s?): \(error)")
        }
        
    }
    
    func loadFromPersistentStore() {
        
        let fileManager = FileManager.default
        guard let url = jokesURL, fileManager.fileExists(atPath: url.path) else { return}
        
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodeJokes = try decoder.decode([DadJoke].self, from: data)
            jokes = decodeJokes
        } catch {
            print("error loading data from disk \(error)")
        }
    }
    
    func loadFromPrivatePersistentStore() {
        
        let fileManager = FileManager.default
        guard let url = jokesPrivateURL, fileManager.fileExists(atPath: url.path) else { return}
        
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodeJokes = try decoder.decode([DadJoke].self, from: data)
            privateJokes = decodeJokes
        } catch {
            print("error loading data from disk \(error)")
        }
    }
    
    private var signinURL = URL(string: "https://dad-jokes2019.herokuapp.com/oauth/token")!
   
    private var jokesURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        print("Documents: \(documents.path)")
        return documents.appendingPathComponent("jokes.plist")
    }
    
    private var jokesPrivateURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        print("Documents: \(documents.path)")
        return documents.appendingPathComponent("privateJokes.plist")
    }
    
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "Post"
    case delete = "DELETE"
}

extension String {       // Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
