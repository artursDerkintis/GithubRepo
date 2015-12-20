//
//  Extenstion.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/19/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

extension UIImage {
    
    // Loads image asynchronously
    class func loadFromURL(url: NSURL, callback: (UIImage)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            let imageData = NSData(contentsOfURL: url)
            if let data = imageData {
                dispatch_async(dispatch_get_main_queue(), {
                    if let image = UIImage(data: data) {
                        callback(image)
                    }
                })
            }
        })
    }
}