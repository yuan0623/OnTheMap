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
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        ]
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
    

}
