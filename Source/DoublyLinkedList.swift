//  DoublyLinkedList.swift
//  SwiftStructures
//  Created by Jake Hawken on 1/25/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import Foundation

//MARK: - Doubly-Linked List -

public class DoublyLinkedList<T> {
    
    private var rootNode: DoublyLinkedListNode<T>
    private var tailNode: DoublyLinkedListNode<T>
    
    /**
    The basic initializer for creating a new doubly-linked list. The value passed in will be the value of the root node, and will determine the generic type of the list, i.e. calling `DoublyLinkedList(firstValue: 3)` will generate a `DoublyLinkedList<Int>`.
    - Parameter firstValue: The initial `rootValue`. At initialization, there will only be one element, so the `rootValue` and `tailValue` properties will return the same element.
    */
    public init(firstValue: T) {
        let firstNode = DoublyLinkedListNode(value: firstValue)
        self.rootNode = firstNode
        self.tailNode = firstNode
    }
    
    /**
    Generates a doubly-linked list of the respective elements of an array, honoring the data order, e.g. passing in [0,1,2] will generate DLinkedList{(0)->(1)->(2)}
    - Parameter array: The array which will be used to generate the list.
    - returns: An optional doubly-linked list. If the array is empty, this will be nil. Otherwise, it will be non-nil.
    */
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
    /**
    Returns the current number of nodes in the list. This is done iteratively and is thus an O(n) operation.
     
    This method executes in O(n) time.
    */
    func count() -> Int {
        return rootNode.countFromHere()
    }
    
    /**
    Returns the element at the root position.
    */
    var rootValue: T {
        return rootNode.value
    }
    
    /**
    Returns the element at the tail position.
    */
    var tailValue: T {
        return tailNode.value
    }
    
    /**
    Finds the first value in the list which matches criteria passed in via the `where` block.
    - Parameter where: The block into which each value in the list will be passed until the block returns `true` or the list ends.
    - returns: The first node for which the `where` block returns true. If none do, returns `nil`
     
    This method executes in (up to) O(n) time.
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
    /**
    Appends a value onto the end of the list. Since references are maintained to the root and tail of the list, insertion happens in constant time.
    - Parameter value: The value that will become the new `tailValue` of the list.
    
    This method executes in constant time.
    */
    func append(_ value: T) {
        if let newNode = try? tailNode.appendToTail(value) {
            tailNode = newNode
        }
        else {
            let newNode = DoublyLinkedListNode(value: value, previousNode: tailNode)
            tailNode = newNode
        }
    }
    
    /**
    Prepends a value onto the beginning of the list. Since references are maintained to the root and tail of the list, insertion happens in constant time.
    - Parameter value: The value that will become the new `rootValue` of the list.
    
    This method executes in constant time.
    */
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
    
    enum IterationDirection {
        case rootToTail
        case tailToRoot
    }
    
    /**
    Iterates through the list in the specified direction, and executes the given block for each element in the list.
    - Parameter from: Declares the iterating direction.
    - Parameter doBlock: A block with no return value into which the value of each node in the list will be passed.
     
     This method executes in O(n) time.
    */
    func forEach(from direction: IterationDirection, doBlock: @escaping (T)->()) {
        switch direction {
        case .rootToTail:
            rootNode.iterateFromHereUntil(terminus: .tail, block: doBlock)
        case .tailToRoot:
            tailNode.iterateFromHereUntil(terminus: .head, block: doBlock)
        }
    }
    
    /**
    Generates an array from the contents of the list in the specified order.
    - Parameter from: Declares the iterating direction.
    - returns: An array corresponding to the elements of the list, in the specified order. Guaranteed to have at least one element.
    
    This method executes in O(n) time.
    */
    func asArray(from direction: IterationDirection) -> [T] {
        var array = [T]()
        forEach(from: direction, doBlock: { array.append($0) })
        return array
    }
    
    //MARK: Map
    
    /**
    Generates an array from the contents of the list, in the specified order, based on the output of the mapping block.
    - Parameter from: Declares the iterating direction.
    - Parameter mapBlock: A block which generates a new value (of `MappedType`) into which each element of the list is passed.
    - returns: An array corresponding to the elements of the list. Guaranteed to have at least one element.
    # Example #
    ```
     let myList = DoublyLinkedList.fromArray([1,3,5])
     let mappedList = myList?.map(from: .rootToTail) { {element) in
        "\(element)"
     }
     // mappedList will equal ["1", "3", "5"]
    ```
     
     This method executes in O(n) time.
    */
    func map<MappedType>(from direction: IterationDirection, mapBlock: @escaping (T)->(MappedType)) -> [MappedType] {
        var mappedArray = [MappedType]()
        forEach(from: direction) { (value) in
            let mapValue = mapBlock(value)
            mappedArray.append(mapValue)
        }
        return mappedArray
    }
    
    /**
    Generates an array from the contents of the list, in the specified order, based on the output of the mapping block.
    - Parameter from: Declares the iterating direction.
    - Parameter mapBlock: A block which generates an optional value (of `MappedType`) into which each element of the list is passed. When the block returns nil, nothing is added to the output array for that element.
    - returns: An array corresponding to the elements of the list. Not guaranteed to have any elements.
    # Example #
    ```
     let myList = DoublyLinkedList.fromArray([1,3,nil,5])
     let mappedList = myList?.compactMap(from: .rootToTail, mapBlock: { $0 })
     // mappedList will equal [1, 3, 5]
    ```
     
     This method executes in O(n) time.
    */
    func compactMap<MappedType>(from direction: IterationDirection, mapBlock: @escaping (T)->(MappedType?)) -> [MappedType] {
        var mappedArray = [MappedType]()
        forEach(from: direction) { (value) in
            if let mapValue = mapBlock(value) {
                mappedArray.append(mapValue)
            }
        }
        return mappedArray
    }
    
    //MARK: Filter
    
    /**
    Generates an array of elements from the list, in the specified order, which meet the criteria determined by the `shouldInclude` block.
    - Parameter from: Declares the iterating direction.
    - Parameter shouldInclude: A block into which each element of the list is passed. If the block returns `true`, that element will be included in the output array.
    - returns: An array of elements from the list which meeet the criteria of the `shouldInclude` block, in the specified order.
    # Example #
    ```
     let myList = DoublyLinkedList.fromArray([1, 3, 5])
     let filtered = myList?.filter(from: .tailToRoot) { $0 < 4 }
     // filtered will equal [3, 1]
    ```
     
     This method executes in O(n) time.
    */
    func filter(from direction: IterationDirection, shouldInclude: @escaping (T)->Bool) -> [T] {
        var outputArray = [T]()
        forEach(from: direction) { (value) in
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
    /**
    Determines if the list contains an element.
    - Parameter value: The value being checked for. If the list contains element that is equal to this value, the method will return `true`.
    - returns: `True` if the list contains the value. `False` if it does not.
    
    This method executes in (up to) O(n) time.
    */
    func contains(_ value: T) -> Bool {
        return firstValue(where: { $0 == value }) != nil
    }
    
}

public extension DoublyLinkedList where T:AnyObject {
    /**
    Determines if the list contains an element.
    - Parameter object: The object being checked for. If the list contains this exact object, the method will return `true`.
    - returns: `True` if the list contains the given object. `False` if it does not.
    
    This method executes in (up to) O(n) time.
    */
    func containsObject(_ object: T) -> Bool {
        let firstVal = firstValue { (element) in
            memoryAddressStringFor(element) == memoryAddressStringFor(object)
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
