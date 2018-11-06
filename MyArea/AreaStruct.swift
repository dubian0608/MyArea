//
//  AreaStruct.swift
//  MyArea
//
//  Created by ZhangJi on 21/08/2017.
//  Copyright © 2017 Zhang, Frank. All rights reserved.
//

struct City: Decodable {
    let name: String
    let area: [String]
}

struct Province: Decodable {
    let name: String
    let city: [City]
}
