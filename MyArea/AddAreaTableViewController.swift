//
//  AddAreaTableViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 20/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import AVFoundation


class AddAreaTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var isVisted: UISegmentedControl!
    @IBOutlet weak var isVistedLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var playButton: UIButton!
    
    var isVistedValue : Bool! = false
    var isVideo : Bool = false
    var place: [Province]!
    var videoData: Data!
    var videoLocalUrl: URL!
    
    var documentDir: URL! {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
//    var area : Areas!

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.url(forResource: "area", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: path!)
            //let data = try Data.init(referencing: NSData.init(contentsOfFile: path!))
            place = try JSONDecoder().decode([Province].self, from: data)
            
        } catch  {
           print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveToCloud(area : Areas!) {
        let cloudObject = AVObject(className: "Area")
        cloudObject["Name"] = area.name!
        cloudObject["Province"] = area.province!
        cloudObject["Part"] = area.part!
        cloudObject["IsVisted"] = area.isVisted
        
        let originImage = UIImage(data: area.image! as Data)
        let scale = ((originImage?.size.width)! > 1024.0) ? (1024.0 / (originImage?.size.width)!) : 1
        let scaleImage = UIImage(data: area.image! as Data, scale: scale)!
        let imageFile = AVFile(name: "\(String(describing: area.name!)).jpg", data: UIImageJPEGRepresentation(scaleImage, 0.7)!)
        
        cloudObject["Image"] = imageFile
        
        cloudObject.saveInBackground { (succeed, error) in
            if succeed{
                print("保存成功")
            }else{
                print(error ?? "Unkonw error")
            }
        }
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let chooseSource = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let photoLibrary = UIAlertAction(title: "从相册选择", style: .default, handler: { (_) in
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    print("相册不可以")
                    return
                }
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                
                self.present(picker, animated: true, completion: nil)
            })
            let camera = UIAlertAction(title: "拍摄", style: .default, handler: { (_) in
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    self.showAlter(alter: "相机不可用")
                    return
                }
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                
                self.present(picker, animated: true, completion: nil)
            })
            
            let video = UIAlertAction(title: "来段视频", style: .default, handler: { (_) in
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    self.showAlter(alter: "相机不可用")
                    return
                }
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.mediaTypes = [kUTTypeMovie as String]
                
                self.present(picker, animated: true, completion: nil)
                
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            chooseSource.addAction(photoLibrary)
            chooseSource.addAction(camera)
            chooseSource.addAction(video)
            chooseSource.addAction(cancel)
            
            self.present(chooseSource, animated: true, completion: nil)
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        dump(info)
        if info.keys.first == "UIImagePickerControllerMediaURL" {
            isVideo = true
            let filePath = info[UIImagePickerControllerMediaURL] as! NSURL
            do {
                videoData = try Data(contentsOf: filePath as URL)

                let urlAsset = AVURLAsset(url: filePath as URL)
                let generator = AVAssetImageGenerator(asset: urlAsset)
                generator.appliesPreferredTrackTransform = true
                let cgImage = try generator.copyCGImage(at: CMTimeMake(0, 10), actualTime: nil)
                coverImageView.image = UIImage(cgImage: cgImage)
                playButton.isHidden = false
            } catch  {
                print(error)
            }
        }else{
            coverImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        
        let coverImageWidth = NSLayoutConstraint(item: coverImageView, attribute: .width, relatedBy: .equal, toItem: coverImageView.superview, attribute: .width, multiplier: 1, constant: 0)
        let coverImageHeigth = NSLayoutConstraint(item: coverImageView, attribute: .height, relatedBy: .equal, toItem: coverImageView.superview, attribute: .height, multiplier: 1, constant: 0)
        
        coverImageWidth.isActive = true
        coverImageHeigth.isActive = true
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func isVistedCheck(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isVistedValue = true
            isVistedLabel.text = "我来过"
        default:
            isVistedValue = false
            isVistedLabel.text = "我没来过"
        }
    }
    @IBAction func addArea(_ sender: UIBarButtonItem) {
//        let buffer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let area = NSEntityDescription.insertNewObject(forEntityName: "Areas", into: buffer) as! Areas
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let area = Areas(context: appDelegate.persistentContainer.viewContext)
//        area.image = UIImagePNGRepresentation(coverImageView.image!) as NSData?
        area.image = UIImageJPEGRepresentation(coverImageView.image!, 0.7) as NSData?
        area.name = name.text!
        area.province = place[pickerView.selectedRow(inComponent: 0)].name
        area.part = place[pickerView.selectedRow(inComponent: 0)].city[pickerView.selectedRow(inComponent: 1)].name
        area.isVisted = isVistedValue
        area.rating = UIImagePNGRepresentation(#imageLiteral(resourceName: "rating"))! as NSData
        
        if isVideo {
            do {
                videoLocalUrl = documentDir.appendingPathComponent("\(String(describing: name.text!)).mp4")

                try videoData.write(to: videoLocalUrl)
            } catch  {
                print(error)
            }
            area.isVideo = isVideo
        }
        
        appDelegate.saveContext()
        
        saveToCloud(area: area)
        
        performSegue(withIdentifier: "addNewArea", sender: self)
    }
    
}

extension AddAreaTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return place.count
        case 1:
            return place[pickerView.selectedRow(inComponent: 0)].city.count
        case 2:
            return place[pickerView.selectedRow(inComponent: 0)].city[pickerView.selectedRow(inComponent: 1)].area.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return place[row].name
        case 1:
            return place[pickerView.selectedRow(inComponent: 0)].city[row].name
        case 2:
            return place[pickerView.selectedRow(inComponent: 0)].city[pickerView.selectedRow(inComponent: 1)].area[row]
        default:
            return "0"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.pickerView.selectRow(0, inComponent: 1, animated: true)
            self.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerView.reloadComponent(1)
            self.pickerView.reloadComponent(2)
        case 1:
            self.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerView.reloadComponent(2)
            
        default:
            return
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 100
        case 1:
            return 120
        case 2:
            return 140
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .center
//        pickerLabel.font = UIFont(name: "AmericanTypewriter", size: 15)
        pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel
    }
}

extension AddAreaTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddAreaTableViewController {
    func showAlter(alter: String!) {
        if let alter = alter {
            let alter = UIAlertController(title: nil, message: alter, preferredStyle: .alert)
            self.present(alter, animated: true, completion: nil)
        }
    }
}

















