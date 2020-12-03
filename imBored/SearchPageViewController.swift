//
//  SearchPageViewController.swift
//  imBored
//
//  Created by Morgan Prime on 12/2/20.
//

import UIKit

class SearchPageViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var userInput: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print(text)

            userInput = text
            if segmentedControl.selectedSegmentIndex == 0{
                performSegue(withIdentifier: "MovieSearchView", sender: self)
            }
            if segmentedControl.selectedSegmentIndex == 1{
                performSegue(withIdentifier: "TVSearchView", sender: self)
            }
            
        }
    }
    
    @IBAction func helpBarButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowHelp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieSearchView"{
            let destination = segue.destination as! MovieSearchResultViewController
            destination.query = userInput
        }
        if segue.identifier == "TVSearchView"{
            let destination = segue.destination as! TVSearchResultViewController
            destination.query = userInput
        }
        if segue.identifier == "ShowHelp"{
            
        }
    }

}
