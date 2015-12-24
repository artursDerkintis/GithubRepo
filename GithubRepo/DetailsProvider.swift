//
//  DetailsProvider.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/19/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import Alamofire

class DetailsProvider: NSObject {
    func getContributorsForRepo(string : String, completion: (contrs : [Contributor]) -> Void){
        var contributors = [Contributor]()
        
        let queue = dispatch_queue_create("com.universel.Alamofire-queue", DISPATCH_QUEUE_CONCURRENT)
        
        let url = "https://api.github.com/repos/\(string)/contributors"
        let request = Alamofire.request(.GET, url)
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { response in
                if response.response?.statusCode == 200{
                    
                    if let data = response.result.value as? Array<[String:AnyObject]>{
                        for item in data {
                            let contr = self.parseContributorModel(item)
                            //As you asked - Top 3 contributors
                            if contributors.count < 3{
                                contributors.append(contr)
                            }else{
                                break
                            }
                            
                        }
                        completion(contrs: contributors)
                    }
                    
                }
        })
        
        
    }
    func getIssuesForRepo(string : String, completion: (issues : [Issue]) -> Void){
        var issues_ = [Issue]()
        let queue = dispatch_queue_create("com.universel.Alamofire-queue", DISPATCH_QUEUE_CONCURRENT)
        
        let url = "https://api.github.com/repos/\(string)/issues?state=all"
        let request = Alamofire.request(.GET, url)
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { response in
                if response.response?.statusCode == 200{
                    
                    if let data = response.result.value as? Array<[String:AnyObject]>{
                        for item in data {
                            
                            let contr = self.parseIssueModel(item)
                            //As you asked - 3 Newest Issues
                            if issues_.count < 3{
                                issues_.append(contr)
                            }else{
                                break
                            }
                            
                            
                            
                        }
                        completion(issues: issues_)
                    }
                    
                }
        })
        
    }
    
    func parseContributorModel(data : [String : AnyObject]) -> Contributor{
        let newContr = Contributor()
        if let userName  = data["login"] as? String {
            newContr.userName = userName
        }
        
        if let commitCount = data["contributions"] as? Int {
            newContr.commitCount = commitCount
        }
        
        if let avatarURL = data["avatar_url"] as? String {
            newContr.avatarURL = avatarURL
        }
        return newContr
        
    }
    func parseIssueModel(data : [String : AnyObject]) -> Issue{
        let newIssue = Issue()
        if let title  = data["title"] as? String {
            newIssue.title = title
        }
        
        if let openedAt = data["created_at"] as? String {
            newIssue.createdAt = openedAt
        }
        
        if let openedBy = data["user"]?.valueForKey("login") as? String {
            newIssue.openedBy = openedBy
        }
        
        if let body = data["body"] as? String {
            newIssue.body = body
        }
        
        if let state = data["state"] as? String {
            newIssue.state = state
        }
        if let number = data["number"] as? Int {
            newIssue.number = number
        }
        return newIssue
        
    }
    
    
}
