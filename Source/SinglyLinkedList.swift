//  SinglyLinkedList.swift
//  SwiftStructures
//  Created by Jake Hawken on 1/21/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import Foundation

// MARK: - SinglyLinkedListNode<T>

public class SinglyLinkedListNode<T>: Equatable {
    let value: T
    var next: SinglyLinkedListNode<T>?
    
    init(value: T) {
        self.value = value
    }
    
    public static func == (lhs: SinglyLinkedListNode<T>, rhs: SinglyLinkedListNode<T>) -> Bool {
        let addressL = memoryAddressStringFor(lhs)
        let addressR = memoryAddressStringFor(rhs)
        return addressL == addressR
    }
}

public extension SinglyLinkedListNode {
    
    @discardableResult func insert(value: T) -> SinglyLinkedListNode {
        if let next = next {
            return next.insert(value: value)
        }
        let nextNode = SinglyLinkedListNode(value: value)
        next = nextNode
        return nextNode
    }
    
    func forEachFromHere(doBlock: (T)->()) {
        doBlock(value)
        next?.forEachFromHere(doBlock: doBlock)
    }
    
    func findTerminalNode() -> SinglyLinkedListNode<T> {
        guard let next = next else {
            return self
        }
        return next.findTerminalNode()
    }
    
    func removeAllChildren() {
        let next = self.next
        self.next = nil
        next?.removeAllChildren()
    }
    
    func listFromHere() -> SinglyLinkedList<T> {
        return SinglyLinkedList(rootNode: self)
    }
    
}

extension SinglyLinkedListNode: CustomStringConvertible {
    
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

// MARK: - SinglyLinkedList<T>

/**
 The `SinglyLinkedList<T>` class exists to manage a list of nodes primarily by maintaining references to the head and tail, so that inserting to the list can be achieved in constant time. Secondarily, the list object provides convenience methods for easy management and manipulation of the list.
*/
public class SinglyLinkedList<T> {
    let rootNode: SinglyLinkedListNode<T>
    private(set) var tailNode: SinglyLinkedListNode<T>
    
    /**
    The basic initializer for creating a new linked list. The value passed in will be the value of the root node, and will determine the generic type of the list, i.e. calling `SinglyLinkedList(firstValue: 3)` will generate a `SinglyLinkedList<Int>`.
    - Parameter firstValue: The value that will become set to the `value` property of the root node. At initialization, there will only be one node, so the `rootNode` and `tailNode` properties will return the same object.
    */
    init(firstValue: T) {
        let first = SinglyLinkedListNode(value: firstValue)
        self.rootNode = first
        self.tailNode = first
    }
    
    /**
    An initializer for creating linked lists from an existing node. Since it will have to iteratively determine the tailNode (since the root may have attached child nodes) this initialization is an O(n) operation.
    - Parameter rootNode: A preexisting node that will become the root node for this list. If it has any child nodes, the the tail will be found and set to the `tailNode` property.
    */
    init(rootNode: SinglyLinkedListNode<T>) {
        self.rootNode = rootNode
        self.tailNode = rootNode.findTerminalNode()
    }
}

public extension SinglyLinkedList {
    /**
    Returns the current number of nodes in the list. This is done iteratively and is thus an O(n) operation.
    */
    var count: Int {
        var nodeCount = 0
        forEach { (_) in nodeCount += 1 }
        return nodeCount
    }
    
    /**
    Returns the value of the first node in the list.
    */
    var firstValue: T {
        return rootNode.value
    }
    
    /**
    Returns the value of the last node in the list.
    */
    var lastValue: T {
        return tailNode.value
    }
    
    /**
    Finds the first node in the list which matches criteria passed in via there `where` block.
    - Parameter where: The block into which each node in the array will be passed until the block returns `true`.
    - returns: The first node for which the `where` block returns true. If none do, returns `nil`
    */
    func firstNode(where whereBlock: (SinglyLinkedListNode<T>)->Bool) -> SinglyLinkedListNode<T>? {
        var current: SinglyLinkedListNode? = rootNode
        while let currentNode = current {
            if whereBlock(currentNode) {
                return currentNode
            }
            current = currentNode.next
        }
        return nil
    }
}

public extension SinglyLinkedList {
    /**
    Inserts a value onto the end of the list. Since references are maintained to the r`oot and tail of the list, insertion happens in O(1) time.
    - Parameter value: The value that will go into the new tailNode of the list.
    */
    func insert(value: T) {
        let newNode = SinglyLinkedListNode(value: value)
        tailNode.next = newNode
        tailNode = newNode
    }
    
    /**
    Removes all nodes in the list except for the root.
    */
    func trimToRoot() {
        rootNode.removeAllChildren()
    }
}
 
public extension SinglyLinkedList {
    /**
     Iterates through each node of the list and executes the given block for each data element (T) in the list.
     - Parameter doBlock: A block with no return value into which the value of each node in the list will be passed.
     */
    func forEach(doBlock: (T)->()) {
        rootNode.forEachFromHere(doBlock: doBlock)
    }
    
    /**
    Generates an array from the contents of the list, honoring the data order. e.g. List{ (0)->(1)->(2) } will generate [0,1,2]
    */
    func asArray() -> [T] {
        var output = [T]()
        forEach { output.append($0) }
        return output
    }
    
    /**
    Generates a linked list of the respective elements of an array, honoring the data order, e.g. passing in [0,1,2] will generate List{ (0)->(1)->(2) }
    - Parameter array: The array which will be used to generate the list.
    - returns: An optional singly linked list. If the array is empty, this will be nil. Otherwise, it will be non-nil.
    */
    static func fromArray(_ array: [T]) -> SinglyLinkedList? {
        var list: SinglyLinkedList?
        array.forEach { (item) in
            if let list = list {
                list.insert(value: item)
            }
            else {
                list = SinglyLinkedList(firstValue: item)
            }
        }
        return list
    }
}

extension SinglyLinkedList: CustomStringConvertible {
    
    public var description: String {
        var output = "List{"
        var currentNode: SinglyLinkedListNode? = rootNode
        while let node = currentNode {
            output += "(\(node.value))"
            if node.next != nil {
                output += "->"
            }
            currentNode = node.next
        }
        output += "}"
        return output
    }
    
}
