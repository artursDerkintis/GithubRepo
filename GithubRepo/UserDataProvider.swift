//
//  UserDataProvider.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/20/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import Alamofire



class UserDataProvider: NSObject {
    
    func getUserInfoForLoginName(userName : String, completion: (user : User) -> Void){
        
        let queue = dispatch_queue_create("com.universel.Alamofire-queue", DISPATCH_QUEUE_CONCURRENT)
        
        let url = "https://api.github.com/users/\(userName)"
        let request = Alamofire.request(.GET, url)
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { response in
                if response.response?.statusCode == 200{
                    
                    if let data = response.result.value as? [String:AnyObject]{
                        let user = self.parseUserModel(data)
                        completion(user: user)
                    }
                    
                }

                
        })
    }
    func parseUserModel(data : [String : AnyObject]) -> User{
        let newUser = User()
        if let name = data["name"] as? String{
            newUser.name = name
        }
        
        if let followers  = data["followers"] as? Int {
            newUser.followers = followers
        }
        if let following = data["following"] as? Int {
            newUser.following = following
        }
        if let location = data["location"] as? String {
            newUser.location = location
        }
        if let createdAt = data["created_at"] as? String{
            newUser.createdAt = createdAt
        }
        if let avatarURL = data["avatar_url"] as? String{
            newUser.avatarURL = avatarURL
        }
        return newUser
        
    }

}
