//
//  ReposotoriesProvider.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import Alamofire

enum ParseError : ErrorType{
    case BadID
    case NameNotFound
    case StargezersCountNotFound
    case DescriptionNotFound
    case TitleNotFound
    case DateNotFound
    case OpenedByNotFound
    case StateNotFound
    case NumberNotFound
    case UserNameCountNotFound
    case CommitCountNotFound
    case AvatarURLNotFound
    case FollowersNotFound
    case FollowedNotFound
    case LocationNotFound
    case BodyNotFound
}

class ReposotoriesProvider: NSObject {
    
    func getReposForLanguage(language : String, completion : (repos : [Repo]) -> Void){
        var _repos = [Repo]()
        let queue = dispatch_queue_create("com.universel.Alamofire-queue", DISPATCH_QUEUE_CONCURRENT)
        
        let url = "https://api.github.com/search/repositories?q=+language:\(language)&sort=stars&order=desc"
        let request = Alamofire.request(.GET, url)
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { response in
                if response.response?.statusCode == 200{
                    do{
                        if let data = response.result.value as? [String: AnyObject]{
                            if let items = data["items"] as? Array<[String:AnyObject]>{
                                for item in items {
                                    let repo = try self.parseRepoModel(item)
                                    _repos.append(repo)
                                }
                                completion(repos: _repos)
                                
                                
                                
                            }
                        }
                    }catch let error{
                        print("Something went wrong \(error)")
                    }
                    
                }else{
                    //nothing found
                    completion(repos: _repos)
                    print(response.response)
                }
                
            })
        
    }
    
    func parseRepoModel(data : [String : AnyObject]) throws -> Repo{
        guard let id  = data["id"] as? Int else{
            throw ParseError.BadID
        }
        guard let nameOfRepo = data["full_name"] as? String else{
            throw ParseError.NameNotFound
        }
        guard let descriptionOfRepo = data["description"] as? String else{
            throw ParseError.DescriptionNotFound
        }
        guard let starCount = data["stargazers_count"] as? Int else{
            throw ParseError.StargezersCountNotFound
        }
        let newRepo = Repo()
        newRepo.id = id
        newRepo.name = nameOfRepo
        newRepo.starsCount = starCount
        newRepo.desc = descriptionOfRepo
        return newRepo
        
    }
}

