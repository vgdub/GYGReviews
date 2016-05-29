//
//  EditReviewViewModel.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/28/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import ReactiveCocoa

class AddReviewViewModel {
    
    // Inputs
    let rating: MutableProperty<Int>
    let title: MutableProperty<String>
    let message: MutableProperty<String>
    let author: MutableProperty<String>
    let date: MutableProperty<String>
    
    //Outputs
    let viewTitle: String
    let ratingStepperMax: Double
    let ratingStepperMin: Double
    let formattedRating  = MutableProperty<String>("")
    let formattedTitle   = MutableProperty<String>("")
    let formattedMessage = MutableProperty<String>("")
    let formattedAuthor  = MutableProperty<String>("")
    let formattedDate    = MutableProperty<String>("")
    
    let inputIsValid = MutableProperty<Bool>(false)
    
    lazy var saveAction: Action<Void, Bool, NSError> = { [unowned self] in
        return Action(enabledIf: self.inputIsValid, { _ in
            let parameters = ReviewParameters(
                reviewId: Int(arc4random()),
                rating:   self.formattedRating.value,
                title:    self.formattedTitle.value,
                message:  self.formattedMessage.value,
                author:   self.formattedAuthor.value,
                date:     self.date.value
            )
            
            return self.store.createReview(parameters)
        })
        
    }()
    
    private let store: StoreType
    
    // MARK: Lifecycle
    
    init(store: StoreType) {
        self.store = store
        self.viewTitle = "New Review"
        
        ratingStepperMax = Double(5)
        ratingStepperMin = Double(0)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        self.rating  = MutableProperty(5)
        self.title   = MutableProperty("Enter a title")
        self.message = MutableProperty("Eneter a review")
        self.author  = MutableProperty("Enter your name")
        self.date    = MutableProperty(dateFormatter.stringFromDate(NSDate()))

        self.formattedRating <~ rating.producer
            .map { rating in
                return "\(rating) / 5"
            }

        self.formattedTitle <~ title.producer
            .map { title in
                return title.isEmpty ? "Enter a title" : title
            }
        
        self.formattedMessage <~ message.producer
            .map { message in
                return message.isEmpty ? "Enter a review" : message
            }
        
        self.formattedAuthor <~ author.producer
            .map { author in
                return author.isEmpty ? "Enter your name" : author
            }
        
        self.inputIsValid <~ combineLatest(title.producer, message.producer, author.producer, date.producer)
            .map { (title, message, author, date) in
                return !title.isEmpty && !message.isEmpty && !author.isEmpty && !date.isEmpty
            }
    }
}
