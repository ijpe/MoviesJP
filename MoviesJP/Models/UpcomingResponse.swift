//
//  UpcomingResponse.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation

//MARK: - UpcomingResponse
class UpcomingResponse: Codable {
    let page: Int?
    let results: [MUpcoming]
    let totalResults, totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    init(page: Int?, results: [MUpcoming]?, totalResults: Int?, totalPages: Int?) {
        self.page = page
        self.results = results!
        self.totalResults = totalResults
        self.totalPages = totalPages
    }
}

//MARK: - MUpcoming
class MUpcoming: Movie {
}
