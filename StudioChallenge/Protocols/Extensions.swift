//
//  Extensions.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/13/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

extension Date {
    func getFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        var datePieces = dateFormatter.string(from: self).split(separator: ",")
        datePieces[0] = datePieces[0]+"th"
        
        return datePieces.joined(separator: ",")
    }
}
