//
//  Encodable.swift
//  GYGReviews
//
//  Created by Greg Williams on 5/27/16.
//  Copyright © 2016 Greg Williams. All rights reserved.
//

protocol Encodable {
    func encode() -> [String: AnyObject]
}
