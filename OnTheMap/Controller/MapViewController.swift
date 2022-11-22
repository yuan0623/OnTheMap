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
        print("map view loaded!")
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
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        ]
    }
    
    

    
    @IBAction func pressLogOut(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(sucess:error:))
    }
    
    @IBAction func pressAddLocation(_ sender: Any) {
        print("add location pressed")
        let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.navigationController?.pushViewController(addLocationViewController, animated: true)
    }
    
    
    
    func handleLogoutResponse(sucess:Bool,error:Error?){
        if sucess{
            
        }
        else{
            
        }
    }
    
    func handleGetStudentsResponse(studentsLocation: getStudentsLocaitonResponse?, error: Error?)->Void{
        if let studentsLocation = studentsLocation{
            print("get students location sucessfully")
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
            
        }
        
    }
    
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
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
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    
    
    
    
}
