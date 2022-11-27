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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonConfig(set: true)
        forwardGeocoding()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func pressAddButton(_ sender: Any) {
        buttonConfig(set: false)
        UdacityClient.postStudentLocation(mapString: targetLocation, mediaURL: mediaURL, coordinate: targetCoordinate, completion: handlePostStudentLocationResponse(response: error:))
    }
    
    func handlePostStudentLocationResponse(response:postStudentLocationResponse?,error:Error?){
        if let response = response{
            showAlertMessage(title: "Info is added!", message: "objectId:"+response.objectId+"\n"+"createdAt:"+response.createdAt)
        }
        else if let error = error{
            showAlertMessage(title: "Warning!",message: error.localizedDescription)
        }
        
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
        setActivity(activity: true) // this sets the activity indicator
        geocoder.geocodeAddressString(targetLocation, completionHandler: { [self] (placemarks, error) in
                if error != nil {
                    setActivity(activity: false)
                    showAlertMessage(title: "Warning!", message: "GeoCoding fail")
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
                    setActivity(activity: false)
                }
                else
                {
                    setActivity(activity: false)
                    showAlertMessage(title: "Warning!", message: "No Matching Location Found")
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
    func buttonConfig(set:Bool){
        if set{
            addButton.isEnabled = true
        }
        else{
            addButton.isEnabled = false
        }
    }
    func showAlertMessage(title:String, message:String){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler:nil))
        show(alertVC,sender: nil)
        
    }
    
    func setActivity(activity:Bool){
        if activity{
            self.activityIndicator.startAnimating()
        }
        else{
            self.activityIndicator.stopAnimating()
        }
    }

}
