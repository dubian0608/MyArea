//
//  AreaTableViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 14/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import CoreData

class AreaTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    var areas : [Areas] = []
    var frc : NSFetchedResultsController<Areas>!
    var sc : UISearchController!
    var searchResults : [Areas] = []
    let buffer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        tableView.backgroundColor = UIColor(displayP3Red: 185/255.0, green: 255/255.0, blue: 234/255.0, alpha: 1.0)
        
        fetchAlldataByFRC()
        
        sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "search..."
//        sc.searchBar.tintColor = UIColor.white
//        sc.searchBar.barTintColor = tableView.backgroundColor
        sc.searchBar.searchBarStyle = .minimal
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        self.definesPresentationContext = true
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "guiderShowed"){
            return
        }
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuiderController") as? GuiderViewController{
            present(pageVC, animated: true, completion: nil)
        }
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        sc.isActive = false
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sc.isActive ? searchResults.count : areas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AreaTableViewCell

        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        
        let area = sc.isActive ? searchResults[indexPath.row] : areas[indexPath.row]
        
        cell.areaNameLabel?.text = area.name
        cell.areaImageView?.image = UIImage(data: area.image! as Data)//areas[indexPath.row].image
        cell.provinceLabel.text = area.province
        cell.partLabel.text = area.part
        
        cell.areaImageView.layer.cornerRadius = cell.areaImageView.frame.size.width / 2
        cell.areaImageView.clipsToBounds = true
        
//        cell.heartImageView.isHidden = !visted[indexPath.row]
        
        if area.isVisted {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.areas.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !sc.isActive
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareMenu = UITableViewRowAction(style: .normal, title: "Share") { (_, _) in
            let actionSheet = UIAlertController(title: nil, message: "Share to", preferredStyle: .actionSheet)
            let wx = UIAlertAction(title: "WeiChat", style: .default, handler: nil)
            let qq = UIAlertAction(title: "QQ", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(wx)
            actionSheet.addAction(qq)
            actionSheet.addAction(cancel)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        
        let deletMenu = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            let deletAlert = UIAlertController(title: nil, message: "Delete the message?", preferredStyle: .alert)
            let deletAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
//                let buffer1 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let itemToDel = self.frc.object(at: indexPath)
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.persistentContainer.viewContext.delete(itemToDel)
                appdelegate.saveContext()
                
//                self.areas.remove(at: indexPath.row)
//                
//                tableView.deleteRows(at: [indexPath], with: .fade)
                
//                let deletedAlert = UIAlertController(title: nil, message: "The message has been deleted!", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                deletedAlert.addAction(okAction)
//                
//                self.present(deletedAlert, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            deletAlert.addAction(deletAction)
            deletAlert.addAction(cancelAction)
            
            self.present(deletAlert, animated: true, completion: nil)
            
        }
        
        if indexPath.row % 2 == 0 {
            let markMenu = UITableViewRowAction(style: .normal, title: "Mark", handler: { (_, indexPath) in
                let markAlert = UIAlertController(title: nil, message: "Mark it", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.accessoryType = .checkmark
                })
                markAlert.addAction(ok)
                self.present(markAlert, animated: true, completion: nil)
                
                
            })
            
            markMenu.backgroundColor = UIColor.orange
            
            return [shareMenu, markMenu, deletMenu]
        }
        
        return [shareMenu, deletMenu]
        
    }
   
    // MARK: - Navigation
    
    @IBAction func close(segue: UIStoryboardSegue) {
//        let controller = segue.source as! AddAreaTableViewController
////        let area = controller.area
////        areas.append(area!)
//        tableView.reloadData()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowdetailArea" {
            let controller = segue.destination as! AreaDetailTableViewController

            controller.area = sc.isActive ? searchResults[tableView.indexPathForSelectedRow!.row] : areas[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    // MARK: -Fetched Result Controller Deleget
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRows(at: [_newIndexPath], with: .automatic)
            }
        case .delete:
            if let _indexPath = indexPath {
                tableView.deleteRows(at: [_indexPath], with: .automatic)
            }
        case .update:
            if let _indexPath = indexPath {
                tableView.reloadRows(at: [_indexPath], with: .automatic)
            }
        default:
            tableView.reloadData()
        }
        
        areas = controller.fetchedObjects as! [Areas]
    }
    
    func fetchAllData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            try appDelegate.persistentContainer.viewContext.fetch(Areas.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func fetchAlldataByFRC() {
        let request : NSFetchRequest<Areas> = Areas.fetchRequest()
        let sortDes = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDes]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
            areas = frc.fetchedObjects!
        } catch {
            print(error)
        }
    }
    
    //MARK: - UISearchResultsUpdater
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text{
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    
    func searchFilter(text: String)  {
        searchResults = areas.filter({ (area) -> Bool in
            return ((area.name?.localizedCaseInsensitiveContains(text))!
                || (area.province?.localizedCaseInsensitiveContains(text))!
                || (area.part?.localizedStandardContains(text))!
                || transform(text: area.name!).localizedCaseInsensitiveContains(text)
                || transform(text: area.province!).localizedCaseInsensitiveContains(text)
                || transform(text: area.part!).localizedCaseInsensitiveContains(text))
        })
    }
    
    func transform(text: String) -> String {
        let pinyin = text.mutableCopy()
        CFStringTransform(pinyin as! CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(pinyin as! CFMutableString, nil, kCFStringTransformStripCombiningMarks, false)
        let pinYinWithoutSpace = (pinyin as! String).replacingOccurrences(of: " ", with: "")
        return pinYinWithoutSpace
    }

}
