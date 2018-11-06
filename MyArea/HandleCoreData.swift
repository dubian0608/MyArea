//
//  HandleCoreData.swift
//  MyArea
//
//  Created by Zhang, Frank on 22/04/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

import UIKit
import CoreData

class HandleCoreData: NSObject {
    
    class func insertData(area : AreasStruct){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let areaData = NSEntityDescription.insertNewObject(forEntityName: "Areas", into: context) as! Areas
        areaData.image = UIImagePNGRepresentation(area.image)! as NSData
        areaData.rating = UIImagePNGRepresentation(area.rating!)! as NSData
        areaData.name = area.name
        areaData.province = area.province
        areaData.part = area.part
        areaData.isVisted = area.isVisted
        
        do{
            try app.saveContext()
            print("成功存储")
        }catch{
            print("存储失败")
        }
    }

}
