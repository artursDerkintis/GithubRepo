//
//  IssueViewController.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/23/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class IssueViewController: UIViewController{
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var creatorLabel: UILabel!
    
    var issue : Issue?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if issue != nil{
            loadData()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        self.navigationItem.title = "Issue #\(issue!.number!)"
        self.titleLabel.text = issue?.title
        self.creatorLabel.text = "Opened by \(issue!.openedBy!)"
        //self.bodyTextView.text = issue?.body
        setAttributedString()
    }
    func setAttributedString(){
        if let string = issue!.body! as? NSString{
            if let range = string.stringBetween("```", and: "```"){
                let background = [NSForegroundColorAttributeName: UIColor.blackColor(), NSBackgroundColorAttributeName: UIColor(white: 0.8, alpha: 1.0), NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 13)!]
                let attributesString = NSMutableAttributedString(string: (string.mutableCopy() as! String).stringByReplacingOccurrencesOfString("```", withString:
                    ""))
                attributesString.addAttributes(background, range: range)
                self.bodyTextView.attributedText = attributesString
            }else{
                self.bodyTextView.text = string as String
            }
        }
    }
///"```"
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension NSString{
    func stringBetween(start: String, and end: String) -> NSRange?{
        let startRange = self.rangeOfString(start)
        if startRange.location != NSNotFound{
            var targetRange = NSRange()
            targetRange.location = startRange.location + startRange.length
            targetRange.length = self.length - targetRange.location
            let endRange = self.rangeOfString(end, options: [], range: targetRange)
            if endRange.location != NSNotFound{
                targetRange.length = endRange.location - targetRange.location
                return NSMakeRange(targetRange.location - 3, targetRange.length - 2)
            }
            
        }
        return nil
    }
}
