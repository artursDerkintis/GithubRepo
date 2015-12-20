//
//  RepositoresViewController.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/19/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import SnapKit

class RepositoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let reposProvider = ReposotoriesProvider()
    var language = ""{
        didSet{
            if language.characters.count > 0{
                reposProvider.getReposForLanguage(language) { (repos) -> Void in
                    self.repos = repos
                }
            }
        }
    }
    var repos : [Repo]?{
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                 self.tableView.reloadData()
            }
           
        }
    }
    
    var selectedRepo : Repo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let detailsVC = segue.destinationViewController as? DetailsViewController{
            detailsVC.repo = selectedRepo!
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let repo = repos?[indexPath.row]{
            selectedRepo = repo
            self.performSegueWithIdentifier("details", sender: self)
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! RepoTableViewCell
        if let repo = repos?[indexPath.row]{
            cell.repoName.text = repo.name
            cell.desc.text = repo.desc
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .DecimalStyle
            let number = numberFormatter.stringFromNumber(NSNumber(integer: repo.starsCount!))
            cell.stargazers.text = "\(number!) ★"
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = repos?.count{
            return count
        }else{
            return 0
            
        }
    }
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let count = repos?.count where count > 0{
            return nil
        }else if repos == nil{
            return "Loading..."
        }else if repos != nil && repos?.count == 0{
            return "None repositories found"
        }else{
            return nil
        }
    }
}
