//
//  ListController.swift
//  FirebaseCRUD
//
//  Created by fred on 18/02/2021.
//

import UIKit

class ListController: UIViewController {
    
    var movies: [Movie] = []
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        FireDatabase().getMovies { (movies, error) in
            if let newMovies = movies {
                self.movies = newMovies
                self.tableView.reloadData()
                print("filmList", self.movies)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    


}
extension ListController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.titre
        cell.detailTextLabel?.text = movie.part
        return cell
    }
    
    
}
