//
//  Review.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/27/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import Argo
import Curry

struct Review {
    
    let reviewId: Int?
    let rating: String?
    let title: String?
    let message: String?
    let author: String?
    let date: String?
    
    static private let reviewIdKey = "review_id"
    static private let ratingKey   = "rating"
    static private let titleKey    = "title"
    static private let messageKey  = "message"
    static private let authorKey   = "author"
    static private let dateKey     = "date"
    
    init(reviewId: Int, rating: String, title: String, message: String, author: String, date: String) {
        self.reviewId = reviewId
        self.rating   = rating
        self.title    = title
        self.message  = message
        self.author   = author
        self.date     = date
    }
    
    // TODO: Decide if content matching should include identifier or not
    static func contentMatches(lhs: Review, _ rhs: Review) -> Bool {
        return lhs.reviewId == rhs.reviewId
            && lhs.rating   == rhs.rating
            && lhs.title    == rhs.title
            && lhs.message  == rhs.message
            && lhs.author   == rhs.author
            && lhs.date     == rhs.date
    }
    
}

// MARK: Equatable

extension Review: Equatable {}

func ==(lhs: Review, rhs: Review) -> Bool {
    return lhs.reviewId == rhs.reviewId
}

// MARK: Decodable

extension Review: Decodable {
    static func decode(json: JSON) -> Decoded<Review> {
        return curry(Review.init)
            <^> json <| reviewIdKey
            <*> json <| ratingKey
            <*> json <| titleKey
            <*> json <| messageKey
            <*> json <| authorKey
            <*> json <| dateKey
    }
}

// MARK: Encodable

extension Review: Encodable {
    func encode() -> [String: AnyObject] {
        return [
            Review.reviewIdKey : reviewId!,
            Review.ratingKey   : rating!,
            Review.titleKey    : title!,
            Review.messageKey  : message!,
            Review.authorKey   : author!,
            Review.dateKey     : date!
        ]
    }
}
