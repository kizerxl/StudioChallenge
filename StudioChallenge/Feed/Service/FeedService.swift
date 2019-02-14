//
//  FeedService.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/11/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit
import Alamofire

class FeedService: FeedServiceProtocol {
    
        func fetchComic(from endpoint: String, with completionHandler: @escaping completion) {
            guard let url = URL(string: endpoint) else {
                completionHandler(nil)
                return
            }
            
            let request = URLRequest(url: url)
            
            Alamofire.request(request).responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    completionHandler(nil)
                    return
                }
                
                let comic = Comic(from: json)
                completionHandler(comic)
            }
    }
}



