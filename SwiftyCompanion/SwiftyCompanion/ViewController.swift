//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Basile Durst on 26/07/2017.
//  Copyright © 2017 Basile Durst. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Login: UITextField!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var ActivityMonitor: UIActivityIndicatorView!
    
    var token = ""
    var dic: NSDictionary? = nil
    var search: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Login.becomeFirstResponder()
        Login.autocorrectionType = .no
        Button.layer.cornerRadius = 5
        Button.isEnabled = false
        Button.alpha = 0.5
        Button.isHidden = true
        // print("WESHHHH")
        self.ActivityMonitor.startAnimating()
        getToken()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.search = false
        if ((Login.text?.characters.count)! > 0)
        {
            Button.isEnabled = true
            Button.alpha = 1.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "InfosStudentSegue") {
            if let infosStudent = segue.destination as? InfosStudent {
                infosStudent.dic = self.dic!
            }
        }
    }
    
    @IBAction func SearchLogin(_ sender: Any) {
        var loginWithoutSpace = Login.text?.components(separatedBy: .whitespaces).joined()
        Button.alpha = 0.5
        Login.text? = loginWithoutSpace!
        if ((loginWithoutSpace?.characters.count)! > 0 && self.search == false) {
            self.search = true
            getInfosStudent(token: token, login: loginWithoutSpace!)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var loginWithoutSpace = Login.text?.components(separatedBy: .whitespaces).joined()
        Button.alpha = 0.5
        Login.text? = loginWithoutSpace!
        if ((loginWithoutSpace?.characters.count)! > 0 && self.search == false) {
            self.search = true
            getInfosStudent(token: token, login: loginWithoutSpace!)
            
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.characters.count)! + string.characters.count - range.length > 0) {
            Button.isEnabled = true
            Button.alpha = 1.0
        }
        else {
            Button.isEnabled = false
            Button.alpha = 0.5
        }
        return true
    }
    
    func alert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title  + " 😡", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: buttonTitle, style: .default)
            {
                action in alertController.dismiss(animated: true, completion: nil)
                if (buttonTitle != "OK") {
                    self.getToken()
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getToken() {
        let consumerKey = "d4eef5f8493a5fe6783f178fe538c069055ba4edfd0b452a9ab59f840d01e503"
        let consumerSecret =  "5484feb043559f66392be7224f2741e858d17e4fae85dea555ef9bdee3ecdf4c"
        let bearer = ((consumerKey + ":" + consumerSecret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
        (data, response, Error) in
           //print(response as Any)
            if Error != nil {
                let error: NSError = Error! as NSError
                self.alert(title: "Get token failure !", message: error.localizedDescription, buttonTitle: "Retry")
                //print(error.localizedDescription)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self.token = dic["access_token"]! as! String
                      //  print("WTF")
                        DispatchQueue.main.async {
                            self.ActivityMonitor.stopAnimating()
                            self.Button.isHidden = false
                        }
                        //print(dic)
                    }
                }
                catch (let Err) {
                    let err: NSError = Err as NSError
                    self.alert(title: "Get token failure !", message: err.localizedDescription, buttonTitle: "Retry")
                }
            }
        }
        task.resume()
    }
    
    func getInfosStudent(token: String, login: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)")
        var request = URLRequest(url: url! as URL)
        
        //print("GETTTT")
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            //print(response as Any)
            //print(error as Any)
            //print("??????")
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
              //      print("get Token 401")
                   // self.search = false
                    self.getToken()
                    self.getInfosStudent(token: self.token, login: self.Login.text!)
                }
                else if httpResponse.statusCode == 404 {
                    self.alert(title: "Get infos student failure !", message: "Login not found", buttonTitle: "OK")
                    self.search = false
                }
                else if let d = data {
                 //   print("NON PLS")
                    do {
                        if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            // print(dic)
                            self.dic = dic
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "InfosStudentSegue", sender: self)
                            }
                        }
                    }
                    catch (let err) {
                   //     print("Error")
                        self.alert(title: "Get infos student failure !", message: err as! String, buttonTitle: "OK")
                     //   print(err)
                        self.search = false
                    }
                }
            }
            else if error != nil {
                let Error: NSError = error! as NSError
                self.alert(title: "Get token failure !", message: Error.localizedDescription, buttonTitle: "OK")
                //print(Error.localizedDescription)
                self.search = false
            }
        }
        task.resume()
    }
}

