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
import KVNProgress
import CoreData
import SDWebImage

//MARK: MovieCategoryViewController
class MovieCategoryViewController: UIViewController, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var movieCategory: MovieCategory!
    var fetchedResults: NSFetchedResultsController<NSFetchRequestResult>!
    let searchController = UISearchController(searchResultsController: nil)
    
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
        
        searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = self.searchController
        definesPresentationContext = true
        
        self.tblMovies.dataSource = self
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
            cell.lblReleaseDate.text = m.releaseDate
            cell.lblOverview.text = m.overview
        case 2:
            guard let m = self.fetchedResults?.object(at: indexPath) as? TopRatedMovie else {
                fatalError("Error get movie")
            }
            
            cell.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageSmallPath)\(m.posterPath!)"))
            cell.lblTitle.text = m.title
            cell.lblReleaseDate.text = m.releaseDate
            cell.lblOverview.text = m.overview
        default:
            guard let m = self.fetchedResults?.object(at: indexPath) as? UpcomingMovie else {
                fatalError("Error get movie")
            }
            
            cell.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageSmallPath)\(m.posterPath!)"))
            cell.lblTitle.text = m.title
            cell.lblReleaseDate.text = m.releaseDate
            cell.lblOverview.text = m.overview
        }
        
        cell.tag = indexPath.row
        return cell
    }
    
    func loadMovies() {
        
        switch self.movieCategory.typeId {
        case 1:
            self.loadPopular()
        case 2:
            self.loadTopRated()
        default:
            self.loadUpcoming()
        }
    }
    
    func loadPopular() {
        
        KVNProgress.show(withStatus: "Loading...")
        
        MoviesAPI().loadPopular { (movieResponse, error) in
            if let movieResponse = movieResponse {
                self.truncateEntity(entityName: self.movieCategory.entityName)
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.adult, forKey: "adult")
                    m.setValue(movie.backdropPath, forKey: "backdropPath")
//                    m.setValue(movie.genreIDS, forKey: "genreIDS")
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
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    func loadTopRated() {
        
        KVNProgress.show(withStatus: "Loading...")
        
        MoviesAPI().loadTopRated { (movieResponse, error) in
            self.truncateEntity(entityName: self.movieCategory.entityName)
            
            if let movieResponse = movieResponse {
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.adult, forKey: "adult")
                    m.setValue(movie.backdropPath, forKey: "backdropPath")
//                    m.setValue(movie.genreIDS, forKey: "genreIDS")
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
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    func loadUpcoming() {
        
        KVNProgress.show(withStatus: "Loading...")
        
        MoviesAPI().loadUpcoming { (movieResponse, error) in
            self.truncateEntity(entityName: self.movieCategory.entityName)
            
            if let movieResponse = movieResponse {
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.adult, forKey: "adult")
                    m.setValue(movie.backdropPath, forKey: "backdropPath")
//                    m.setValue(movie.genreIDS, forKey: "genreIDS")
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
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    func fetchEntity() {
        do {
            try context.save()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.movieCategory.entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            self.fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
            
            try self.fetchedResults.performFetch()
            
            self.tblMovies.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func truncateEntity(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.context.execute(delete)
        } catch {
            print(error)
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
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
