//  SinglyLinkedListTests.swift
//  SwiftStructuresTests
//  Created by Jake Hawken on 1/22/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import XCTest
@testable import SwiftStructures

class SinglyLinkedListTests: XCTestCase {

    override func setUp() {}
    override func tearDown() {}

    func testInitializeWithValue() {
        let subject = SinglyLinkedList(firstValue: 3)
        XCTAssert(subject.count == 1)
        XCTAssert(subject.rootNode.value == 3)
        XCTAssert(subject.tailNode.value == 3)
        XCTAssert(subject.description == "List{(3)}")
        var array = [Int]()
        subject.forEach { (item) in
            array.append(item)
        }
        XCTAssert(array.count == 1)
        XCTAssert(array.first == 3)
    }

    func testInitializeWithRootNode() {
        var rootNode = SinglyLinkedListNode(value: 1)
        var subject = SinglyLinkedList(rootNode: rootNode)
        
        XCTAssert(subject.count == 1)
        XCTAssert(subject.rootNode.value == 1)
        XCTAssert(subject.tailNode.value == 1)
        XCTAssert(subject.description == "List{(1)}")
        var array = [Int]()
        subject.forEach { (item) in
            array.append(item)
        }
        XCTAssert(array.count == 1)
        XCTAssert(array.first == 1)
        
        rootNode = SinglyLinkedListNode(value: 2)
        rootNode.insert(value: 3)
        rootNode.insert(value: 4)
        rootNode.insert(value: 5)
        subject = SinglyLinkedList(rootNode: rootNode)
        
        XCTAssert(subject.count == 4)
        XCTAssert(subject.rootNode.value == 2)
        XCTAssert(subject.tailNode.value == 5)
        XCTAssert(subject.description == "List{(2)->(3)->(4)->(5)}")
        array.removeAll()
        subject.forEach { (item) in
            array.append(item)
        }
        XCTAssert(array.count == 4)
        XCTAssert(array.first == 2)
    }
    
    func testConstructFromArray() {
        let originalArray = [1,2,3,4,5,6,7,8]
        let subject = SinglyLinkedList.fromArray(originalArray)
        XCTAssertNotNil(subject)
        XCTAssert(subject?.count == originalArray.count)
        XCTAssert(subject?.rootNode.value == 1)
        XCTAssert(subject?.tailNode.value == 8)
        var generatedArray = [Int]()
        subject?.forEach { (item) in
            generatedArray.append(item)
        }
        XCTAssert(generatedArray == originalArray)
        XCTAssert(subject?.description == "List{(1)->(2)->(3)->(4)->(5)->(6)->(7)->(8)}")
    }
    
    func testGenerateArray() {
        let subject = SinglyLinkedList(firstValue: 9)
        subject.insert(value: 8)
        subject.insert(value: 7)
        subject.insert(value: 6)
        let generatedArray = subject.asArray()
        XCTAssert(generatedArray == [9,8,7,6])
    }

    func testForEach() {
        let subject = SinglyLinkedList(firstValue: 1)
        subject.insert(value: 2)
        subject.insert(value: 3)
        subject.insert(value: 4)
        subject.insert(value: 5)
        var array = [Int]()
        subject.forEach { (item) in
            array.append(item)
        }
        XCTAssert(array == [1,2,3,4,5])
    }
    
    func testTrimToRoot() {
        let subject = SinglyLinkedList(firstValue: 1)
        subject.insert(value: 2)
        subject.insert(value: 3)
        subject.insert(value: 4)
        subject.insert(value: 5)
        subject.trimToRoot()
        XCTAssert(subject.count == 1)
        XCTAssertNil(subject.rootNode.next)
    }
    
    func testFirstAndLast() {
        let rootNode = SinglyLinkedListNode(value: "fart")
        let node2 = rootNode.insert(value: "toot")
        rootNode.insert(value: "beef")
        let subject = SinglyLinkedList(rootNode: rootNode)
        XCTAssert(subject.firstValue == "fart")
        XCTAssert(subject.lastValue == "beef")
        let tootNode = subject.firstNode { (node) -> Bool in
            node.value == "toot"
        }
        XCTAssertNotNil(tootNode)
        XCTAssert(tootNode == node2)
    }

}
