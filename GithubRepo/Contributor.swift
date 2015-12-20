//
//  Contributor.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/19/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class Contributor: NSObject {
    var userName : String?
    var avatarURL : String?
    var commitCount : Int? //This is not live count, so it can be different on githuub.com
}
