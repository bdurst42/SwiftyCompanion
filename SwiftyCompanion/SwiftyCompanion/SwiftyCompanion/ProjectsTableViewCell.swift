//
//  ProjectsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Basile Durst on 03/08/2017.
//  Copyright © 2017 Basile Durst. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var Projects: UITableView!
    
    var projectsTab: NSArray = []
    var cursus_users: NSArray = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectsTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell") as! ProjectTableViewCell
        let project: NSDictionary = (projectsTab.object(at: indexPath.row) as? NSDictionary)!
        if !(project["final_mark"] is NSNull) {
            if (project["validated?"] as? Bool)! {
                cell.projectNote.textColor = UIColor.green
            } else {
                cell.projectNote.textColor = UIColor.red
            }
            cell.projectNote.text = String(describing: project["final_mark"]!)
        } else {
            cell.projectNote.textColor = UIColor.orange
            cell.projectNote.text = project["status"] as? String
        }
        if let project: NSDictionary = self.projectsTab.object(at: indexPath.row) as? NSDictionary {
            let name: NSDictionary = (project["project"] as? NSDictionary)!
                cell.projectName.text = name["name"] as? String
        }
        return cell
    }
}
