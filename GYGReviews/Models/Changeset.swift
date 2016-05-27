//
//  Changeset.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/27/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

import Foundation

struct Changeset<T: Equatable> {
    
    var deletions: [NSIndexPath]
    var modifications: [NSIndexPath]
    var insertions: [NSIndexPath]
    
    typealias ContentMatches = (T, T) -> Bool
    
    init(oldItems: [T], newItems: [T], contentMatches: ContentMatches) {
        
        deletions = oldItems.difference(newItems).map { item in
            return Changeset.indexPathForIndex(oldItems.indexOf(item)!)
        }
        
        modifications = oldItems.intersection(newItems)
            .filter({ item in
                let newItem = newItems[newItems.indexOf(item)!]
                return !contentMatches(item, newItem)
            })
            .map({ item in
                return Changeset.indexPathForIndex(oldItems.indexOf(item)!)
            })
        
        insertions = newItems.difference(oldItems).map { item in
            return NSIndexPath(forRow: newItems.indexOf(item)!, inSection: 0)
        }
    }
    
    private static func indexPathForIndex(index: Int) -> NSIndexPath {
        return NSIndexPath(forRow: index, inSection: 0)
    }
}