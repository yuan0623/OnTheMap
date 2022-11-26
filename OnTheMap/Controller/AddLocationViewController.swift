//
//  addLocationViewController.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/21/22.
//

import UIKit
import CoreLocation
import MapKit
class AddLocationViewController: UIViewController {
    
    var targetLocation:String = ""
    var mediaURL:String = ""
    var targetCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forwardGeocoding()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func pressAddButton(_ sender: Any) {
        
    }
    
    @IBAction func pressDismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func addPin(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = targetCoordinate
        //annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        var region = MKCoordinateRegion(center: targetCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

        self.mapView.addAnnotation(annotation)
        //self.mapView.setCenter(targetCoordinate, animated: true)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func forwardGeocoding() {
            let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(targetLocation, completionHandler: { [self] (placemarks, error) in
                if error != nil {
                    showFailureMessage(message: "GeoCoding fail")
                    return
                }
                
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    let coordinate = location.coordinate
                    print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                    self.targetCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    self.addPin()
                }
                else
                {
                    showFailureMessage(message: "No Matching Location Found")
                }
            })
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showFailureMessage(message:String){
        let alertVC = UIAlertController(title: "Fail to find loction", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler:nil))
        show(alertVC,sender: nil)
        
    }

}
