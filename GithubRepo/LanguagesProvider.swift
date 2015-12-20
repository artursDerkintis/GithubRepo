//
//  LanguagesAutocompletionProvider.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit


class LanguagesProvider: NSObject {
    var topLanguages = ["JavaScript",
        "Java",
        "Python",
        "CSS",
        "PHP",
        "Ruby",
        "C++",
        "C",
        "Shell",
        "C#",
        "Objective-C",
        "R",
        "VimL",
        "Go",
        "Perl",
        "CoffeeScript",
        "TeX",
        "Swift",
        "Scala",
        "Emacs Lisp",
        "Haskell",
        "Lua",
        "Clojure",
        "Matlab",
        "Arduino",
        "Makefile",
        "Groovy",
        "Puppet",
        "Rust",
        "PowerShell"
    ]
    func generateSuggestions(string : String) -> [String]{
        var suggestions = [String]()
        for language in topLanguages{
            if language.containsString(string){
                suggestions.append(language)
            }
        }
        return suggestions
    }
}

