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
    let reviewId: Int?
    let rating: String?
    let title: String?
    let message: String?
    let author: String?
    let date: String?
}

protocol StoreType {
    // Reviews
    func fetchReviews() -> SignalProducer<[Review], NSError>
    func createReview(parameters: ReviewParameters) -> SignalProducer<Bool, NSError>
    
}

class ReviewStore: StoreType {
    
    enum RequestMethod {
        case GET
        case POST
    }
    
    private var reviews = [Review]()
    
    private let reviewsKey = "reviews"
    private let archiveFileName = "LocalStore"
    
    private let reviewsURL = NSURL(string: "https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json?&page=0&rating=0&type=&sortBy=date_of_review&direction=DESC")!
    
}

// Mark: Reviews

extension ReviewStore {
    
    func fetchReviews() -> SignalProducer<[Review], NSError> {
        let request = mutableRequestWithURL(reviewsURL, method: .GET)
        var signalProducer: SignalProducer<[Review], NSError>?
        
        // Check for network connectivity, and return corrent signal producer
        if Reachability.isConnectedToNetwork() == true {
             signalProducer = NSURLSession.sharedSession().rac_dataWithRequest(request)
                .map { data, response in
                    if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                        let reviewData = json["data"]
                        self.reviews = decode(reviewData)!
                        self.archiveToDisk()
                        return self.reviews
                    } else {
                        self.unarchiveFromDisk()
                        return self.reviews
                    }
            }
        } else {
            self.unarchiveFromDisk()
            signalProducer = SignalProducer(value: self.reviews)
        }
        return signalProducer!
    }
    
    func createReview(parameters: ReviewParameters) -> SignalProducer<Bool, NSError> {
        let request = mutableRequestWithURL(reviewsURL, method: .POST)
        request.HTTPBody = httpBodyForReviewParameters(parameters)
        
        // Return Signal as if result of request is successful
        return SignalProducer(value: true)
        
    }
}

// TODO: Extract in to separate file
class MockReviewStore: ReviewStore {
    private var lastCompletion: ((result: [String: AnyObject]?, error: NSError?) -> (Void))?
    
    let mockReviews = [Review.init(reviewId: 1, rating: "5.0", title: "Some title", message: "Some message", author: "Someone", date: "May 26, 2016")]
    
    func simulateSuccessWithResult(result: [String: AnyObject]) {
        if let completion = lastCompletion {
            completion(result: result, error: nil)
        }
    }
    
    func simulateFailureWithError(error: NSError) {
        if let completion = lastCompletion {
            completion(result: nil, error: error)
        }
    }
}

// MARK: Persistence

extension ReviewStore {
    func archiveToDisk() {
        let reviewsDict = reviews.map { $0.encode() }
        
        
        let dataDict = [reviewsKey: reviewsDict]
        
        if let filePath = persistentFilePath() {
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(dataDict)
            do {
                try data.writeToFile(filePath, options: NSDataWritingOptions.AtomicWrite)
            }
            catch {
                print(error)
            }
        }
    }
    
    func unarchiveFromDisk() {
        if let
            path = persistentFilePath(),
            dataDict = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [String: AnyObject],
            reviewsDict = dataDict[reviewsKey],
            reviews: [Review] = decode(reviewsDict)
        {
            self.reviews = reviews
        }
    }

}


// MARK: Private Helpers

extension ReviewStore {
    
    private func httpBodyForReviewParameters(parameters: ReviewParameters) -> NSData? {
        let jsonObject: [String: String] = [
            "rating"  : parameters.rating!,
            "title"   : parameters.title!,
            "message" : parameters.message!,
            "author"  : parameters.author!,
            "date"    : parameters.date!
        ]
        
        return try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
    }
    
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
    
    private func reviewFromParameters(parameters: ReviewParameters, withIdentifier identifier: String) -> Review {
        
        return Review(
            reviewId: Int(arc4random()),
            rating: parameters.rating!,
            title: parameters.title!,
            message: parameters.message!,
            author: parameters.author!,
            date: parameters.date!
        )
    }
    
    private func persistentFilePath() -> String? {
        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as NSString?
        return basePath?.stringByAppendingPathComponent(archiveFileName)
    }
}
