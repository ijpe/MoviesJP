//
//  MovieCategoryViewController.swift
//  MoviesJP
//
//  Created by iJPe on 2/26/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData
import SDWebImage

//MARK: MovieCategoryViewController
class MovieCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var page = 0
    private var totalPage: Int! = nil
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResults: NSFetchedResultsController<NSFetchRequestResult>!
    private let searchController = UISearchController(searchResultsController: nil)
    var movieCategory: MovieCategory!
    
    @IBOutlet var tblMovies: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "show_movie" {
            let vc = segue.destination as! MovieViewController
            vc.typeId = self.movieCategory.typeId
            
            switch vc.typeId {
            case 1:
                let m = self.fetchedResults?.object(at: IndexPath(row: (sender as! UITableViewCell).tag, section: 0)) as! PopularMovie
                vc.popular = m
            case 2:
                let m = self.fetchedResults?.object(at: IndexPath(row: (sender as! UITableViewCell).tag, section: 0)) as! TopRatedMovie
                vc.topRated = m
            default:
                let m = self.fetchedResults?.object(at: IndexPath(row: (sender as! UITableViewCell).tag, section: 0)) as! UpcomingMovie
                vc.upcoming = m
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.movieCategory.title
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        
        self.tblMovies.dataSource = self
        self.tblMovies.delegate = self
        
        self.loadMovies()
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResults?.fetchedObjects!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblMovies.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        
        switch self.movieCategory.typeId {
        case 1:
            guard let m = self.fetchedResults?.object(at: indexPath) as? PopularMovie else {
                fatalError("Error get movie")
            }
            
            cell.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageSmallPath)\(m.posterPath!)"))
            cell.lblTitle.text = m.title
            cell.lblInfo.text = "Popularity: \(m.popularity)"
            cell.lblOverview.text = m.overview
            
            if m.video {
                cell.imgVideo.isHidden = false
            } else {
                cell.imgVideo.isHidden = true
            }
        case 2:
            guard let m = self.fetchedResults?.object(at: indexPath) as? TopRatedMovie else {
                fatalError("Error get movie")
            }
            
            cell.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageSmallPath)\(m.posterPath!)"))
            cell.lblTitle.text = m.title
            cell.lblInfo.text = "Rate: \(m.voteAverage)"
            cell.lblOverview.text = m.overview
            
            if m.video {
                cell.imgVideo.isHidden = false
            } else {
                cell.imgVideo.isHidden = true
            }
        default:
            guard let m = self.fetchedResults?.object(at: indexPath) as? UpcomingMovie else {
                fatalError("Error get movie")
            }
            
            cell.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageSmallPath)\(m.posterPath!)"))
            cell.lblTitle.text = m.title
            cell.lblInfo.text = m.releaseDate
            cell.lblOverview.text = m.overview
            
            if m.video {
                cell.imgVideo.isHidden = false
            } else {
                cell.imgVideo.isHidden = true
            }
        }
        
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !self.isFiltering() && indexPath.row == (self.fetchedResults?.fetchedObjects!.count)! - 1 {
            if self.page <= self.totalPage ?? 1 {
                self.loadMovies()
            }
        }
    }
    
    //MARK: Functions
    private func loadMovies() {
        
        if self.page == 0 || self.totalPage != nil {
            self.page = self.page + 1
            
            switch self.movieCategory.typeId {
            case 1:
                self.loadPopular()
            case 2:
                self.loadTopRated()
            default:
                self.loadUpcoming()
            }
        }
    }
    
    private func loadPopular() {
        
        MoviesAPI().loadPopular(page: self.page) { (movieResponse, error) in
            if let movieResponse = movieResponse {
                
                if self.totalPage == nil {
                    self.truncateEntity(entityName: self.movieCategory.entityName)
                    self.totalPage = movieResponse.totalPages
                }
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.adult, forKey: "adult")
                    m.setValue(movie.backdropPath, forKey: "backdropPath")
                    m.setValue(movie.id, forKey: "id")
                    m.setValue(movie.originalLanguage, forKey: "originalLanguage")
                    m.setValue(movie.originalTitle, forKey: "originalTitle")
                    m.setValue(movie.overview, forKey: "overview")
                    m.setValue(movie.popularity, forKey: "popularity")
                    m.setValue(movie.posterPath, forKey: "posterPath")
                    m.setValue(movie.releaseDate, forKey: "releaseDate")
                    m.setValue(movie.title, forKey: "title")
                    m.setValue(movie.video, forKey: "video")
                    m.setValue(movie.voteAverage, forKey: "voteAverage")
                    m.setValue(movie.voteCount, forKey: "voteCount")
                }
                
                self.fetchEntity()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    private func loadTopRated() {
        
        MoviesAPI().loadTopRated(page: self.page) { (movieResponse, error) in
            
            if let movieResponse = movieResponse {
                
                if self.page == 1 {
                    self.truncateEntity(entityName: self.movieCategory.entityName)
                    self.totalPage = movieResponse.totalPages
                }
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.adult, forKey: "adult")
                    m.setValue(movie.backdropPath, forKey: "backdropPath")
                    m.setValue(movie.id, forKey: "id")
                    m.setValue(movie.originalLanguage, forKey: "originalLanguage")
                    m.setValue(movie.originalTitle, forKey: "originalTitle")
                    m.setValue(movie.overview, forKey: "overview")
                    m.setValue(movie.popularity, forKey: "popularity")
                    m.setValue(movie.posterPath, forKey: "posterPath")
                    m.setValue(movie.releaseDate, forKey: "releaseDate")
                    m.setValue(movie.title, forKey: "title")
                    m.setValue(movie.video, forKey: "video")
                    m.setValue(movie.voteAverage, forKey: "voteAverage")
                    m.setValue(movie.voteCount, forKey: "voteCount")
                }
                
                self.fetchEntity()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    private func loadUpcoming() {
        
        MoviesAPI().loadUpcoming(page: self.page) { (movieResponse, error) in
            
            if let movieResponse = movieResponse {
                
                if self.page == 1 {
                    self.truncateEntity(entityName: self.movieCategory.entityName)
                    self.totalPage = movieResponse.totalPages
                }
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.adult, forKey: "adult")
                    m.setValue(movie.backdropPath, forKey: "backdropPath")
                    m.setValue(movie.id, forKey: "id")
                    m.setValue(movie.originalLanguage, forKey: "originalLanguage")
                    m.setValue(movie.originalTitle, forKey: "originalTitle")
                    m.setValue(movie.overview, forKey: "overview")
                    m.setValue(movie.popularity, forKey: "popularity")
                    m.setValue(movie.posterPath, forKey: "posterPath")
                    m.setValue(movie.releaseDate, forKey: "releaseDate")
                    m.setValue(movie.title, forKey: "title")
                    m.setValue(movie.video, forKey: "video")
                    m.setValue(movie.voteAverage, forKey: "voteAverage")
                    m.setValue(movie.voteCount, forKey: "voteCount")
                }
                
                self.fetchEntity()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    private func fetchEntity() {
        do {
            try context.save()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.movieCategory.entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: self.movieCategory.sortBy, ascending: self.movieCategory.ascending)]
            self.fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
            
            try self.fetchedResults.performFetch()
            
            self.tblMovies.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    private func truncateEntity(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.context.execute(delete)
        } catch {
            print(error)
        }
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        var predicate: NSPredicate! = nil
        
        if !searchBarIsEmpty() {
            predicate = NSPredicate(format: "(title contains [cd] %@)", searchText)
        }
        
        self.fetchedResults.fetchRequest.predicate = predicate
        
        do {
            try self.fetchedResults.performFetch()
            self.tblMovies.reloadData()
        } catch {
            print("Error filtrando")
        }
    }
}

extension MovieCategoryViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
