//
//  ReviewsViewController.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/27/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let reviewCellIdentifier = "ReviewCell"
    private let viewModel: ReviewsViewModel
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    
    
    // MARK: - Lifecycle
    
    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let store = ReviewStore()
        self.viewModel = ReviewsViewModel(store: store)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView() // Prevent empty rows at bottom
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self,
            action: #selector(refreshControlTriggered),
            forControlEvents: .ValueChanged
        )
        tableView.addSubview(refreshControl!)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem:  .Add,
            target: self,
            action: #selector(addReviewButtonTapped)
        )
        
        bindViewModel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - Bindings

extension ReviewsViewController {
    
    
    private func bindViewModel() {
        self.title = viewModel.title
        
        viewModel.active <~ isActive()
        
        viewModel.contentChangesSignal
            .observeOn(UIScheduler())
            .observeNext({ [weak self] changeset in
                guard let tableView = self?.tableView else { return }
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths(changeset.deletions, withRowAnimation: .Automatic)
                tableView.reloadRowsAtIndexPaths(changeset.modifications, withRowAnimation: .Automatic)
                tableView.insertRowsAtIndexPaths(changeset.insertions, withRowAnimation: .Automatic)
                tableView.endUpdates()
                })
        
        viewModel.isLoading.producer
            .observeOn(UIScheduler())
            .startWithNext({ [weak self] isLoading in
                if !isLoading {
                    self?.refreshControl?.endRefreshing()
                }
                })
        
        viewModel.alertMessageSignal
            .observeOn(UIScheduler())
            .observeNext({ [weak self] alertMessage in
                let alertController = UIAlertController(
                    title: "Oops!",
                    message: alertMessage,
                    preferredStyle: .Alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self?.presentViewController(alertController, animated: true, completion: nil)
                })
    }
}

// MARK: User Interaction

extension ReviewsViewController {
    
    
    func addReviewButtonTapped() {
        print("tapped add button")
    }
    
    func refreshControlTriggered() {
        viewModel.refreshObserver.sendNext(())
    }
}

// MARK: UITableViewDataSource

extension ReviewsViewController {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfReviewsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reviewCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = viewModel.reviewTitleAtIndexPath(indexPath)
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension ReviewsViewController {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}