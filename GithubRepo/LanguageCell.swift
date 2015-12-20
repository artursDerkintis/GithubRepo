//
//  LanguageCell.swift
//  GithubRepo
//
//  Created by Arturs Derkintis on 12/19/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import SnapKit

class LanguageCell: UITableViewCell {
    var languageLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        languageLabel = UILabel(frame: .zero)
        contentView.addSubview(languageLabel)
        languageLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.top.bottom.right.equalTo(0)
        }
        languageLabel.font = UIFont.systemFontOfSize(15)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
