//
//  AboutTableViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 28/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitle = ["反馈", "关注"]
    var sectionContent = [["评分", "反馈意见"], ["网站", "博客", "学习路线"]]
    var link = ["http://www.xiaoboswift.com/", "http://blog.xiaoboswift.com/", "http://blog.xiaoboswift.com/roadmap/"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 2 : 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                if let url = URL(string: "http://www.baidu.com"){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }else{
//                prepare(for: UIStoryboardSegue, sender: self)
                performSegue(withIdentifier: "ShowWebView", sender: self)
            }
        case 1:
            if let url = URL(string: link[indexPath.row]){
                let sfView = SFSafariViewController(url: url)
                present(sfView, animated: true, completion: nil)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        if identifier == "ShowWebView" {
//            let controller = destination as! WebViewController
//            if let url = URL(string: "http://www.baidu.com"){
//                controller.url = url
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            let controller = segue.destination as! WebViewController
            if let url = URL(string: link[(tableView.indexPathForSelectedRow?.row)!])
//            if let url = URL(string: "http://www.baidu.com")
            {
                controller.url = url
            }
            
        }
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
