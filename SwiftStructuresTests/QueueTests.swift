//  QueueTests.swift
//  SwiftStructuresTests
//  Created by Jake Hawken on 1/24/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import XCTest
@testable import SwiftStructures

class QueueTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testEnqueueAndDequeue() {
        let subject = Queue<Int>()
        XCTAssert(subject.dequeue() == nil)
        XCTAssert(subject.isEmpty)
        subject.enqueue(1)
        XCTAssertFalse(subject.isEmpty)
        subject.enqueue(2)
        XCTAssertFalse(subject.isEmpty)
        subject.enqueue(3)
        XCTAssertFalse(subject.isEmpty)
        subject.enqueue(4)
        XCTAssertFalse(subject.isEmpty)
        subject.enqueue(5)
        XCTAssertFalse(subject.isEmpty)
        XCTAssert(subject.dequeue() == 1)
        XCTAssertFalse(subject.isEmpty)
        XCTAssert(subject.dequeue() == 2)
        XCTAssertFalse(subject.isEmpty)
        XCTAssert(subject.dequeue() == 3)
        XCTAssertFalse(subject.isEmpty)
        XCTAssert(subject.dequeue() == 4)
        XCTAssertFalse(subject.isEmpty)
        XCTAssert(subject.dequeue() == 5)
        XCTAssert(subject.isEmpty)
        XCTAssert(subject.dequeue() == nil)
        XCTAssert(subject.isEmpty)
    }
    
    func testCount() {
        let subject = Queue<Int>()
        XCTAssert(subject.count == 0)
        subject.enqueue(1)
        XCTAssert(subject.count == 1)
        subject.enqueue(2)
        XCTAssert(subject.count == 2)
        subject.enqueue(3)
        XCTAssert(subject.count == 3)
        subject.enqueue(4)
        XCTAssert(subject.count == 4)
        subject.enqueue(5)
        XCTAssert(subject.count == 5)
        _ = subject.dequeue()
        XCTAssert(subject.count == 4)
        _ = subject.dequeue()
        XCTAssert(subject.count == 3)
        _ = subject.dequeue()
        XCTAssert(subject.count == 2)
        _ = subject.dequeue()
        XCTAssert(subject.count == 1)
        _ = subject.dequeue()
        XCTAssert(subject.count == 0)
        XCTAssert(subject.isEmpty)
        subject.enqueue(1)
        XCTAssert(subject.count == 1)
    }
    
    func testPeek() {
        let subject = Queue<Int>()
        subject.enqueue(1)
        subject.enqueue(3)
        subject.enqueue(3)
        XCTAssert(subject.count == 3)
        XCTAssert(subject.peek == 1)
        XCTAssert(subject.count == 3)
    }
    
    func testPopAll() {
        let subject = Queue<Int>()
        subject.enqueue(1)
        subject.enqueue(2)
        subject.enqueue(3)
        XCTAssert(subject.count == 3)
        XCTAssert(subject.dequeueAll() == [1,2,3])
        XCTAssert(subject.count == 0)
        XCTAssert(subject.isEmpty)
    }

}
