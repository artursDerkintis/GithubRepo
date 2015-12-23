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
                    do{
                        if let data = response.result.value as? [String:AnyObject]{
                            let user = try self.parseUserModel(data)
                            completion(user: user)
                        }
                    }catch let error{
                        print("Something went wrong \(error)")
                    }
                }

                
        })
    }
    func parseUserModel(data : [String : AnyObject]) throws -> User{
        guard let name = data["name"] as? String else{
            throw ParseError.NameNotFound
        }
        guard let followers  = data["followers"] as? Int else{
            throw ParseError.FollowersNotFound
        }
        guard let following = data["following"] as? Int else{
            throw ParseError.FollowedNotFound
        }
        guard let location = data["location"] as? String else{
            throw ParseError.LocationNotFound
        }
        guard let createdAt = data["created_at"] as? String else{
            throw ParseError.DateNotFound
        }
        guard let avatarURL = data["avatar_url"] as? String else{
            throw ParseError.AvatarURLNotFound
        }
        
        
        let newUser = User()
        newUser.avatarURL = avatarURL
        newUser.followers = followers
        newUser.following = following
        newUser.name = name
        newUser.location = location
        newUser.createdAt = createdAt
        
        return newUser
        
    }

}
