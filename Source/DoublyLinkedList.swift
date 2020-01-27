//  DoublyLinkedList.swift
//  SwiftStructures
//  Created by Jake Hawken on 1/25/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import Foundation

//MARK: - Doubly-Linked List -

public class DoublyLinkedList<T> {
    
    private var rootNode: DoublyLinkedListNode<T>
    private var tailNode: DoublyLinkedListNode<T>
    
    public init(firstValue: T) {
        let firstNode = DoublyLinkedListNode(value: firstValue)
        self.rootNode = firstNode
        self.tailNode = firstNode
    }
    
    public static func fromArray(_ array: [T]) -> DoublyLinkedList? {
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

//MARK: - Data methods

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
    
    /**
    Finds the first value in the list which matches criteria passed in via the `where` block.
    - Parameter where: The block into which each value in the list will be passed until the block returns `true` or the list ends.
    - returns: The first node for which the `where` block returns true. If none do, returns `nil`
    */
    func firstValue(where whereBlock: (T)->Bool) -> T? {
        var current: DoublyLinkedListNode? = rootNode
        while let currentNode = current {
            if whereBlock(currentNode.value) {
                return currentNode.value
            }
            current = currentNode.next
        }
        return nil
    }
    
}

//MARK: - Mutation methods

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
    
}

//MARK: - Iteration methods

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
    
    //MARK: Map
    
    func mapRootToTail<MappedType>(mapBlock: @escaping (T)->(MappedType)) -> [MappedType] {
        var mappedArray = [MappedType]()
        forEachFromRootToTail { (value) in
            let mapValue = mapBlock(value)
            mappedArray.append(mapValue)
        }
        return mappedArray
    }
    
    func mapTailToRoot<MappedType>(mapBlock: @escaping (T)->(MappedType)) -> [MappedType] {
        var mappedArray = [MappedType]()
        forEachFromTailToRoot { (value) in
            let mapValue = mapBlock(value)
            mappedArray.append(mapValue)
        }
        return mappedArray
    }
    
    //MARK: Filter
    
    func filterRootToTail(shouldInclude: @escaping (T)->Bool) -> [T] {
        var outputArray = [T]()
        forEachFromRootToTail { (value) in
            if shouldInclude(value) {
                outputArray.append(value)
            }
        }
        return outputArray
    }
    
    func filterTailToRoot(shouldInclude: @escaping (T)->Bool) -> [T] {
        var outputArray = [T]()
        forEachFromTailToRoot { (value) in
            if shouldInclude(value) {
                outputArray.append(value)
            }
        }
        return outputArray
    }
    
}

//MARK: - Debug

extension DoublyLinkedList: CustomStringConvertible {
    
    public var description: String {
        var output = "DLinkedList{"
        var currentNode: DoublyLinkedListNode? = rootNode
        while let node = currentNode {
            output += "(\(node.value))"
            if node.next != nil {
                output += "<->"
            }
            currentNode = node.next
        }
        output += "}"
        return output
    }
    
}

//MARK: - GENERICALLY CONDITIONAL METHODS

public extension DoublyLinkedList where T:Equatable {
    
    func contains(_ value: T) -> Bool {
        return firstValue(where: { $0 == value }) != nil
    }
    
}

public extension DoublyLinkedList where T:AnyObject {
    
    func containsObject(_ value: T) -> Bool {
        let firstVal = firstValue { (element) in
            memoryAddressStringFor(element) == memoryAddressStringFor(value)
        }
        return firstVal != nil
    }
    
}

//MARK: - Doubly-Linked List Node -

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

extension DoublyLinkedListNode: CustomStringConvertible {
    
    public var description: String {
        let nextString: String
        if let next = next {
            nextString = "\(next.value)"
        }
        else {
            nextString = "nil"
        }
        return "Node{value: (\(value)), nextValue:(\(nextString))}"
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
