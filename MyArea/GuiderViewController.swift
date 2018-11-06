//
//  GuiderViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 27/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit

class GuiderViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var headers = ["Swift 3.1", "iOS 10", "零基础"]
    var fooders = ["Swift 3.1 是啥吗？", "iOS 10 好像很牛逼的样子", "请默默的看我装逼"]
    var images = [#imageLiteral(resourceName: "swift"), #imageLiteral(resourceName: "iOS"), #imageLiteral(resourceName: "beginner")]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let startVC = getVC(atIndex: 0){
            setViewControllers([startVC], direction: .reverse, animated: true, completion: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Page view controller data source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        
        index -= 1
        
        return getVC(atIndex: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        
        index += 1
        
        return getVC(atIndex: index)
    }
    
    
    func getVC(atIndex: Int) -> ContentViewController? {
        if case 0..<headers.count = atIndex {
            if let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentController") as? ContentViewController {
                contentVC.header = headers[atIndex]
                contentVC.fooder = fooders[atIndex]
                contentVC.image = images[atIndex]
                contentVC.index = atIndex
                
                return contentVC
            }
        }
        return nil
    }
    

}
