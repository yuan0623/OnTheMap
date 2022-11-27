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
        debugPrint("log in loaded.")
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        setLogIn(logingIn: true)
        UdacityClient.login(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(sucess:error:))
        debugPrint("tapped")
    }
    
    func handleLoginResponse(sucess:Bool,error:Error?){
        setLogIn(logingIn: false)
        if sucess{
            debugPrint("login sucessfully")
            UdacityClient.getUserPublicData(userId: self.usernameTextField.text ?? "", completion: handleGetUserPublicDataResponse(sucess: error:))
            
            //TMDBClient.createSessionID(completion: handleSessionResponse(sucess:error:))
            
            
        }
        else
        {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
        
    }
    func handleGetUserPublicDataResponse(sucess:Bool,error:Error?){
        if sucess{
            print("get user public data sucessfully")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        }
        else{
            showLoginFailure(message:"fail ut retrive user public data")
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
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler:nil))
        show(alertVC,sender: nil)
        
    }
    
    func handleGetStudentsResponse(studentsLocation: getStudentsLocaitonResponse?, error: Error?)->Void{
        if let studentsLocation = studentsLocation{
            debugPrint("get students location sucessfully")
        }
        else{
            
        }
        
    }
    
}

