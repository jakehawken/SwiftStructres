//  SinglyLinkedListTests.swift
//  SwiftStructuresTests
//  Created by Jake Hawken on 1/22/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import XCTest
import SwiftStructures

class SinglyLinkedListTests: XCTestCase {

    override func setUp() {}
    override func tearDown() {}

    func testInitializeWithValue() {
        let subject = SinglyLinkedList(firstValue: 3)
        XCTAssert(subject.count == 1)
        XCTAssert(subject.rootValue == 3)
        XCTAssert(subject.tailValue == 3)
        XCTAssert(subject.description == "SLinkedList{(3)}")
        var array = [Int]()
        subject.forEach { (item) in
            array.append(item)
        }
        XCTAssert(array.count == 1)
        XCTAssert(array.first == 3)
    }
    
    func testConstructFromArray() {
        let originalArray = [1,2,3,4,5,6,7,8]
        let subject = SinglyLinkedList.fromArray(originalArray)
        XCTAssertNotNil(subject)
        XCTAssert(subject?.count == originalArray.count)
        XCTAssert(subject?.rootValue == 1)
        XCTAssert(subject?.tailValue == 8)
        var generatedArray = [Int]()
        subject?.forEach { (item) in
            generatedArray.append(item)
        }
        XCTAssert(generatedArray == originalArray)
        XCTAssert(subject?.description == "SLinkedList{(1)->(2)->(3)->(4)->(5)->(6)->(7)->(8)}")
    }
    
    func testGenerateArray() {
        let subject = SinglyLinkedList(firstValue: 9)
        subject.append(8)
        subject.append(7)
        subject.append(6)
        let generatedArray = subject.asArray()
        XCTAssert(generatedArray == [9,8,7,6])
    }

    func testForEach() {
        let subject = SinglyLinkedList(firstValue: 1)
        subject.append(2)
        subject.append(3)
        subject.append(4)
        subject.append(5)
        var array = [Int]()
        subject.forEach { (item) in
            array.append(item)
        }
        XCTAssert(array == [1,2,3,4,5])
    }
    
    func testTrimToRoot() {
        let subject = SinglyLinkedList(firstValue: 1)
        subject.append(2)
        subject.append(3)
        subject.append(4)
        subject.append(5)
        subject.trimToRoot()
        XCTAssert(subject.count == 1)
    }
    
    func testFirstAndLast() {
        let subject = SinglyLinkedList(firstValue: "fart")
        subject.append("toot")
        subject.append("beef")
        XCTAssert(subject.rootValue == "fart")
        XCTAssert(subject.tailValue == "beef")
        let tootVal = subject.firstValue { $0 == "toot" }
        XCTAssertNotNil(tootVal)
        XCTAssert(subject.asArray() == ["fart","toot","beef"])
        subject.append("fluff")
        XCTAssert(subject.rootValue == "fart")
        XCTAssert(subject.tailValue == "fluff")
        let beefVal = subject.firstValue { $0 == "beef" }
        XCTAssertNotNil(beefVal)
        let rando = subject.firstValue { $0 == "OCTOPUS" }
        XCTAssertNil(rando)
    }
    
    func testContains() {
        let numArray = [5,7,29,-48,256]
        let intSubject = SinglyLinkedList.fromArray(numArray)!
        XCTAssertTrue(intSubject.contains(5))
        XCTAssertTrue(intSubject.contains(7))
        XCTAssertTrue(intSubject.contains(29))
        XCTAssertTrue(intSubject.contains(-48))
        XCTAssertTrue(intSubject.contains(256))
        XCTAssertFalse(intSubject.contains(3))
        XCTAssertFalse(intSubject.contains(1000))
        XCTAssertFalse(intSubject.contains(0))
        XCTAssertFalse(intSubject.contains(-349))
        
        let obj1 = NSObject()
        let obj2 = NSObject()
        let obj3 = NSObject()
        let objSubject = SinglyLinkedList.fromArray([obj1, obj2, obj3])!
        XCTAssertTrue(objSubject.containsObject(obj3))
        XCTAssertTrue(objSubject.containsObject(obj2))
        XCTAssertTrue(objSubject.containsObject(obj1))
        let newObj = NSObject()
        XCTAssertFalse(objSubject.containsObject(newObj))
    }

}
