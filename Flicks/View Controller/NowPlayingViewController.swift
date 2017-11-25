//
//  NowPlayingViewController.swift
//  Flicks
//
//  Created by Vinnie Chen on 11/15/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    let baseURLString = "https://image.tmdb.org/t/p/w500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchMovies()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String

        
        let posterURL = URL(string: baseURLString + posterPath)!
        cell.poster.af_setImage(withURL: posterURL)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(160)
    }
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let moviesDictionary = dataDictionary["results"] as! [[String: Any]]
                self.movies = moviesDictionary
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    
    @objc func didPullRefresh(_ refreshControl: UIRefreshControl) {
            fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies[(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        detailViewController.hidesBottomBarWhenPushed = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
