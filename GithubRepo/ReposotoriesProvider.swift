//
//  ReposotoriesProvider.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import Alamofire


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
                    
                    if let data = response.result.value as? [String: AnyObject]{
                        if let items = data["items"] as? Array<[String:AnyObject]>{
                            for item in items {
                                let repo = self.parseRepoModel(item)
                                _repos.append(repo)
                            }
                            completion(repos: _repos)
                            
                            
                            
                        }
                    }
                    
                    
                }else{
                    //nothing found
                    completion(repos: _repos)
                    print(response.response)
                }
                
        })
        
    }
    
    func parseRepoModel(data : [String : AnyObject]) -> Repo{
        let newRepo = Repo()
        if let id  = data["id"] as? Int {
            newRepo.id = id
        }
        if let nameOfRepo = data["full_name"] as? String {
            newRepo.name = nameOfRepo
        }
        if let descriptionOfRepo = data["description"] as? String {
            newRepo.desc = descriptionOfRepo
        }
        if let starCount = data["stargazers_count"] as? Int {
            newRepo.starsCount = starCount
        }
        return newRepo
        
    }
}

