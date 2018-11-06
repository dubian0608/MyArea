//
//  ContentViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 27/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var pageImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var doneButton: UIButton!
    
    var index = 0
    var header = ""
    var fooder = ""
    var image : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headLabel.text = header
        foodLabel.text = fooder
        pageImage.image = image
        pageControl.currentPage = index
        
        doneButton.isHidden = !(index == 2)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushDoneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guiderShowed")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
