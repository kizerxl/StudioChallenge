//
//  FeedPresenter.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/11/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

class FeedPresenter {
    private var fetchInProgress = false
    private weak var feedDelegate: FeedDelegate?
    private var feedService: FeedServiceProtocol
    
    var comicNumber: Int!
    var comics: [Comic]
    var favoriteComics: [Comic]
    
    
    init(feedDelegate: FeedDelegate, feedService: FeedServiceProtocol = FeedService()) {
        self.feedDelegate = feedDelegate
        self.feedService = feedService
        
        comicNumber = 1
        
        comics = []
        favoriteComics = []
    }
    
    func adjustFavorites(comic: Comic) {
        if let index = favoriteComics.index(where: { $0 == comic }) {
            if !comic.isFavorite {
             favoriteComics.remove(at: index)
            }
        } else if comic.isFavorite {
            favoriteComics.append(comic)
        }
        feedDelegate?.onFavorites()
    }
    
    func getComic() {
        guard !fetchInProgress else {
            return
        }
        
        fetchInProgress = true
        
        let urlString = "\(API.baseUrl)\(String(describing: comicNumber!))"
        
        feedService.fetchComic(from: urlString) { [weak self] comic in
            
            guard let strongSelf = self else { return }
            
            if let returnedComic = comic {
                DispatchQueue.main.async {
                    strongSelf.fetchInProgress = false
                    strongSelf.comics.append(returnedComic)
                    strongSelf.comicNumber += 1
                    
                    strongSelf.feedDelegate?.onFetchSuccess()
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.fetchInProgress = false
                    strongSelf.feedDelegate?.onFetchFailed()
                }
            }
        }
    }
}
