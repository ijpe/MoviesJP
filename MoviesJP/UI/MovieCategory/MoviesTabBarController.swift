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
        let upcomingC = MovieCategory(typeId: 3, title: "Upcoming", entityName: "UpcomingMovie")
        
        let storyboard = UIStoryboard(name: "MovieCategory", bundle: nil)
        
        let popularVC = storyboard.instantiateViewController(withIdentifier: "movieCategoryVC") as! MovieCategoryViewController
        popularVC.movieCategory = popularC
        let topRatedVC = storyboard.instantiateViewController(withIdentifier: "movieCategoryVC") as! MovieCategoryViewController
        topRatedVC.movieCategory = topRatedC
        let upcomingVC = storyboard.instantiateViewController(withIdentifier: "movieCategoryVC") as! MovieCategoryViewController
        upcomingVC.movieCategory = upcomingC
        
        let ncPopular = UINavigationController.init(rootViewController: popularVC)
        ncPopular.tabBarItem = UITabBarItem(title: popularC.title, image: nil, selectedImage: nil)
        let ncTopRated = UINavigationController.init(rootViewController: topRatedVC)
        ncTopRated.tabBarItem = UITabBarItem(title: topRatedC.title, image: nil, selectedImage: nil)
        let ncUpcoming = UINavigationController.init(rootViewController: upcomingVC)
        ncUpcoming.tabBarItem = UITabBarItem(title: upcomingC.title, image: nil, selectedImage: nil)
        
        self.viewControllers = [ncPopular, ncTopRated, ncUpcoming]
    }
}
