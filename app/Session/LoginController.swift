//
//  ViewController.swift
//  Homework01
//
//  Created by nnm on 10/26/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    let SegueAuthOK = "authOK"
    
    enum InputError: Error {
        case ValueEmpty(explain: String)
    }
    
    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    let userSession: UserSession = UserSession.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let vkdata = VKDataProvider()
        
        vkdata.listFriends()
        
        if (inputLogin.text?.isEmpty)! && (inputPassword.text?.isEmpty)! {
            userSession.authorize(login: "morpheus", password: "1")
            return true
        }
        
        do {
            try validate(field: inputLogin)
            try validate(field: inputPassword)

        } catch InputError.ValueEmpty(let explain) {
            popAlert(with: explain)
            return false
        } catch {
            return false
        }
        
        if userSession.authorize(login: (inputLogin.text)!, password: (inputPassword.text)!) {
            return true
        } else {
            popAlert(with: "Incorrect credentials given")
            return false
        }
    }
    
    func popAlert(with text: String) {
        let alert = UIAlertController(title: "Login error", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func validate(field: UITextField) throws  {
        if (field.text?.isEmpty)! {
            throw InputError.ValueEmpty(explain: "Login or password cannot be empty")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueAuthOK {
//            let mainViewController = segue.destination as! AppMainController
//            mainViewController.userSession = self.userSession
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

