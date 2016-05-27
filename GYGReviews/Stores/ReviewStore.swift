//
//  ReviewStore.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/27/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import Argo
import ReactiveCocoa

struct ReviewParameters {
    let review_id: NSNumber?
    let rating: String?
    let title: String?
    let message: String?
    let author: String?
    let date: NSDate?
}

protocol StoreType {
    // Reviews
    func fetchLocalReviews() -> SignalProducer<[Review], NSError>
    func fetchRemoteReviews() -> SignalProducer<[Review], NSError>
//    func createReview(parameters: ReviewParameters) -> SignalProducer<Bool, NSError>
    
}

class ReviewStore: StoreType {
    
    enum RequestMethod {
        case GET
        case POST
    }
    
    private var reviews = [Review]()
    
    private let reviewsKey = "reviews"
    private let reviewsURL = NSURL(string: "https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json?count=205&page=0&rating=0&type=&sortBy=date_of_review&direction=DESC")!
    
}

// Mark: Reviews

extension ReviewStore {
    
    func fetchLocalReviews() -> SignalProducer<[Review], NSError> {
        return SignalProducer(value: reviews)
    }
    
    func fetchRemoteReviews() -> SignalProducer<[Review], NSError> {
        let request = mutableRequestWithURL(reviewsURL, method: .GET)
        return NSURLSession.sharedSession().rac_dataWithRequest(request)
            .map { data, response in
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                    let reviewData = json["data"]
                    let reviews: [Review] = decode(reviewData)!
                    return reviews
                } else {
                    return []
                }
        }
    }
}

extension ReviewStore {
    private func mutableRequestWithURL(url: NSURL, method: RequestMethod) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        
        switch method {
        case .GET:
            request.HTTPMethod = "GET"
        case .POST:
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
