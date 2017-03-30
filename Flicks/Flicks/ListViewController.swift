//
//  FirstViewController.swift
//  Flicks
//
//  Created by Akshay Bhandary on 3/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit
import AFNetworking

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    let kJSONResults = "results"
    let kJSONTitle = "original_title"
    let kJSONDetail = "overview";
    let kJSONBackdropPath = "backdrop_path"
    let kJSONPosterPath = "poster_path"
    let kShowDetailViewSegue = "showDetailSegue";
    let kShowDetailViewFromCollectionViewSegue = "showDetailViewFromCollectionView";
    
    let kTableViewCellReusableID = "MovieTableViewCell"
    let kCollectionViewCellReusableID = "MovieCollectionViewCell"
    
    let kImageBaseURL = "https://image.tmdb.org/t/p/w185/";
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var refreshControl : UIRefreshControl!
    
    var movies : [AnyObject]?;
    
    var movieURL : String = "";
    
    var collectionViewSelectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setup table view
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.refreshControl = UIRefreshControl();
        self.tableView.refreshControl = self.refreshControl;
        self.refreshControl.addTarget(self, action: #selector(refreshList), for: UIControlEvents.allEvents);
        
        refreshList();
        
        // setup collection view
        self.collectionView.delegate = self
        self.collectionView.dataSource = self;
    }

    override func viewWillAppear(_ animated: Bool) {

        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        if self.tabBarController?.selectedIndex == 0 {
            self.movieURL = "https://api.themoviedb.org/3/movie/now_playing?";
        } else {
            self.movieURL = "https://api.themoviedb.org/3/movie/top_rated?"
        }
        refreshList();
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segControlValueChanged(_ sender: AnyObject) {
        if self.segmentedControl.selectedSegmentIndex == 1 {
            self.collectionView.isHidden = false;
            self.tableView.isHidden = true;
        } else {
            self.collectionView.isHidden = true;
            self.tableView.isHidden = false;
        }
    }
    
    
    // MARK: - Refresh Control
    func refreshList() {
        
        let url = URL(string: "\(self.movieURL)api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed");
        Networking.get(url: url!,
                       success: { (data : Data) in
                        self.refreshControl.endRefreshing();
                        self.handleSuccess(data: data);
            },
                       failure: { (error : Error?) in
                        self.refreshControl.endRefreshing();
                        print(error);
            }
        );
    }
    
    func handleSuccess(data : Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers);
            if let jsonDict = jsonObject as? [String : Any] {
                self.movies = jsonDict[self.kJSONResults] as! [AnyObject]?;
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                };
            } else {
                self.showError();
            }
           // print(jsonObject);
        }catch   {
            print("error reading json: \(error)");
            self.showError();
        }
    }
    
    func showError() {
        
    }
    
    
    
    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies?.count ?? 0;
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let movies = self.movies, let movie = movies[indexPath.row] as? [String : Any] {
            
            if let cell = self.tableView.dequeueReusableCell(withIdentifier: kTableViewCellReusableID) as? MovieTableViewCell,
                let title = movie[kJSONTitle] as? String,
                let summary = movie[kJSONDetail] as? String,
                let imagePath = movie[kJSONBackdropPath] as? String {
                
                let url = URL(string: "\(kImageBaseURL)\(imagePath)")!
                
                cell.movieTitle.text = title;
                cell.movieSummary.text = summary;
                cell.movieImageView?.setImageWith(URLRequest(url: url), placeholderImage: nil,
                                                  success:{ (imageRequest, imageResponse, image) -> Void in
                                                    
                                                    // imageResponse will be nil if the image is cached
                                                    if imageResponse != nil {
                                                        print("Image was NOT cached, fade in image")
                                                        cell.movieImageView?.alpha = 0.0
                                                        cell.movieImageView?.image = image
                                                        cell.movieImageView?.contentMode = UIViewContentMode.scaleToFill
                                                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                                            cell.movieImageView?.alpha = 1.0
                                                        })
                                                    } else {
                                                        print("Image was cached so just update the image")
                                                        cell.movieImageView?.image = image
                                                        cell.movieImageView?.contentMode = UIViewContentMode.scaleToFill
                                                    }
                    },failure: { (imageRequest, imageResponse, error) -> Void in
                        self.showError();
                })
                return cell;
            }
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let movies = self.movies, let movie = movies[indexPath.row] as? [String : Any] {
            
            if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellReusableID, for: indexPath) as? MovieCollectionViewCell,
                let title = movie[kJSONTitle] as? String,
                let imagePath = movie[kJSONPosterPath] as? String {
                
                let url = URL(string: "\(kImageBaseURL)\(imagePath)")!
                
                cell.movieTitle.text = title;
                cell.movieTitle.isHidden = true;
                cell.movieImageView?.setImageWith(URLRequest(url: url), placeholderImage: nil,
                                                  success:{ (imageRequest, imageResponse, image) -> Void in
                                                    
                                                    // imageResponse will be nil if the image is cached
                                                    if imageResponse != nil {
                                                        print("Image was NOT cached, fade in image")
                                                        cell.movieImageView?.alpha = 0.0
                                                        cell.movieImageView?.isHidden = false;
                                                        cell.movieImageView?.image = image
                                                        
                                                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                                            cell.movieImageView?.alpha = 1.0
                                                        })
                                                    } else {
                                                        print("Image was cached so just update the image")
                                                        cell.movieImageView?.image = image
                                                    }
                    },failure: { (imageRequest, imageResponse, error) -> Void in
                        self.showError();
                })
                return cell;
            }
        }
        return UICollectionViewCell();
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0;
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.collectionViewSelectedIndexPath = indexPath;
        collectionView.deselectItem(at: indexPath, animated: false);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == kShowDetailViewSegue,
            let destination = segue.destination as? DetailViewController {
            if let indexPath =  self.tableView.indexPathForSelectedRow,
                let movies = self.movies,
                let movie = movies[indexPath.row] as? [String : Any],
                let path = movie[kJSONPosterPath] as? String,
                let text = movie[kJSONDetail] as? String {
                
                destination.imagePath = "\(kImageBaseURL)\(path)"
                destination.text = text;
            }
        }
        
        
        
        if segue.identifier! == kShowDetailViewFromCollectionViewSegue,
            let destination = segue.destination as? DetailViewController {
                
            if let indexPaths =  self.collectionView.indexPathsForSelectedItems,
                let movies = self.movies,
                let movie = movies[indexPaths[0].row] as? [String : Any],
                let path = movie[kJSONPosterPath] as? String,
                let text = movie[kJSONDetail] as? String {
                
                    
                destination.imagePath = "\(kImageBaseURL)\(path)"
                destination.text = text;
            }
        }
        
        
    }
    
}

