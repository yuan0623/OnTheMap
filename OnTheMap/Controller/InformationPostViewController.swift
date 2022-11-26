//
//  InformationPosttViewController.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/23/22.
//

import UIKit
import MapKit

class InformationPostViewController: UIViewController {

    @IBOutlet weak var addressTextfield: UITextField!
    
    @IBOutlet weak var mediaLinkTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextfield.text = ""
        mediaLinkTextField.text = ""
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation"{
            let AddLocationViewController = segue.destination as! AddLocationViewController
            
            let targetLocation = sender as! String
            AddLocationViewController.targetLocation = targetLocation
        }
    }
    
    @IBAction func pressFindLocationButton(_ sender: Any) {
        if let targetLocation = addressTextfield.text{
            let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.performSegue(withIdentifier: "findLocation", sender: targetLocation)
        }
        
        //self.navigationController?.pushViewController(addLocationViewController, animated: true)
        
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
