//
//  PopularResponse.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation

class PopularResponse: Codable {
    let page: Int?
    let results: [PopularMovies]
    let totalResults, totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    init(page: Int?, results: [PopularMovies]?, totalResults: Int?, totalPages: Int?) {
        self.page = page
        self.results = results!
        self.totalResults = totalResults
        self.totalPages = totalPages
    }
}

class PopularMovies: Codable {
    var posterPath: String?
    var adult: Bool?
    var overview, releaseDate: String?
    var genreIDS: [Int]?
    var id: Int?
    var originalTitle: String?
    var originalLanguage: String?
    var title, backdropPath: String?
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)!
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)!
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)!
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)!
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)!
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)!
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.posterPath, forKey: .posterPath)
        try container.encode(self.adult, forKey: .adult)
        try container.encode(self.overview, forKey: .overview)
        try container.encode(self.releaseDate, forKey: .releaseDate)
        try container.encode(self.genreIDS, forKey: .genreIDS)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.originalTitle, forKey: .originalTitle)
        try container.encode(self.originalLanguage, forKey: .originalLanguage)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.backdropPath, forKey: .backdropPath)
        try container.encode(self.popularity, forKey: .popularity)
        try container.encode(self.voteCount, forKey: .voteCount)
        try container.encode(self.video, forKey: .video)
        try container.encode(self.voteAverage, forKey: .voteAverage)
    }
}
