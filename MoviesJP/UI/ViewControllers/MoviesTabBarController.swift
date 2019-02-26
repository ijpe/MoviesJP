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
        
        let popularC = MovieCategory(typeId: 1, title: "Popular", entityName: "PopularMovie")
        let topRatedC = MovieCategory(typeId: 2, title: "Top Rated", entityName: "TopRatedMovie")
//        let upcomingC = MovieCategory(typeId: 1, title: "Upcoming", entityName: "")
        
        let storyboard = UIStoryboard(name: "Movies", bundle: nil)
        
        let popularVC = (storyboard.instantiateViewController(withIdentifier: "navMoviesVC") as! UINavigationController).viewControllers.first as! MovieCategoryViewController
        popularVC.tabBarItem = UITabBarItem(title: popularC.title, image: nil, selectedImage: nil)
        popularVC.movieCategory = popularC

        let topRatedVC = (storyboard.instantiateViewController(withIdentifier: "navMoviesVC") as! UINavigationController).viewControllers.first as! MovieCategoryViewController
        topRatedVC.tabBarItem = UITabBarItem(title: topRatedC.title, image: nil, selectedImage: nil)
        topRatedVC.movieCategory = topRatedC
//
//        let upcomingVC = storyboard.instantiateViewController(withIdentifier: "navMoviesVC") as! MovieCategoryViewController
//        upcomingVC.tabBarItem = UITabBarItem(title: upcomingC.title, image: nil, selectedImage: nil)
        
        self.viewControllers = [popularVC, topRatedVC]
    }
}
