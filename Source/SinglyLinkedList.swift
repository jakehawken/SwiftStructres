//  SinglyLinkedList.swift
//  SwiftStructures
//  Created by Jake Hawken on 1/21/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import Foundation

public class SinglyLinkedListNode<T> {
    let data: T
    var next: SinglyLinkedListNode<T>?
    
    init(data: T) {
        self.data = data
    }
}

public extension SinglyLinkedListNode {
    
    func insert(value: T) {
        if let next = next {
            next.insert(value: value)
            return
        }
        next = SinglyLinkedListNode(data: value)
    }
    
    func forEachFromHere(doBlock: (T)->()) {
        doBlock(data)
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
            nextString = "\(next.data)"
        }
        else {
            nextString = "nil"
        }
        return "Node{data: (\(data)), next:(\(nextString))}"
    }
    
}

public class SinglyLinkedList<T> {
    let rootNode: SinglyLinkedListNode<T>
    private(set) var tailNode: SinglyLinkedListNode<T>
    
    init(firstValue: T) {
        let first = SinglyLinkedListNode(data: firstValue)
        self.rootNode = first
        self.tailNode = first
    }
    
    init(rootNode: SinglyLinkedListNode<T>) {
        self.rootNode = rootNode
        self.tailNode = rootNode.findTerminalNode()
    }
    
}

public extension SinglyLinkedList {
    
    var count: Int {
        var nodeCount = 0
        forEach { (_) in nodeCount += 1 }
        return nodeCount
    }
    
    func insert(value: T) {
        let newNode = SinglyLinkedListNode(data: value)
        tailNode.next = newNode
        tailNode = newNode
    }
    
    func forEach(doBlock: (T)->()) {
        rootNode.forEachFromHere(doBlock: doBlock)
    }
    
    func trimToRoot() {
        rootNode.removeAllChildren()
    }
    
    func asArray() -> [T] {
        var output = [T]()
        forEach { output.append($0) }
        return output
    }
    
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
            output += "(\(node.data))"
            if node.next != nil {
                output += "->"
            }
            currentNode = node.next
        }
        output += "}"
        return output
    }
    
}
