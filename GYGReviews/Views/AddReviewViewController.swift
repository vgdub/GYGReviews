//
//  AddReviewViewController.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/28/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import ReactiveCocoa

class AddReviewViewController: UIViewController {
    
    private let viewModel: AddReviewViewModel
    @IBOutlet weak var ratingStepper: UIStepper!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var saveAction: CocoaAction
    private let saveButtonItem: UIBarButtonItem
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        let store = ReviewStore()
        self.viewModel = AddReviewViewModel(store: store)
        self.saveAction = CocoaAction(viewModel.saveAction, { _ in return () })
        self.saveButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Save,
            target: self.saveAction,
            action: CocoaAction.selector
        )
        super.init(coder: aDecoder)
        
        // Set up navigation item
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.rightBarButtonItem = self.saveButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Bindings
    
    private func bindViewModel() {
        self.title = viewModel.viewTitle
        
        ratingStepper.maximumValue = viewModel.ratingStepperMax
        ratingStepper.minimumValue = viewModel.ratingStepperMin
        
        // Initial Values
        ratingStepper.value = Double(viewModel.rating.value)
        titleTextField.text = viewModel.title.value
        messageTextField.text = viewModel.message.value
        authorTextField.text = viewModel.author.value
        dateLabel.text = viewModel.date.value
        
        viewModel.rating   <~ ratingStepper.signalProducer()
        viewModel.title    <~ titleTextField.signalProducer()
        viewModel.message  <~ messageTextField.signalProducer()
        viewModel.author   <~ messageTextField.signalProducer()
        
        
        viewModel.formattedRating.producer
            .observeOn(UIScheduler())
            .startWithNext({ [weak self] formattedRating in
                self?.ratingLabel.text = formattedRating
            })
        
        viewModel.inputIsValid.producer
            .observeOn(UIScheduler())
            .startWithNext({ [weak self] inputIsValid in
                self?.saveButtonItem.enabled = inputIsValid
            })

        viewModel.saveAction.events.observeNext({ [weak self] event in
            switch event {
            case let .Next(success):
                if success {
                    self?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self?.presentErrorMessage("The match could not be saved.")
                }
            case let .Failed(error):
                self?.presentErrorMessage(error.localizedDescription)
            default:
                return
            }
        })
    }
    
}

// MARK: User Interaction

extension AddReviewViewController{
    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: Private Helpers

extension AddReviewViewController {
    
    func presentErrorMessage(message: String) {
        let alertController = UIAlertController(
            title: "Oops!",
            message: message,
            preferredStyle: .Alert
        )
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
