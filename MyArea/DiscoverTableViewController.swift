//
//  DiscoverTableViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 04/05/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController {
    var areas : [AVObject] = []

    @IBOutlet var spiner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.center = view.center
        
        getObjectsFromCloud()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.reFreshData(_:)), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AreaTableViewCell
        
        let area = areas[indexPath.row]
        
        cell.areaNameLabel?.text = area["Name"] as? String
        cell.provinceLabel?.text = area["Province"] as? String
        cell.partLabel?.text = area["Part"] as? String
        cell.areaImageView.image = #imageLiteral(resourceName: "photoalbum")
        cell.areaImageView.layer.cornerRadius = cell.areaImageView.frame.size.width / 2
        cell.areaImageView.clipsToBounds = true

        if let imageFile = area["Image"] as? AVFile{
            imageFile.getDataInBackground({ (data, error) in
                if let data = data {
                    OperationQueue.main.addOperation {
                        cell.areaImageView?.image = UIImage(data: data)
                    }
                }else{
                    print(error ?? "Get image error")
                }
            })
            
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getObjectsFromCloud(needUpdate : Bool = false) {
        view.addSubview(spiner)
        
        let query = AVQuery(className: "Area")
        query.order(byDescending: "createdAt")
        
        if needUpdate{
            query.cachePolicy = .ignoreCache
        }else{
            query.cachePolicy = .cacheElseNetwork
            query.maxCacheAge = 60 * 2
        }
        
        if query.hasCachedResult(){
            print("Get data from cache")
        }
        
        query.findObjectsInBackground { (results, error) in
            if let results = results as? [AVObject] {
                self.areas = results
                OperationQueue.main.addOperation {
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    self.spiner.stopAnimating()
                }
                
            }else{
                print(error ?? "Unkonw error!")
            }
        }
    }
    

    @IBAction func reFreshData(_ sender: UIBarButtonItem) {
        getObjectsFromCloud(needUpdate: true)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
