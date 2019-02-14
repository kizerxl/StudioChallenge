//
//  ComicCell.swift
//  StudioChallenge
//
//  Created by Felix Changoo on 2/11/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit
import Kingfisher

class ComicCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateInfoLabel: UILabel!
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let inactiveOpacity: CGFloat = 0.25
    private let activeOpacity: CGFloat = 1.0
    
    private var tapCounter = 0
    var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
        
        scrollView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with comic: Comic?) {
        if let comic = comic {
            showCellUI(show: true)
            
            titleLabel.text = comic.title
            descriptionLabel.text = comic.alt
            dateInfoLabel.text = "#\(comic.num) • \(getDateReadout(month: Int(comic.month)!, day: Int(comic.day)!, year: Int(comic.year)!))"
            
            let url = URL(string: comic.img!)
            
            imgView.kf.setImage(with: url)
            
            toggleFavoriteState(isFavorite: comic.isFavorite)
        } else {
            showCellUI(show: false)
        }
    }
    
    private func getDateReadout(month: Int, day: Int, year: Int) -> String {
        var components = DateComponents()
        let calendar = NSCalendar.current
        
        components.day = day
        components.month = month
        components.year = year
        
        let newDate = calendar.date(from: components)!
        
        return newDate.getFormattedDateString()
    }
    
    private func showCellUI(show: Bool) {
        if show {
            titleLabel.alpha = 1
            descriptionLabel.alpha = 1
            dateInfoLabel.alpha = 1
            heartIcon.alpha = 1
        } else {
            titleLabel.alpha = 0
            descriptionLabel.alpha = 0
            dateInfoLabel.alpha = 0
            heartIcon.alpha = 0
        }
    }
    
    @objc func tapAction() {
        
        if tapCounter == 0 {
            DispatchQueue.global(qos: .background).async {
                usleep(250000)
                if self.tapCounter > 1 {
                    self.doubleTapAction()
                } else {
                    self.singleTapAction()
                }
                self.tapCounter = 0
            }
        }
        tapCounter += 1
    }
    
    func singleTapAction() {
        delegate?.tableViewCell(singleTapActionDelegatedFrom: self)
    }
    
    func doubleTapAction() {
        delegate?.tableViewCell(doubleTapActionDelegatedFrom: self)
    }
    
    func toggleFavoriteState(isFavorite: Bool) {
        let alpha = isFavorite ? activeOpacity : inactiveOpacity
        heartIcon.alpha = alpha
    }
}

extension ComicCell: UIScrollViewDelegate {}
