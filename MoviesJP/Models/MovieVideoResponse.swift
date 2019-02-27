//
//  MovieVideoResponse.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation

//MARK: - MovieVideoResponse
class MovieVideoResponse: Codable {
    let id: Int?
    let results: [MVideo]
    
    init(id: Int?, results: [MVideo]) {
        self.id = id
        self.results = results
    }
}

//MARK: - MVideo
class MVideo: Codable {
    let id, iso639_1, iso3166_1, key: String?
    let name, site: String?
    let size: Int?
    let type: String?
    
    init(id: String?, iso639_1: String?, iso3166_1: String?, key: String?, name: String?, site: String?, size: Int?, type: String?) {
        self.id = id
        self.iso639_1 = iso639_1
        self.iso3166_1 = iso3166_1
        self.key = key
        self.name = name
        self.site = site
        self.size = size
        self.type = type
    }
}
