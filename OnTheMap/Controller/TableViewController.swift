//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Yuan Gao on 11/21/22.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
        configureNavigationItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    private func configureNavigationItems(){
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddLocation)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(pressRefresh))
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(pressLogOut))
    }
    @IBAction func pressLogOut(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(sucess:error:))
        self.dismiss(animated: true)
    }
    
    @IBAction func pressRefresh(_ sender: Any) {
        UdacityClient.getStudentsLocation(completion: handleGetStudentsResponse(studentsLocation:error:))
    }
    
    func handleGetStudentsResponse(studentsLocation: getStudentsLocaitonResponse?, error: Error?)->Void{
        if let studentsLocation = studentsLocation{
            debugPrint("get students location sucessfully")
        }
        else{
            
        }
        
    }
    
    func handleLogoutResponse(sucess:Bool,error:Error?){
        if sucess{
            
        }
        else{
            showAlert(title: "Error", message: error!.localizedDescription)
        }
    }
    
    
    @IBAction func pressAddLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "PostInformation", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.studentsLocaiton.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocation")!
        let studentLocation = UdacityClient.studentsLocaiton.results[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = studentLocation.firstName+" "+studentLocation.lastName
        cell.detailTextLabel?.text = studentLocation.mediaURL
        //cell.textLabe2.text
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = UdacityClient.studentsLocaiton.results[(indexPath as NSIndexPath).row]
        
        let toOpen = studentLocation.mediaURL
        
        
        let toOpenURL = try? URL(string: toOpen)
        //debugPrint(toOpenURL)
        if let toOpenURL = toOpenURL{
            UIApplication.shared.open(toOpenURL, options: [:], completionHandler: nil)
        }
        else{
            showAlert(title:"No URL", message:"This user has no media URL")
        }
        

    }
    
    func showAlert(title:String, message:String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler:nil))
        self.present(alertVC,animated: true)
        
    }

}
