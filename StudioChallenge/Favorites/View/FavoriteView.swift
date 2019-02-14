//
//  FavoriteView.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/14/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

class FavoriteView: UIViewController {
    private struct CellIdentifiers {
        static let comic = "comicCell"
    }
    
    @IBOutlet weak var noFavView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    var favoriteComics: [Comic]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        adjustViewState()
        navigationItem.title = "XKCD"
    }
    
    func adjustViewState() {
        if favoriteComics.count > 0 {
            tableView.isHidden = false
            noFavView.isHidden = true
        } else {
            tableView.isHidden = true
            noFavView.isHidden = false
        }
    }

}

extension FavoriteView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteComics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.comic) as! ComicCell
        
        let comic = favoriteComics[indexPath.row]
        cell.configure(with: comic)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}

extension FavoriteView: UITableViewDelegate {}

