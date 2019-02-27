//
//  Env.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation

struct Env {
    struct MoviesApi {
        static var ApiKey: String {
            return "972bf0e30a7fadee6e66c29eb4a9f17d"
        }
        static var host: String {
            return "https://api.themoviedb.org"
        }
        static var basePath: String {
            return "\(host)/3"
        }
        static var baseImageSmallPath: String {
            return "http://image.tmdb.org/t/p/w342"
        }
        static var baseImageLargePath: String {
            return "http://image.tmdb.org/t/p/w780"
        }
    }
}
