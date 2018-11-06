//
//  MapViewController.swift
//  MyArea
//
//  Created by Zhang, Frank on 20/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var area : Areas!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(area.name!) { (ps, error) in
            guard let ps = ps else {
                print(error ?? "Unkonw error")
                return
            }
            
            let place = ps.first
            let annotation = MKPointAnnotation()
            annotation.title = self.area.name
            annotation.subtitle = self.area.province
            
            if let loc = place?.location{
                annotation.coordinate = loc.coordinate
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)            }
        }
        
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.showsCompass = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map view delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let id = "MyAnnotation"
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView
        
        if av == nil{
            av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            av?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: area.image! as Data)
        av?.leftCalloutAccessoryView = leftIconView
        av?.pinTintColor = UIColor.green
        
        return av
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
