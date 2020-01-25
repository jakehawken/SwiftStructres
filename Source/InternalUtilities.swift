//  InternalUtilities.swift
//  SwiftStructures
//  Created by Jake Hawken on 1/24/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import Foundation

internal func memoryAddressStringFor(_ obj: AnyObject) -> String {
    return "\(Unmanaged.passUnretained(obj).toOpaque())"
}
