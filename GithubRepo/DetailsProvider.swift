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
                    do{
                        if let data = response.result.value as? Array<[String:AnyObject]>{
                            for item in data {

                                let contr = try self.parseContributorModel(item)
                                //As you asked - Top 3 contributors
                                if contributors.count < 3{
                                    contributors.append(contr)
                                }
                            }
                            completion(contrs: contributors)
                        }
                    }catch let error{
                        print("Something went wrong \(error)")
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
                    do{
                        if let data = response.result.value as? Array<[String:AnyObject]>{
                            for item in data {
                                
                                let contr = try self.parseIssueModel(item)
                                //As you asked - 3 Newest Issues
                                if issues_.count < 3{
                                    issues_.append(contr)
                                }
                            }
                            completion(issues: issues_)
                        }
                    }catch let error{
                        print("Something went wrong \(error)")
                    }
                }
        })

    }
    
    func parseContributorModel(data : [String : AnyObject]) throws -> Contributor{
        guard let userName  = data["login"] as? String else{
            throw ParseError.NameNotFound
        }
        
        guard let commitCount = data["contributions"] as? Int else{
            throw ParseError.CommitCountNotFound
        }
        
        guard let avatarURL = data["avatar_url"] as? String else{
            throw ParseError.AvatarURLNotFound
        }
        
        let newContr = Contributor()
        newContr.userName = userName
        newContr.commitCount = commitCount
        newContr.avatarURL = avatarURL
        return newContr
        
    }
    func parseIssueModel(data : [String : AnyObject]) throws -> Issue{
        guard let title  = data["title"] as? String else{
            throw ParseError.TitleNotFound
        }
        
        guard let openedAt = data["created_at"] as? String else{
            throw ParseError.DateNotFound
        }
        
        guard let openedBy = data["user"]?.valueForKey("login") as? String else{
            throw ParseError.OpenedByNotFound
        }
        
        guard let state = data["state"] as? String else{
            throw ParseError.StateNotFound
        }
        guard let number = data["number"] as? Int else{
            throw ParseError.NumberNotFound
        }
        
        let newIssue = Issue()
        newIssue.title = title
        newIssue.createdAt = openedAt
        newIssue.openedBy = openedBy
        newIssue.state = state
        newIssue.number = number
        return newIssue
        
    }


}
