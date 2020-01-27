//  DoublyLinkedListTests.swift
//  SwiftStructuresTests
//  Created by Jake Hawken on 1/25/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import XCTest
import SwiftStructures

class DoublyLinkedListTests: XCTestCase {

    override func setUp() {}
    override func tearDown() {}

    func testInitWithFirstValue() {
        let subject = DoublyLinkedList(firstValue: 17)
        XCTAssert(subject.count() == 1)
        XCTAssert(subject.rootValue == 17)
        XCTAssert(subject.tailValue == 17)
    }
    
    func testConstructFromArray() {
        let numberArray = [5,7,2,29,-48,256]
        let subject = DoublyLinkedList.fromArray(numberArray)
        XCTAssert(subject?.rootValue == 5)
        XCTAssert(subject?.tailValue == 256)
        XCTAssert(subject?.count() == numberArray.count)
        XCTAssert(subject?.rootToTailArray() == numberArray)
    }
    
    func testAppendAndPrepend() {
        let subject = DoublyLinkedList(firstValue: 17)
        
        subject.append(4)
        XCTAssert(subject.rootValue == 17)
        XCTAssert(subject.tailValue == 4)
        XCTAssert(subject.rootToTailArray() == [17,4])
        XCTAssert(subject.tailToRootArray() == [4,17])
        
        subject.append(257)
        XCTAssert(subject.rootValue == 17)
        XCTAssert(subject.tailValue == 257)
        XCTAssert(subject.rootToTailArray() == [17,4,257])
        XCTAssert(subject.tailToRootArray() == [257,4,17])
        
        subject.prepend(36)
        XCTAssert(subject.rootValue == 36)
        XCTAssert(subject.tailValue == 257)
        XCTAssert(subject.rootToTailArray() == [36,17,4,257])
        XCTAssert(subject.tailToRootArray() == [257,4,17,36])
        
        subject.prepend(1000)
        XCTAssert(subject.rootValue == 1000)
        XCTAssert(subject.tailValue == 257)
        XCTAssert(subject.rootToTailArray() == [1000,36,17,4,257])
        XCTAssert(subject.tailToRootArray() == [257,4,17,36,1000])
    }
    
    func testMap() {
        let numArray = [5,7,2]
        let subject = DoublyLinkedList.fromArray(numArray)!
        var mapped = subject.mapRootToTail(mapBlock: { "\($0)" })
        XCTAssert(mapped == ["5","7","2"])
        mapped = subject.mapTailToRoot(mapBlock: { "\($0)" })
        XCTAssert(mapped == ["2","7","5"])
    }
    
    func testFilter() {
        let numArray = [5,7,2,29,-48,256]
        let subject = DoublyLinkedList.fromArray(numArray)!
        var filtered = subject.filterRootToTail(shouldInclude: { $0 < 7 })
        XCTAssert(filtered == [5,2,-48])
        filtered = subject.filterTailToRoot(shouldInclude: { $0 < 7 })
        XCTAssert(filtered == [-48,2,5])
    }
    
    func testContains() {
        let numArray = [5,7,29,-48,256]
        let intSubject = DoublyLinkedList.fromArray(numArray)!
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
        let objSubject = DoublyLinkedList.fromArray([obj1, obj2, obj3])!
        XCTAssertTrue(objSubject.containsObject(obj3))
        XCTAssertTrue(objSubject.containsObject(obj2))
        XCTAssertTrue(objSubject.containsObject(obj1))
        let newObj = NSObject()
        XCTAssertFalse(objSubject.containsObject(newObj))
    }

}
