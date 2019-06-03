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
    
    var joke: DadJoke?
    
    let baseURL = URL(string: "https://icanhazdadjoke.com/")!
    
    init() {
        loadFromPersistentStore()
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
    
    //CRUD methods
    
    func createJoke(with joke:String) {
        let joke = DadJoke(joke: joke)
        jokes.append(joke)
        
        saveToPersisentStore()
    }
    
    func deleteJoke(joke: DadJoke) {
        guard let index = jokes.firstIndex(of: joke) else { return }
        jokes.remove(at: index)
        
        saveToPersisentStore()
    }
    
    
    func update(joke: DadJoke, with newJoke: String) {
        guard let index = jokes.firstIndex(of: joke) else { return }
        jokes[index].joke = newJoke
        
        saveToPersisentStore()
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
    
   
    private var jokesURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        print("Documents: \(documents.path)")
        return documents.appendingPathComponent("jokes.plist")
    }
    
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "Post"
    case delete = "DELETE"
}
