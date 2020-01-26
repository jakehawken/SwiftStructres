//  DoublyLinkedList.swift
//  SwiftStructures
//  Created by Jake Hawken on 1/25/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import Foundation

public class DoublyLinkedListNode<T>: Equatable {
    let value: T
    var previous: DoublyLinkedListNode<T>?
    var next: DoublyLinkedListNode<T>?
    
    init(value: T) {
        self.value = value
    }
    
    fileprivate init(value: T, previousNode: DoublyLinkedListNode) {
        self.value = value
        self.previous = previousNode
        previousNode.next = self
    }
    
    fileprivate init(value: T, nextNode: DoublyLinkedListNode) {
        self.value = value
        self.next = nextNode
        nextNode.previous = self
    }
    
    public static func == (lhs: DoublyLinkedListNode<T>, rhs: DoublyLinkedListNode<T>) -> Bool {
        let memAddL = memoryAddressStringFor(lhs)
        let memAddR = memoryAddressStringFor(rhs)
        return memAddL == memAddR
    }
}

public extension DoublyLinkedListNode {
    
    func countFromHere() -> Int {
        var count = 0
        iterateFromHereUntil(terminus: .tail) { (_) in
            count += 1
        }
        return count
    }
    
    var isHeadNode: Bool {
        return previous == nil
    }
    
    var isTailNode: Bool {
        return next == nil
    }
    
    func isCircular() -> Bool {
        return findTerminus(.tail) == .infiniteLoop
    }
    
    func forEachFromHereForward(doBlock: @escaping (T)->()) {
        iterateFromHereUntil(terminus: .tail, block: doBlock)
    }
    
    func forEachFromHereBackward(doBlock: @escaping (T)->()) {
        iterateFromHereUntil(terminus: .head, block: doBlock)
    }
    
}

public extension DoublyLinkedListNode {
    
    enum InsertionError: Error, CustomStringConvertible {
        case appendError
        case prependError
        
        public var description: String {
            switch self {
            case .appendError:
                return "DoublyLinkedList insertion error: Cannot append. List is circular."
            case .prependError:
                return "DoublyLinkedList insertion error: Cannot prepend. List is circular."
            }
        }
    }
    
    @discardableResult func appendToTail(_ value: T) throws -> DoublyLinkedListNode {
        let terminus = findTerminus(.tail)
        switch terminus {
        case .infiniteLoop:
            throw InsertionError.appendError
        case .terminus(let tailNode):
            return DoublyLinkedListNode(value: value,
                                        previousNode: tailNode)
        }
    }
    
    @discardableResult func prependToHead(_ value: T) throws -> DoublyLinkedListNode {
        let terminus = findTerminus(.head)
        switch terminus {
        case .infiniteLoop:
            throw InsertionError.prependError
        case .terminus(let rootNode):
            return DoublyLinkedListNode(value: value,
                                        nextNode: rootNode)
        }
    }
    
    @discardableResult func insertAfter(_ value: T) -> DoublyLinkedListNode {
        let newNode = DoublyLinkedListNode(value: value)
        newNode.next = next
        next = newNode
        return newNode
    }
    
    @discardableResult func insertBefore(_ value: T) -> DoublyLinkedListNode {
        let newNode = DoublyLinkedListNode(value: value)
        newNode.previous = previous
        previous = newNode
        return newNode
    }
    
}

internal extension DoublyLinkedListNode {
    
    enum Terminus: Equatable {
        case terminus(DoublyLinkedListNode)
        case infiniteLoop
        
        static func == (lhs: DoublyLinkedListNode<T>.Terminus, rhs: DoublyLinkedListNode<T>.Terminus) -> Bool {
            switch (lhs, rhs) {
            case (.terminus(let node1), .terminus(let node2)):
                return node1 == node2
            case (.infiniteLoop, .infiniteLoop):
                return true
            default:
                return false
            }
        }
    }
    
    enum TerminalType {
        case head
        case tail
    }
    
    func findTerminus(_ terminus: TerminalType) -> Terminus {
        return iterateFromHereUntil(terminus: terminus, block: nil)
    }
    
    @discardableResult func iterateFromHereUntil(terminus: TerminalType, block: ((T)->())?) -> Terminus {
        block?(value)
        
        if terminus == .head, isHeadNode {
            return .terminus(self)
        }
        if terminus == .tail, isTailNode {
            return .terminus(self)
        }
        var memAddressSet = Set<String>()
        let selfAddress = memoryAddressStringFor(self)
        memAddressSet.insert(selfAddress)
        
        var current = self
        var nextToCheck = (terminus == .head) ? previous : next
        
        while let checking = nextToCheck {
            let addy = memoryAddressStringFor(checking)
            if memAddressSet.contains(addy) {
                return .infiniteLoop
            }
            memAddressSet.insert(addy)
            
            block?(checking.value)
            current = checking
            nextToCheck = (terminus == .head) ? checking.previous : checking.next
        }
        
        return .terminus(current)
    }
    
}

public class DoublyLinkedList<T> {
    
    private var rootNode: DoublyLinkedListNode<T>
    private var tailNode: DoublyLinkedListNode<T>
    
    public init(firstValue: T) {
        let firstNode = DoublyLinkedListNode(value: firstValue)
        self.rootNode = firstNode
        self.tailNode = firstNode
    }
    
}

public extension DoublyLinkedList {
    
    func count() -> Int {
        return rootNode.countFromHere()
    }
    
    var rootValue: T {
        return rootNode.value
    }
    
    var tailValue: T {
        return tailNode.value
    }
    
}

public extension DoublyLinkedList {
    
    func append(_ value: T) {
        if let newNode = try? tailNode.appendToTail(value) {
            tailNode = newNode
        }
        else {
            let newNode = DoublyLinkedListNode(value: value, previousNode: tailNode)
            tailNode = newNode
        }
    }
    
    func prepend(_ value: T) {
        if let newNode = try? rootNode.prependToHead(value) {
            rootNode = newNode
        }
        else {
            let newNode = DoublyLinkedListNode(value: value, nextNode: rootNode)
            rootNode = newNode
        }
    }
    
    static func fromArray(_ array: [T]) -> DoublyLinkedList? {
        var list: DoublyLinkedList?
        array.forEach { (item) in
            if let list = list {
                list.append(item)
            }
            else {
                list = DoublyLinkedList(firstValue: item)
            }
        }
        return list
    }
    
}

public extension DoublyLinkedList {
    
    func forEachFromRootToTail(doBlock: @escaping (T)->()) {
        rootNode.iterateFromHereUntil(terminus: .tail, block: doBlock)
    }
    
    func forEachFromTailToRoot(doBlock: @escaping (T)->()) {
        tailNode.iterateFromHereUntil(terminus: .head, block: doBlock)
    }
    
    func rootToTailArray() -> [T] {
        var array = [T]()
        forEachFromRootToTail(doBlock: { array.append($0) })
        return array
    }
    
    func tailToRootArray() -> [T] {
        var array = [T]()
        forEachFromTailToRoot(doBlock: { array.append($0) })
        return array
    }
    
}
