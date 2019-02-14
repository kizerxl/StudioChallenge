//
//  Comic.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/11/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

class Comic {
    var month: String
    var num: Int
    var link: String?
    var year: String
    var news: String?
    var safe_title: String?
    var transcript: String?
    var alt: String
    var img: String?
    var title: String?
    var day: String
    var imgRetina: String?
    
    var isFavorite: Bool = false
    
    init(from json: [String: Any]) {
        self.month = json["month"] as! String
        self.num = json["num"] as! Int
        self.link = json["link"] as? String
        self.year = json["year"] as! String
        self.news = json["news"] as? String
        self.safe_title  = json["safe_title"] as? String
        self.transcript  = json["transcript"] as? String
        self.alt = json["alt"] as! String
        self.img = json["img"] as? String
        self.title = json["title"] as? String
        self.day = json["day"] as! String
        self.imgRetina = json["imgRetina"] as? String
    }
}

extension Comic: Equatable {
    static func == (lhs: Comic, rhs: Comic) -> Bool {
        return lhs.num == rhs.num
    }
}
