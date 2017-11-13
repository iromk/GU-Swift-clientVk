//
//  ViewController.swift
//  clientVk
//
//  Created by Roman Syrchin on 10/26/17.
//  Copyright © 2017 Roman Syrchin. All rights reserved.
//

import UIKit
import WebKit

class LoginController: UIViewController {

    @IBAction func onReloginTap(_ sender: Any) {
        
        let vk = Auth.VkProvider(forApp: "6247718", relogin: true)
        vkAuthWebView
            .load(userSession
                .requestAuthorizationUrl(through: vk))
    }
    
    let SegueAuthOK = "authOK"
    @IBOutlet weak var vkAuthWebView: WKWebView!  {
        didSet{
            vkAuthWebView.navigationDelegate = self
        }
    }
    
    enum InputError: Error {
        case ValueEmpty(explain: String)
    }
    
    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    let userSession: UserSession = UserSession.getInstance()
    
    override func viewDidLoad() {
//        print("login viewDidLoad")
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("login viewDidAppear")
        super.viewDidAppear(animated)
        if userSession.state == .opened {
//            print("perform segue")
            performSegue(withIdentifier: SegueAuthOK, sender: self)
            return
        }
        let vk = Auth.VkProvider(forApp: "6247718")
        vkAuthWebView.isHidden = false
        vkAuthWebView
            .load(userSession
                .requestAuthorizationUrl(through: vk))
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true // vk rules
        /*
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
        }*/
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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)

            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        let userId = Int(params["user_id"]!)!
        userSession.authorize(account: userId, with: token!)
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: SegueAuthOK, sender: self)
    }
}

