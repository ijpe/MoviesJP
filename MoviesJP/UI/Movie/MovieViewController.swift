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

//MARK: - MovieViewController
class MovieViewController: UIViewController {
    
    var typeId: Int!
    
    var popular: PopularMovie!
    var topRated: TopRatedMovie!
    var upcoming: UpcomingMovie!
    var searched: SearchMovie!
    var videoUrl: String!
    
    @IBOutlet var scrollView: MXScrollView!
    @IBOutlet var viewParallax: UIView!
    @IBOutlet var img: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblReleaseDate: UILabel!
    @IBOutlet var lblUserScore: UILabel!
    @IBOutlet var lblOverview: UILabel!
    @IBOutlet var webSiteContainer: UIView!
    @IBOutlet var btnVideo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnVideo.isHidden = true
        
        switch self.typeId {
        case 1:
            self.showPopular()
        case 2:
            self.showTopRated()
        case 3:
            self.showUpcoming()
        default:
            self.showSearched()
        }
        
        scrollView.parallaxHeader.view = self.viewParallax
        scrollView.parallaxHeader.height = 500
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
    }
    
    //MARK: Functions
    private func showPopular() {
        self.title = popular.title
        self.lblTitle.text = popular.title
        self.lblReleaseDate.text = popular.releaseDate
        self.lblUserScore.text = "\(popular.voteAverage)"
        self.lblOverview.text = popular.overview
        self.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageLargePath)\(popular.posterPath!)"))
        
        if popular.video {
            self.getVideosFor(movieId: Int(popular.id))
        }
    }
    
    private func showTopRated() {
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
    
    private func showUpcoming() {
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
    
    private func showSearched() {
        self.title = searched.title
        self.lblTitle.text = searched.title
        self.lblReleaseDate.text = searched.releaseDate
        self.lblUserScore.text = "\(searched.voteAverage)"
        self.lblOverview.text = searched.overview
        self.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageLargePath)\(searched.posterPath!)"))
        
        if searched.video {
            self.getVideosFor(movieId: Int(searched.id))
        } else {
            self.videoUrl = "https://www.youtube.com/watch?v=huxHcFvd5PQ"
            self.btnVideo.setTitle("Video for demostrable purpose", for: .normal)
            self.btnVideo.isHidden = false
        }
    }
    
    private func getVideosFor(movieId: Int) {
        
        MoviesAPI().loadVideos(movieId: movieId) { (videoResponse, error) in

            if let videoResponse = videoResponse {

                for video in videoResponse.results {
                    self.videoUrl = "https://www.youtube.com/watch?v=\(video.key!)"
                    self.btnVideo.isHidden = false
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    //MARK: Action
    @IBAction func playVideo() {
        let wsVC = UIStoryboard(name: "WebSite", bundle: nil).instantiateInitialViewController() as! WebSiteViewController
        wsVC.url = self.videoUrl
//        wsVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.show(wsVC, sender: nil)
    }
}
