//
//  ContributorViewController.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/20/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    let dateFormater = NSDateFormatter()
   
    var user : User?
    let userDataProvider = UserDataProvider()
    var loginName : String?{
        didSet{
            if loginName != nil{
                userDataProvider.getUserInfoForLoginName(loginName!) { (user) -> Void in
                    self.user = user
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.loadData()
                    })
                }
            }
        }
    }
   
    func loadData(){
        if let user = self.user{
            if let url = user.avatarURL{
                UIImage.loadFromURL(NSURL(string: url)!, callback: { (image) -> () in
                    self.avatarImageView.image = image
                })
            }
            fullNameLabel.text = user.name
            loginNameLabel.text = self.loginName
            locationLabel.text = "📍 \(user.location!)"
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormater.dateFromString(user.createdAt!)
            dateFormater.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormater.stringFromDate(date!)
            joinedLabel.text = "🕒 Joined at \(dateString)"
            followersLabel.text = "\(user.followers!) Followers"
            followingLabel.text = "\(user.following!) Following"
            
        }else{
            fullNameLabel.text = "Loading..."
            loginNameLabel.text = " "
            locationLabel.text = " "
            joinedLabel.text = " "
            followersLabel.text = " "
            followingLabel.text = " "
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Clears the labels
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
