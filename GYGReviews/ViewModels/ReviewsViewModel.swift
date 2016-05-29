//
//  ReviewsViewModel.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/27/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import ReactiveCocoa
import Result

class ReviewsViewModel {
    
    typealias ReviewChangeset = Changeset<Review>
    
    // Inputs
    let active = MutableProperty(false)
    let refreshObserver: Observer<Void, NoError>
    
    // Outputs
    let title: String
    let contentChangesSignal: Signal<ReviewChangeset, NoError>
    let isLoading: MutableProperty<Bool>
    let alertMessageSignal: Signal<String, NoError>
    
    // Actions
    
    private let store: StoreType
    private let contentChangesObserver: Observer<ReviewChangeset, NoError>
    private let alertMessageObserver: Observer<String, NoError>
    private var reviews: [Review]

    // MARK: - Lifecycle

    init(store: StoreType) {
        self.title = "Reviews"
        self.store = store
        self.reviews = []
        
        let (refreshSignal, refreshObserver) = SignalProducer<Void, NoError>.buffer(0)
        self.refreshObserver = refreshObserver
        
        let (contentChangesSignal, contentChangesObserver) = Signal<ReviewChangeset, NoError>.pipe()
        self.contentChangesSignal = contentChangesSignal
        self.contentChangesObserver = contentChangesObserver
        
        let isLoading = MutableProperty(false)
        self.isLoading = isLoading
        
        let (alertMessagesSignal, alertMessageObserver) = Signal<String, NoError>.pipe()
        self.alertMessageSignal = alertMessagesSignal
        self.alertMessageObserver = alertMessageObserver
        
        // Trigger refresh when view becomes active
        active.producer
            .filter { $0 }
            .map { _ in () }
            .start(refreshObserver)
        
        refreshSignal
            .on(next: { _ in isLoading.value = true })
            .flatMap(.Latest) { _ in
                return store.fetchReviews()
                    .flatMapError { error in
                        alertMessageObserver.sendNext(error.localizedDescription)
                        return SignalProducer(value: [])
                }
            }
            .on(next: { _ in isLoading.value = false})
            .combinePrevious([])
            .startWithNext({ [weak self] (oldReviews, newReviews) in
                self?.reviews = newReviews
                if let observer = self?.contentChangesObserver {
                    let changeset = Changeset(
                        oldItems: oldReviews,
                        newItems: newReviews,
                        contentMatches: Review.contentMatches
                    )
                    observer.sendNext(changeset)
                }
            })
        
    }
}

// MARK: - Data Source

extension ReviewsViewModel {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfReviewsInSection(section: Int) -> Int {
        return reviews.count
    }
    
    func reviewTitleAtIndexPath(indextPath: NSIndexPath) -> String {
        let review = reviewAtIndexPath(indextPath)
        return review.title!
    }
    
    func reviewDateAtIndexPath(indexPath: NSIndexPath) -> String {
        let review = reviewAtIndexPath(indexPath)
        return review.date!
    }
    
    func reviewMessageAtIndexPath(indexPath: NSIndexPath) -> String {
        let review = reviewAtIndexPath(indexPath)
        return review.message!
    }
    
    func reviewRatingAtIndexPath(indexPath: NSIndexPath) -> String {
        let review = reviewAtIndexPath(indexPath)
        return review.rating!
    }
    
    func reviewAuthorAtIndexPath(indexPath: NSIndexPath) -> String {
        let review = reviewAtIndexPath(indexPath)
        return review.author!
    }
}

// Mark: Internal Helpers

extension ReviewsViewModel {
    private func reviewAtIndexPath(indexPath: NSIndexPath) -> Review {
        return reviews[indexPath.row]
    }
}