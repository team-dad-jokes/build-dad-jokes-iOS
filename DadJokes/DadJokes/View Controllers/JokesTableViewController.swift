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
        headerView.backgroundColor = AppearanceHelper.specialBlue
        let font = UIFont.boldSystemFont(ofSize: 20)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        self.tableView.tableFooterView = UIView() // eliminates blank table-cells at bottom of page

    }

    override func viewWillAppear(_ animated: Bool) {
        jokeController.resetArray()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        jokeController.resetArray() // also jokeController.loadFromPersistentStore
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
    
        jokeController.filterArray(searchTerm: searchTerm.lowercased())
        jokeController.jokes = jokeController.searchArray
        tableView.reloadData()
        searchBar.text = ""
        
    }
    
    
    @IBAction func segmentedControlChange(_ sender: Any) {
        jokeController.resetArray()
        
        // jokeController = JokeController()
        
        if segmentedControl.selectedSegmentIndex == 1 {
            //check if there is a token
            //if yes filter for premium jokes
            //if no token, segueway to login screen.
            
            performSegue(withIdentifier: "LoginSegue", sender: self)
            
            
        } else if segmentedControl.selectedSegmentIndex == 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jokeController.jokes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath)

        let joke = jokeController.jokes[indexPath.row]
        cell.textLabel?.text = joke.joke

        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let destinationVC = segue.destination as? JokeDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            destinationVC.jokeController = jokeController
            destinationVC.joke = jokeController.jokes[indexPath.row]
        } else if segue.identifier == "AddSegue" {
            guard let destinationVC = segue.destination as? JokeDetailViewController else { return }
            destinationVC.jokeController = jokeController
            
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            jokeController.deleteJoke(joke: jokeController.jokes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } /*else if editingStyle == .insert {
            jokeController.createJoke(with: jokeController.jokes[indexPath.row])
            tableView.indexp
        } */
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var jokeController = JokeController()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
}
