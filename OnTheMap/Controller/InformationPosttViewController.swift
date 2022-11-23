//
//  InformationPosttViewController.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/23/22.
//

import UIKit
import MapKit

class InformationPosttViewController: UIViewController {

    @IBOutlet weak var addressTextfield: UITextField!
    
    @IBOutlet weak var mediaLinkTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextfield.text = ""
        mediaLinkTextField.text = ""
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func pressFindLocationButton(_ sender: Any) {
        let a = MKLocalSearch
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
