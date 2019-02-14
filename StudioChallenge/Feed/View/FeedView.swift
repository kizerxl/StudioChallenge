//
//  ViewController.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/10/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

class FeedView: UIViewController {
    private struct CellIdentifiers {
        static let comic = "comicCell"
    }
    
    private struct ControllerIdentifiers {
        static let fav = "fav"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var favCountBttn: UIButton!
    
    var feedPresenter: FeedPresenter!
    private var loadingData: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavBar()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        indicatorView.startAnimating()
        
        loadingData = false
        
        feedPresenter = FeedPresenter(feedDelegate: self)
        feedPresenter.getComic()
        
        updateFavCount()
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
        let storyboard = self.navigationController?.storyboard
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifiers.fav) as! FavoriteView
        controller.favoriteComics = feedPresenter.favoriteComics
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
        favCountBttn.frame.size = CGSize(width: 30, height: 30)
        favCountBttn.layer.cornerRadius = favCountBttn.bounds.height / 2
        
        addHeartIconToFavoriteCounter()
    }
    
    func updateFavCount() {
        favCountBttn.setTitle("\(feedPresenter.favoriteComics.count)", for: .normal)
    }
    
    private func addHeartIconToFavoriteCounter() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 45, height: 45))
    
        if let leftFavImg = UIImage(named: "heartIcon") {
            imageView.image = leftFavImg
        }
        view.addSubview(imageView)
    
        let rightBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItems?.append(rightBarButtonItem)
    }
}

extension FeedView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPresenter.comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.comic) as! ComicCell
        
        let comic = feedPresenter.comics[indexPath.row]
        cell.delegate = self
        cell.configure(with: comic)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = feedPresenter.comics.count - 1

        if !loadingData && indexPath.row == lastElement {
            loadingData = true
            feedPresenter.getComic()
        }
    }
}

extension FeedView: UITableViewDelegate {}

extension FeedView: FeedDelegate {
    func onFetchFailed() {
        indicatorView.stopAnimating()
        loadingData = false
    }
    
    func onFetchSuccess() {
        indicatorView.stopAnimating()
        tableView.isHidden = false
        loadingData = false
        
        tableView.reloadData()
    }
    
    func onFavorites() {
        updateFavCount()
    }
}

extension FeedView: TableViewCellDelegate {
    
    func tableViewCell(singleTapActionDelegatedFrom cell: UITableViewCell) {
        //stub
    }
    
    func tableViewCell(doubleTapActionDelegatedFrom cell: UITableViewCell) {
        
        let comicCell = cell as! ComicCell
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let indexPath = strongSelf.tableView.indexPath(for: cell)
            
            let comic = strongSelf.feedPresenter.comics[indexPath!.row]
            comic.isFavorite = !comic.isFavorite
            
            comicCell.toggleFavoriteState(isFavorite: comic.isFavorite)
            
            strongSelf.feedPresenter.adjustFavorites(comic: comic)
        }
    }
}

