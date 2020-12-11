//
//  StateData.swift
//  PocketFauci
//
//  Created by Morgan Prime on 11/23/20.
//

import Foundation

struct MovieData: Codable {
    var title: String?
    var overview: String?
    var id: Int?
    var release_date: String?
    var poster_path: String?
    var original_language: String?
}

struct MovieResults: Codable {
    var results: [MovieData]
}
