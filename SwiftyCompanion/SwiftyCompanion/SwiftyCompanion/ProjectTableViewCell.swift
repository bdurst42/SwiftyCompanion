//
//  ProjectTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Basile Durst on 03/08/2017.
//  Copyright © 2017 Basile Durst. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectNote: UILabel!

    var project : (String, Int)? {
        didSet {
            if let p = project {
                projectName.text = p.0
                projectNote.text = String(p.1)
            }
        }
    }
}
