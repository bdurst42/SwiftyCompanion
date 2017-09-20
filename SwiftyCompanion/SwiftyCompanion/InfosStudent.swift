
//
//  InfosStudent.swift
//  SwiftyCompanion
//
//  Created by Basile Durst on 26/07/2017.
//  Copyright © 2017 Basile Durst. All rights reserved.
//

import UIKit

class InfosStudent: UIViewController,
UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Login: UILabel!
    @IBOutlet weak var Wallets: UILabel!
    @IBOutlet weak var correctionPoints: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var levelBar: UIProgressView!
    
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var Projects: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dic: NSDictionary? = nil
    var numberOfCells = 2
    var projectsTab: NSArray = []
    var skills: NSArray = []
    var heightProjects:CGFloat = 0
    var heightSkills: CGFloat = 0
    
    @IBOutlet weak var dynamicTVHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 8.0)
        levelBar.transform = transform
        fillInfosStudent(dic: self.dic!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = min(self.view.bounds.size.height, Projects.contentSize.height)
        dynamicTVHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Projects.reloadData()
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.cornerRadius = (profilePicture.frame.width / 2)
        profilePicture.clipsToBounds = true

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectsCell") as! ProjectsTableViewCell
            cell.projectsTab = self.projectsTab
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsCell") as!SkillsTableViewCell
            cell.skills = self.skills
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == 0) {
            if (projectsTab.count > 0) {
                return 300
            } else {
                return 30
            }
        } else {
            if (skills.count > 0) {
                return 300
            }
            else {
                return 30
            }
        }
    }
    
    func fillInfosStudent(dic: NSDictionary) {
            if let wallets = dic["wallet"] {
                self.Wallets.text = "Wallets: " + String(describing: wallets)
            }
            if let corPts = dic["correction_point"] {
                self.correctionPoints.text = "Correction Points: " + String(describing: corPts)
            }
            let  array: NSArray =  (dic["cursus_users"] as? NSArray)!
        let cursus_users: NSDictionary =  (array[0] as? NSDictionary)!
            skills =  (cursus_users["skills"] as? NSArray)!
            self.Name.text = (dic["displayname"] as? String)! + " -"
            self.Login.text = dic["login"] as? String
        if let level: Float = cursus_users["level"] as? Float {
                self.Level.text = String(describing: level)
                levelBar.progress = Float(level - Float(Int(level)))
            }
            self.Phone.text = dic["phone"] as? String
            self.Email.text = dic["email"] as? String
        if let location: String =  dic["location"] as? String {
            self.Location.text = location
            self.Location.textColor = UIColor.white
        }
        else
        {
            self.Location.text = "Unavailable"
            self.Location.textColor = UIColor.red
        }
        if let url = URL(string: (dic["image_url"] as? String)!)
        {
            if let data = try? Data(contentsOf: url) {
                self.profilePicture.image = UIImage(data: data)
            }
        }
        self.projectsTab =  (dic["projects_users"] as? NSArray)!
    }
}
