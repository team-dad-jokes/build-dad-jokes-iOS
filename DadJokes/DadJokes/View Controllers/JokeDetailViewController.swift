//
//  JokeDetailViewController.swift
//  DadJokes
//
//  Created by Thomas Cacciatore on 6/3/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class JokeDetailViewController: UIViewController {


    
    func updateViews() {
        guard let dadJoke = joke else { return }
        DispatchQueue.main.async {
            self.textView.text = dadJoke.joke
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = joke {  // if our joke variable is fed from PrepareForSegue, hide buttons for read-only
            updateViews()
            getJokeButton.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            createTextView.isHidden = true
            createJokeButton.isHidden = true
            
            
        }
        
        
    }

  
    @IBAction func getJokeButtonTapped(_ sender: Any) {
        jokeController?.fetchJoke(completion: { (error) in
            if let error = error {
                NSLog("Error fetching Joke: \(error)")
                return
            }
            guard let dadJoke = self.jokeController?.joke else { return }
            DispatchQueue.main.async {
                self.joke = dadJoke
            }
        })
    }
    
    
    @IBAction func saveJokeButtonTapped(_ sender: Any) {
        guard let dadJoke = self.jokeController?.joke else { return }
        self.jokeController?.createJoke(with: dadJoke.joke)

            self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func createJokeButtonTapped(_ sender: Any) {

        guard let createdJoke = createTextView.text, !createdJoke.isEmpty else { return }
        jokeController?.createJoke(with: createdJoke)

        self.navigationController?.popViewController(animated: true)

    }
    
    // footer table view which eliminatew empty spaces.
    // snazzy up the tqble-view black and white
    // dribble.com for inspiration.
  
    
    // MARK: - Properties
   
    func editJoke() {
        print("EDIT TEXT VIEW TOUCHED")
        jokeController?.createJoke(with: textView.text)
        //editJoke()
        
    }
    
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var getJokeButton: UIButton!
    @IBOutlet var createTextView: UITextView!
    @IBOutlet var createJokeButton: UIButton!
    
    
    var joke: DadJoke? {
        didSet {
            updateViews()
        }
    }
    var jokeController: JokeController?

}
