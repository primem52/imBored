//
//  StateData.swift
//  PocketFauci
//
//  Created by Morgan Prime on 11/23/20.
//

import Foundation

struct TVData: Codable {
    var first_air_date: String?
    var id: Int?
    var name: String?
    var origin_country: [String]?
    var overview: String?
    var poster_path: String?
}

struct ShowResults: Codable {
    var results: [TVData]
}
