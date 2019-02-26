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

//MARK: MovieCategoryViewController
class MovieCategoryViewController: UIViewController, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var movieCategory: MovieCategory!
    var fetchedResults: NSFetchedResultsController<NSFetchRequestResult>!
    
    @IBOutlet var tblMovies: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblMovies.dataSource = self
        
        self.loadMovies()
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResults?.fetchedObjects!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        guard let m = self.fetchedResults?.object(at: indexPath) as? TopRated else {
            fatalError("No Address")
        }
        
        cell.textLabel?.text = "\(m.title)"
        
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
        MoviesAPI().loadPopular { (movieResponse, error) in
            if let movieResponse = movieResponse {
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.title, forKey: "title")
                }
                
                self.fetch()
                KVNProgress.showSuccess(withStatus: "Bien \(movieResponse.results.count)")
            } else {
                KVNProgress.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    func loadTopRated() {
        MoviesAPI().loadTopRated { (movieResponse, error) in
            if let movieResponse = movieResponse {
                
                for movie in movieResponse.results {
                    let entity = NSEntityDescription.entity(forEntityName: self.movieCategory.entityName, in: self.context)
                    let m = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    m.setValue(movie.title, forKey: "title")
                }
                
                self.fetch()
                KVNProgress.showSuccess(withStatus: "Bien \(movieResponse.results.count)")
            } else {
                KVNProgress.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    func loadUpcoming() {
        
    }
    
    func fetch() {
        do {
            try context.save()
            
            let fetchRequest = NSFetchRequest<TopRated>(entityName: self.movieCategory.entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            self.fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
            
            try self.fetchedResults.performFetch()
            
            self.tblMovies.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
}
