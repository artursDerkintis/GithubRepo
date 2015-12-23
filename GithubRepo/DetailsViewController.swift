//
//  DetailsViewController.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/19/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormater = NSDateFormatter()
    
    let detailsProvider = DetailsProvider()
    var contributors : [Contributor]?{
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
            
        }
    }
    var issues : [Issue]?{
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
        }
    }
    var repo : Repo?{
        didSet{
            if let name = repo?.name{
                detailsProvider.getContributorsForRepo(name) { (contrs) -> Void in
                    self.contributors = contrs
                }
                detailsProvider.getIssuesForRepo(name, completion: { (issues) -> Void in
                    self.issues = issues
                })
                
            }
        }
    }
    
    var selectedLoginName : String?
    var selectedIssue : Issue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repoNameLabel.text = repo?.name
        descLabel.text = repo?.desc

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let contrCell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! ContributorTableViewCell
            if let contributor = contributors?[indexPath.row]{
                contrCell.userNameLabel.text = contributor.userName
                contrCell.commitCountLabel.text = "\(contributor.commitCount!) " + (contributor.commitCount > 1 ? "commits" : "commit")
                if let avatarURL = contributor.avatarURL{
                    UIImage.loadFromURL(NSURL(string: avatarURL)!, callback: { (image) -> () in
                        contrCell.avatarImageView.image = image
                    })
                }
            }
            return contrCell
        }else if indexPath.section == 1{
            let issueCell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! IssueTableViewCell
            if let issue = issues?[indexPath.row]{
                issueCell.titleLabel.text = issue.title
                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                if let date = dateFormater.dateFromString(issue.createdAt!){
                    let dateString = date.timeAgo
                    issueCell.bodyLabel.text = "#\(issue.number!) opened \(dateString) by \(issue.openedBy!)"
                }
                if issue.state == "closed"{
                    issueCell.stateLabel.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.1, alpha: 1.0)
                    issueCell.stateLabel.textColor = .whiteColor()
                }else if issue.state == "open"{
                    issueCell.stateLabel.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 1.0)
                    issueCell.stateLabel.textColor = .whiteColor()
                }
                issueCell.stateLabel.text = issue.state
            }
            return issueCell
        }
        return UITableViewCell()
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            if let count = contributors?.count{
                return count
            }else{
                return 0
            }
        case 1:
            if let count = issues?.count{
                return count
            }else{
                return 0
            }
        default:
            break
        }
        return 0
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && contributors?.count > 0{
            return "Top \(contributors!.count) Contributors"
        }else if section == 1 && issues?.count > 0{
            return "\(issues!.count) Newest Issues"
        }
        return nil
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0{
            self.selectedLoginName = self.contributors?[indexPath.row].userName
            self.performSegueWithIdentifier("Contributor", sender: self)
        }else if indexPath.section == 1{
            self.selectedIssue = self.issues?[indexPath.row]
            self.performSegueWithIdentifier("Issue", sender: self)
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userVC = segue.destinationViewController as? UserViewController{
            userVC.loginName = self.selectedLoginName
        }else if let issueVC = segue.destinationViewController as? IssueViewController{
            issueVC.issue = self.selectedIssue
        }
    }
}
