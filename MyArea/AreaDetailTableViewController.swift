//
//  AreaDetailTableViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 17/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import AVKit

class AreaDetailTableViewController: UITableViewController {
 
    @IBOutlet weak var areaImageView: UIImageView!

    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    var area : Areas!

    var videoLocalUrl: URL!
    
    var documentDir: URL! {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = URL(fileURLWithPath: area.url!)
//        let urls = area!.url!
//        print(urls)
//        print(url)
        self.areaImageView.image = UIImage(data: area.image! as Data)
//        let ratingImage = UIImage(data: area.rating! as Data)
        self.ratingButton.setImage(UIImage(data: area.rating! as Data), for: .normal)
        
//        tableView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        tableView.backgroundColor = UIColor(displayP3Red: 185/255.0, green: 255/255.0, blue: 234/255.0, alpha: 1.0)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = area.name
        playButton.isHidden = !area.isVideo
        
//        self.areaName.text = area.name
//        self.areaImageView.image = area.image
//        self.provinceLabel.text = area.province
//        self.partLabel.text = area.part
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [], animations: { 
            let endPos = CGAffineTransform(translationX: 0, y: 0)
            let endSca = CGAffineTransform.identity
            self.ratingButton.transform = endPos.concatenating(endSca)
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "地名"
            cell.valueLabel.text = area.name
        case 1:
            cell.fieldLabel.text = "省"
            cell.valueLabel.text = area.province
        case 2:
            cell.fieldLabel.text = "地区"
            cell.valueLabel.text = area.part
        case 3:
            cell.fieldLabel.text = "是否去过"
            cell.valueLabel.text = area.isVisted ?"去过":"没去过"
        default:
            break
        }
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


        // MARK: - Navigation
    @IBAction func close(segue : UIStoryboardSegue) {
        let controller = segue.source as! ReviewViewController
        self.area.rating = UIImagePNGRepresentation(controller.ratingImage!) as NSData?
//        area.rating = UIImagePNGRepresentation(UIImage(named: "image"))
        self.ratingButton.setImage(controller.ratingImage, for: .normal)
        let startPos = CGAffineTransform(translationX: 0, y: 500)
        let startSca = CGAffineTransform(scaleX: 0, y: 0)
        self.ratingButton.transform = startSca.concatenating(startPos)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let controller = segue.destination as! ReviewViewController
            controller.reviewImage = UIImage(data: area.image! as Data)
            controller.ratingImage = ratingButton.image(for: .normal)
        } else if segue.identifier == "showMap"{
            let controller = segue.destination as! MapViewController
            controller.area = area
        } else {
            videoLocalUrl = documentDir.appendingPathComponent("\(String(describing: area.name!)).mp4")
            let dest = segue.destination as! AVPlayerViewController
                    print("即将播放：",videoLocalUrl)
            dest.player = AVPlayer(url: videoLocalUrl)
            dest.player?.play()
        }
        
    }
    

    

}
