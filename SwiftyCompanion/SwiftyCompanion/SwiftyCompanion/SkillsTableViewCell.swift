//
//  SkillsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Basile Durst on 04/08/2017.
//  Copyright © 2017 Basile Durst. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var SkillsTable: UITableView!
    
    var skills: NSArray = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell") as! SkillTableViewCell
        if let skill: NSDictionary = self.skills[indexPath.row] as? NSDictionary {
            if !(skill["level"] is NSNull) {
                let level: Float = skill["level"]! as! Float
                cell.skillLevel.text = String(format: "%.2f", level)
            }
            cell.skillName.text = skill["name"] as? String
        }
        return cell
    }
}
