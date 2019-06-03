//
//  JokeDetailViewController.swift
//  DadJokes
//
//  Created by Thomas Cacciatore on 6/3/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class JokeDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let dadJoke = joke else { return }
        DispatchQueue.main.async {
            self.textView.text = dadJoke.joke
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
    
  
    
    // MARK: - Properties
   
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var getJokeButton: UIButton!
    
    var joke: DadJoke? {
        didSet {
            updateViews()
        }
    }
    var jokeController: JokeController?

}
