//
//  ViewController.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
  
    var suggestionsProvider = LanguagesProvider()
    var suggestions : [String]?{
        didSet{
            tableView.reloadData()
        }
    }
    var requestedLanguage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        if let textField = searchBar.valueForKey("_searchField") as? UITextField{
            textField.keyboardAppearance = .Dark
        }
        // Do any additional setup after loading the view, typically from a nib.
        //Initially shows most popular languages
        suggestions = suggestionsProvider.topLanguages
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillHide(not: NSNotification){
        tableView.contentInset = UIEdgeInsetsZero
    }
    //Prevents keyboard from hide bottom cells of tableView
    func keyboardWillShow(not: NSNotification){
        if let userInfo = not.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                tableView.contentInset = contentInsets
            } else {
                
            }
        } else {
        }
    }
    
    //UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        suggestions = suggestionsProvider.generateSuggestions(searchBar.text!)
        if suggestions?.count == 0 && searchBar.text?.characters.count > 0{
            suggestions = [searchBar.text!]
        }
        if searchBar.text == ""{
            suggestions = suggestionsProvider.topLanguages
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        requestedLanguage = searchBar.text!
        self.performSegueWithIdentifier("showLang", sender: self)
        searchBar.endEditing(true)
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let selected = suggestions?[indexPath.row]{
            requestedLanguage = selected
            self.performSegueWithIdentifier("showLang", sender: self)
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
        if let text = suggestions?[indexPath.row]{
            if let label = cell.viewWithTag(100) as? UILabel{
                label.text = text
            }
        }
        return cell
    
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let suggestions = suggestions{
            return suggestions.count
        }else{
            return 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let repoVC = segue.destinationViewController as? RepositoresViewController{
            repoVC.navigationItem.title = requestedLanguage
            repoVC.language = requestedLanguage
        }
    }
}

