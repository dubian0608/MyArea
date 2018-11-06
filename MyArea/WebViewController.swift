//
//  WebViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 28/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.isHidden = true
        
        let wkWebView = WKWebView(frame: view.frame)
        view.addSubview(wkWebView)
        wkWebView.autoresizingMask = [.flexibleHeight]
        
        let request = URLRequest(url: url)
//        webView.loadRequest(request)
        wkWebView.load(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
