//
//  FeedProtocols.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/11/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

protocol FeedDelegate: class {
    func onFetchFailed()
    func onFetchSuccess()
    func onFavorites()
}

protocol TableViewCellDelegate {
    func tableViewCell(singleTapActionDelegatedFrom cell: UITableViewCell)
    func tableViewCell(doubleTapActionDelegatedFrom cell: UITableViewCell)
}

protocol FeedServiceProtocol: class {
    typealias completion = (Comic?) -> ()
    
    func fetchComic(from endpoint: String, with completionHandler: @escaping completion)
}
