//
//  MovieSearchResponse.swift
//  MoviesJP
//
//  Created by iJPe on 2/27/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation

//MARK: - MovieSearchResponse
class MovieSearchResponse: Codable {
    let page: Int
    let results: [MSearch]
    let totalResults, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    init(page: Int, results: [MSearch], totalResults: Int, totalPages: Int) {
        self.page = page
        self.results = results
        self.totalResults = totalResults
        self.totalPages = totalPages
    }
}

//MARK: - MSearch
class MSearch: Movie {
}
