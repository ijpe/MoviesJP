//
//  MovieSearchViewController.swift
//  MoviesJP
//
//  Created by iJPe on 2/27/19.
//  Copyright © 2019 jp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//MARK: - MovieSearchViewController
class MovieSearchViewController: UIViewController, UITableViewDataSource {
    
    private let entityName = "SearchMovie"
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResults: NSFetchedResultsController<NSFetchRequestResult>!
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tbl: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "show_movie" {
            let vc = segue.destination as! MovieViewController
            vc.typeId = 4
            
            let m = self.fetchedResults?.object(at: IndexPath(row: (sender as! UITableViewCell).tag, section: 0)) as! SearchMovie
            vc.searched = m
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        self.tbl.tableHeaderView = self.searchController.searchBar
        self.definesPresentationContext = true

        self.tbl.dataSource = self
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.fetchedResults?.fetchedObjects!.count ?? 0 <= 0 {
            return 1
        } else {
            return self.fetchedResults?.fetchedObjects!.count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.fetchedResults?.fetchedObjects!.count ?? 0 == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "cellEmpty")!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieCell
        
        guard let m = self.fetchedResults?.object(at: indexPath) as? SearchMovie else {
            fatalError("Error get movie")
        }
        
        cell.img.sd_setImage(with: URL(string: "\(Env.MoviesApi.baseImageSmallPath)\(m.posterPath!)"))
        cell.lblTitle.text = m.title
        cell.lblInfo.text = "Popularity: \(m.popularity)"
        cell.lblOverview.text = m.overview
        
//        if m.video {
            cell.imgVideo.isHidden = false
//        } else {
//            cell.imgVideo.isHidden = true
//        }
        
        return cell
    }
    
    func search(_ query: String) {
        
        MoviesAPI().searchMovieBy(query: query) { (searchResponse, error) in
            
            if let movieResponse = searchResponse {
                
                self.truncateEntity(entityName: self.entityName)
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: self.context)
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
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
            self.fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
            
            try self.fetchedResults.performFetch()
            
            self.tbl.reloadData()
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
        
        if isFiltering() {
            self.search(searchText)
        } else {
            self.truncateEntity(entityName: self.entityName)
            self.fetchEntity()
        }
    }
}

extension MovieSearchViewController: UISearchResultsUpdating {
    
    internal func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
