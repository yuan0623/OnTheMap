//
//  ViewController.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/8/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.text = ""
        passwordTextField.text = ""
        activityIndicator.isHidden = true
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        setLogIn(logingIn: true)
        UdacityClient.login(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(sucess:error:))
        print("tapped")
    }
    
    func handleLoginResponse(sucess:Bool,error:Error?){
        setLogIn(logingIn: false)
        print(sucess)
        if sucess{
            print("login sucessfully")
            //TMDBClient.createSessionID(completion: handleSessionResponse(sucess:error:))
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
            
        }
        else
        {
            showLoginFailure(message: error?.localizedDescription ?? "")

            print("login fails")
        }
        
    }
    
    
    func setLogIn(logingIn:Bool){
        if logingIn{
            activityIndicator.startAnimating()
        }
        else{
            activityIndicator.stopAnimating()
        }
        loginButton.isEnabled = !logingIn
        usernameTextField.isEnabled = !logingIn
        passwordTextField.isEnabled = !logingIn
        //loginViaWebsiteButton.isEnabled = !logingIn
    }
    
    func showLoginFailure(message:String){
        let alertVC = UIAlertController(title: "Login Failed haha", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK xixi", style: .default,handler:nil))
        show(alertVC,sender: nil)
        
    }
    
}

