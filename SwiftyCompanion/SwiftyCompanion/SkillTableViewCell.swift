//
//  SkillTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Basile Durst on 04/08/2017.
//  Copyright © 2017 Basile Durst. All rights reserved.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillLevel: UILabel!
    
    var skill : (String, Int)? {
        didSet {
            if let s = skill {
                skillName.text = s.0
                skillLevel.text = String(s.1)
            }
        }
    }
}
