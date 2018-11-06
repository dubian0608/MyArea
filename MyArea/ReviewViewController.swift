//
//  ReviewViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 18/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    var ratingImage : UIImage?
    @IBOutlet weak var commentLabel: UILabel!

    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    @IBAction func ratingTap(_ sender: UIButton) {
        switch sender.tag {
        case 1000:
            ratingImage = #imageLiteral(resourceName: "dislike")
        case 1001:
            ratingImage = #imageLiteral(resourceName: "good")
        case 1002:
            ratingImage = #imageLiteral(resourceName: "great")
        default:
            break
        }
        
        performSegue(withIdentifier: "returnToDetailView", sender: self)
        
    }
   
    @IBAction func panAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let view = sender.view
            let point = sender.translation(in: view?.superview)
            let position = CGAffineTransform(translationX: point.x, y: point.y)
            let angle = sin(point.x / commentLabel.frame.width)
            commentLabel.transform = position.rotated(by: -angle)
//            print("changing")
            break
        case .ended:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [], animations: {
                self.commentLabel.transform = CGAffineTransform.identity
            }, completion: nil)
//            print("ended")
            break
        default:
            break
        }
    }
    
    
    var reviewImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurEffectView.frame = view.frame
        reviewImageView.addSubview(blurEffectView)
        
        reviewImageView.image = reviewImage
        
//        ratingStackView.transform = CGAffineTransform(scaleX: 0, y: 0)
        let startPos = CGAffineTransform(translationX: 0, y: 500)
        let startSca = CGAffineTransform(scaleX: 0, y: 0)
        ratingStackView.transform = startSca.concatenating(startPos)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [], animations: {
            let endPos = CGAffineTransform(translationX: 0, y: 0)
            let endSca = CGAffineTransform.identity
            self.ratingStackView.transform = endPos.concatenating(endSca)
        }, completion: nil)
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
