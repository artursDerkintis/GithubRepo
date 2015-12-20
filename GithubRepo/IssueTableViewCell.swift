//
//  IssueTableViewCell.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/19/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stateLabel.layer.cornerRadius = 10
        stateLabel.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
