//
//  MoviesTabBarController.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import UIKit

//MARK: - MoviesTabBarController
class MoviesTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let popularC = MovieCategory(typeId: 1, title: "Popular", entityName: "PopularMovie", sortBy: "popularity", ascending: false)
        let topRatedC = MovieCategory(typeId: 2, title: "Top Rated", entityName: "TopRatedMovie", sortBy: "voteAverage", ascending: false)
        let upcomingC = MovieCategory(typeId: 3, title: "Upcoming", entityName: "UpcomingMovie", sortBy: "releaseDate", ascending: true)
        
        let storyboard = UIStoryboard(name: "MovieCategory", bundle: nil)
        
        let popularVC = storyboard.instantiateViewController(withIdentifier: "movieCategoryVC") as! MovieCategoryViewController
        popularVC.movieCategory = popularC
        let topRatedVC = storyboard.instantiateViewController(withIdentifier: "movieCategoryVC") as! MovieCategoryViewController
        topRatedVC.movieCategory = topRatedC
        let upcomingVC = storyboard.instantiateViewController(withIdentifier: "movieCategoryVC") as! MovieCategoryViewController
        upcomingVC.movieCategory = upcomingC
        
        let ncPopular = UINavigationController.init(rootViewController: popularVC)
        ncPopular.tabBarItem = UITabBarItem(title: popularC.title, image: UIImage(named: "outline_favorite_border_black_24pt"), selectedImage: nil)
        let ncTopRated = UINavigationController.init(rootViewController: topRatedVC)
        ncTopRated.tabBarItem = UITabBarItem(title: topRatedC.title, image: UIImage(named: "outline_grade_black_24pt"), selectedImage: nil)
        let ncUpcoming = UINavigationController.init(rootViewController: upcomingVC)
        ncUpcoming.tabBarItem = UITabBarItem(title: upcomingC.title, image: UIImage(named: "outline_date_range_black_24pt"), selectedImage: nil)
        let ncSearch = UIStoryboard(name: "MovieSearch", bundle: nil).instantiateInitialViewController()!
        ncSearch.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "outline_search_black_24pt"), selectedImage: nil)
        
        self.viewControllers = [ncPopular, ncTopRated, ncUpcoming, ncSearch]
    }
}
