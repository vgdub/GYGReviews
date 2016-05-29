//
//  ReviewsTableViewCell.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/28/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    let titleLabel: UILabel!
    let authorLabel: UILabel!
    let dateLabel: UILabel!
    let bodyLabel: UILabel!
    let ratingLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel()
        dateLabel = UILabel()
        authorLabel = UILabel()
        bodyLabel = UILabel()
        ratingLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFontOfSize(14.0)
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.boldSystemFontOfSize(12.0)
        authorLabel.numberOfLines = 0
        self.contentView.addSubview(authorLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFontOfSize(10.0)
        dateLabel.numberOfLines = 0
        self.contentView.addSubview(dateLabel)
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFontOfSize(14.0)
        bodyLabel.numberOfLines = 0
        self.contentView.addSubview(bodyLabel)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.textAlignment = .Center
        self.contentView.addSubview(ratingLabel)
        
        let views = [ "title" : titleLabel, "date": dateLabel, "author": authorLabel, "body" : bodyLabel, "rating" : ratingLabel ]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-5-[rating(40)]-5-[title]-5-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-5-[rating]-5-[author]-5-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-5-[rating]-5-[date]-5-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-5-[rating]-5-[body]-5-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-5-[title]-5-[author]-5-[date]-5-[body]-(>=5)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-5-[rating(20)]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
