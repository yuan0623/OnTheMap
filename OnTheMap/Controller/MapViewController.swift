//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/21/22.
//
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var logOut: UIBarButtonItem!
    
    @IBOutlet weak var addLocation: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!

    var annotations = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.removeAnnotations(annotations)
        UdacityClient.getStudentsLocation(completion: handleGetStudentsResponse(studentsLocation:error:))
        // Do any additional setup after loading the view.
        configureNavigationItems()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func configureNavigationItems(){
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddLocation)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(pressRefresh))
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(pressLogOut))
    }
    
    @IBAction func pressRefresh(_ sender: Any) {
        UdacityClient.getStudentsLocation(completion: handleGetStudentsResponse(studentsLocation:error:))
    }
    
    
    @IBAction func pressLogOut(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(sucess:error:))
        self.dismiss(animated: true)
    }
    
    @IBAction func pressAddLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "PostInformation", sender: nil)
    }
    
    
    
    func handleLogoutResponse(sucess:Bool,error:Error?){
        if sucess{
            
        }
        else{
            showLogoutFailure(message: error!.localizedDescription)
        }
    }
    
    func handleGetStudentsResponse(studentsLocation: getStudentsLocaitonResponse?, error: Error?)->Void{
        if let studentsLocation = studentsLocation{
            debugPrint("get students location sucessfully")
            for studentLocation in studentsLocation.results{
                // Notice that the float values are being used to create CLLocationDegree values.
                //print(studentLocation.firstName)
                
                // This is a version of the Double type.
                let lat = studentLocation.latitude
                let long = studentLocation.longitude
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = studentLocation.firstName
                let last = studentLocation.lastName
                let mediaURL = studentLocation.mediaURL
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
        }
        else{
            showAlert(title:"Error", message:"Cannot obtain student info")
        }
        
    }
    
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("pin is tabed")
        DispatchQueue.main.async {
            if control == view.rightCalloutAccessoryView {
                if let toOpen = view.annotation?.subtitle{
                    if let toOpen = toOpen{
                        if let toOpenURL = URL(string:toOpen){
                            UIApplication.shared.open(toOpenURL, options: [:], completionHandler: nil)
                        }
                        else{
                            self.showAlert(title:"No URL", message:"This user has no media URL")
                        }
                    }
                    else{
                        self.showAlert(title:"No URL", message:"This user has no media URL")
                    }
                    
                }
                else{
                    self.showAlert(title:"No URL", message:"This user has no media URL")
                }
            }
        }
    }
    
    func showLogoutFailure(message:String){
        let alertVC = UIAlertController(title: "Logout Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler:nil))
        show(alertVC,sender: nil)
        
    }
    
    func showAlert(title:String, message:String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler:nil))
        self.present(alertVC,animated: true)
        
    }
    
    
    
    
}
