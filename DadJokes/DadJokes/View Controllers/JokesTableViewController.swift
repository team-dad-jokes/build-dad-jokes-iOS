//
//  JokesTableViewController.swift
//  DadJokes
//
//  Created by Thomas Cacciatore on 6/3/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class JokesTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchBar.delegate = self
        //headerView.backgroundColor = AppearanceHelper.specialBlue  why do our Nav-areas have different color than searchbar and segcontrol background colors if color is same?
        let font = UIFont.boldSystemFont(ofSize: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        //self.tableView.tableFooterView = UIView() // eliminates blank table-cells at bottom of page

    }

    override func viewWillAppear(_ animated: Bool) {
        
        jokeController.resetArray()
        jokeController.resetPrivateArray()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            jokeController.resetArray() // also jokeController.loadFromPersistentStore
            guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
            
            jokeController.filterArray(searchTerm: searchTerm.lowercased())
            jokeController.jokes = jokeController.searchArray
            tableView.reloadData()
            searchBar.text = ""
            
        } else {
            jokeController.resetPrivateArray() // also jokeController.loadFromPersistentStore
            guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
            
            jokeController.filterPrivateArray(searchTerm: searchTerm.lowercased())
            jokeController.privateJokes = jokeController.searchArray
            tableView.reloadData()
            searchBar.text = ""
        }
        
        
    }
    
    
    @IBAction func segmentedControlChange(_ sender: Any) {
        
        jokeController.resetArray()
        jokeController.resetPrivateArray()
        
        // jokeController = JokeController()   we could've used this init() call instead of the lines above.
        
        if segmentedControl.selectedSegmentIndex == 1 {
            
            //check if there is a token
            //guard let authenticate = bearer?.token else { return }
            
            if UserDefaults.standard.object(forKey: "bearerToken") == nil {
                
                performSegue(withIdentifier: "LoginSegue", sender: self)
            } else {
                
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            //if yes filter for premium jokes
            //if no token, segueway to login screen.
            
            // } else {
            //
            
            
        } else if segmentedControl.selectedSegmentIndex == 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return jokeController.jokes.count
        } else {
            return jokeController.privateJokes.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let joke = jokeController.jokes[indexPath.row]
            cell.textLabel?.text = joke.joke
        } else {
            
            if UserDefaults.standard.object(forKey: "bearerToken") == nil {
                segmentedControl.selectedSegmentIndex = 0
               tableView.reloadData()
            } else {
            // recheck if bearer token works, or else exit before showing table view under condition seg = 1, else set segmentedControl = 0 and reload the table view.
            let joke = jokeController.privateJokes[indexPath.row]
            cell.textLabel?.text = joke.joke
            }
        }
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            if segue.identifier == "DetailSegue" {
                guard let destinationVC = segue.destination as? JokeDetailViewController else { return }
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                
                destinationVC.jokeController = jokeController
                destinationVC.joke = jokeController.jokes[indexPath.row]
                destinationVC.detailSegueBool = true
                destinationVC.isFree = true
            } else if segue.identifier == "AddSegue" {
                guard let destinationVC = segue.destination as? JokeDetailViewController else { return }
                destinationVC.jokeController = jokeController
                destinationVC.detailSegueBool = false
                destinationVC.isFree = true
            }
        } else {
            if segue.identifier == "DetailSegue" {
                guard let destinationVC = segue.destination as? JokeDetailViewController else { return }
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                
                destinationVC.jokeController = jokeController
                destinationVC.joke = jokeController.privateJokes[indexPath.row]
                destinationVC.detailSegueBool = true
                destinationVC.isFree = true
            } else if segue.identifier == "AddSegue" {
                guard let destinationVC = segue.destination as? JokeDetailViewController else { return }
                destinationVC.jokeController = jokeController
                destinationVC.detailSegueBool = false
                destinationVC.isFree = false
            }
        }
        
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            if editingStyle == .delete {
                jokeController.deleteJoke(joke: jokeController.jokes[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            } /*else if editingStyle == .insert {
             jokeController.createJoke(with: jokeController.jokes[indexPath.row])
             tableView.indexp
             } */
        } else {
            if editingStyle == .delete {
                jokeController.deletePrivateJoke(joke: jokeController.privateJokes[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            } /*else if editingStyle == .insert {
             jokeController.createJoke(with: jokeController.jokes[indexPath.row])
             tableView.indexp
             } */
        }
        
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//
//        var editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
//            tableView.isEditing = false
//
//            print("call edit crud func")
//        }
//
//        editAction.backgroundColor = UIColor.blue
//
//
//        var deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
//            tableView.isEditing = false
//            self.jokeController.deleteJoke(joke: self.jokeController.jokes[indexPath.row])
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//
//        return [deleteAction, editAction]
//    }
    
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var jokeController = JokeController()
    var detailSegueBool: Bool?
    var isFree: Bool?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
}
