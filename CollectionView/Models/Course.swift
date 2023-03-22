//
//  Course.swift
//  CollectionView
//
//  Created by Elizabeth on 20/03/2023.
//

import Foundation

struct Course: Codable {
    let name: String?
    let imageUrl: URL?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}

struct SwiftBookInfo: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?
}
