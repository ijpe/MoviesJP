//
//  MovieViewController.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import UIKit
import MXParallaxHeader
import KVNProgress

//MARK: - MovieViewController
class MovieViewController: UIViewController {
    
    var typeId: Int!
    
    var popular: PopularMovie!
    var topRated: TopRatedMovie!
    var upcoming: UpcomingMovie!
    var videoUrl: String! = "https://www.youtube.com/watch?v=huxHcFvd5PQ"
    
    @IBOutlet var scrollView: MXScrollView!
    @IBOutlet var viewParallax: UIView!
    @IBOutlet var img: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblReleaseDate: UILabel!
    @IBOutlet var lblUserScore: UILabel!
    @IBOutlet var lblOverview: UILabel!
    @IBOutlet var webSiteContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.typeId {
        case 1:
            self.showPopular()
        case 2:
            self.showTopRated()
        default:
            self.showUpcoming()
        }
        
        scrollView.parallaxHeader.view = self.viewParallax
        scrollView.parallaxHeader.height = 600
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
    }
    
    //MARK: Functions
    func showPopular() {
        self.title = popular.title
        self.lblTitle.text = popular.title
        self.lblReleaseDate.text = popular.releaseDate
        self.lblUserScore.text = "\(popular.voteAverage)"
        self.lblOverview.text = popular.overview
        self.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageLargePath)\(popular.posterPath!)"))
        
//        if popular.video {
            self.getVideosFor(movieId: Int(popular.id))
//        }
    }
    
    func showTopRated() {
        self.title = topRated.title
        self.lblTitle.text = topRated.title
        self.lblReleaseDate.text = topRated.releaseDate
        self.lblUserScore.text = "\(topRated.voteAverage)"
        self.lblOverview.text = topRated.overview
        self.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageLargePath)\(topRated.posterPath!)"))
        
        if topRated.video {
            self.getVideosFor(movieId: Int(topRated.id))
        }
    }
    
    func showUpcoming() {
        self.title = upcoming.title
        self.lblTitle.text = upcoming.title
        self.lblReleaseDate.text = upcoming.releaseDate
        self.lblUserScore.text = "\(upcoming.voteAverage)"
        self.lblOverview.text = upcoming.overview
        self.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageLargePath)\(upcoming.posterPath!)"))
        
        if upcoming.video {
            self.getVideosFor(movieId: Int(upcoming.id))
        }
    }
    
    func getVideosFor(movieId: Int) {
        
        KVNProgress.show(withStatus: "Loading...")

        MoviesAPI().loadVideos(movieId: movieId) { (videoResponse, error) in

            if let videoResponse = videoResponse {

                for video in videoResponse.results {
                    self.videoUrl = "https://www.youtube.com/watch?v=\(video.key!)"
                }

                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    //MARK: Action
    @IBAction func playVideo() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "webSiteVC") as! WebSiteViewController
        controller.url = self.videoUrl
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(controller.view)
    }
}
