//
//  DetailViewController.swift
//  Flicks
//
//  Created by Vinnie Chen on 11/17/17.
//  Copyright © 2017 Vinnie Chen. All rights reserved.
//

import UIKit
enum MovieKeys {
    static let backdropPath = "backdrop_path"
}

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var recRightImageView: UIImageView!
    @IBOutlet weak var recLeftImageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var recThirdImageView: UIImageView!
    
    var movie: [String: Any] = [:]
    var recs: [[String: Any]] = [[:]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as! String
        titleLabel.text = title
        
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit() // allows label to extend downward to fit all text
        
        let votes = movie["vote_average"] as! NSNumber
        voteLabel.text = String(describing: votes) + "/10 🌟"
        
        let releaseDate = movie["release_date"] as? String
        releaseLabel.text = releaseDate
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        if let backdropURL = movie[MovieKeys.backdropPath] as? String {
            let backURL = NSURL(string: baseURL + backdropURL)
            backgroundImageView.af_setImage(withURL: backURL as! URL)
        }
        if let posterURL = movie["poster_path"] as? String { // nil check
            let imageURL = NSURL(string: baseURL + posterURL)
            posterImageView.af_setImage(withURL: imageURL as! URL)
            
        }
        
        loadRecommendations()
    }
    
    func loadRecommendations() {
        let num_id = movie["id"] as! NSNumber
        let id = String(describing: num_id)
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + id + "/recommendations?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                self.recs = dataDictionary["results"] as! [[String: Any]]
                self.loadRecImage()
                
            }
        }
        task.resume()
    }
    
    func loadRecImage() {
        let recL = self.recs[0] as [String: Any]
        let recR = self.recs[1] as [String: Any]
        let recT = self.recs[2] as [String: Any]
        
        let posterPathL = recL["poster_path"] as! String
        let posterPathR = recR["poster_path"] as! String
        let posterPathT = recT["poster_path"] as! String
        
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterPathL)!
        recLeftImageView.af_setImage(withURL: posterURL)
        
        let posterURLR = URL(string: "https://image.tmdb.org/t/p/w500" + posterPathR)!
        recRightImageView.af_setImage(withURL: posterURLR)
        
        let posterURLT = URL(string: "https://image.tmdb.org/t/p/w500" + posterPathT)!
        recThirdImageView.af_setImage(withURL: posterURLT)

    }
    
    @IBAction func onExit(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
