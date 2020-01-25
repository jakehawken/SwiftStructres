//  Queue.swift
//  SwiftStructures
//  Created by Jake Hawken on 1/24/20.
//  Copyright © 2020 Jake Hawken. All rights reserved.

import Foundation

public class Queue<T> {
    
    private var list: SinglyLinkedList<T>?
    private(set) var count = 0
    
    var isEmpty: Bool {
        return list == nil
    }
    
    /**
    Adds a new element to the queue.
    - Parameter element: The value to be enqueued.
    */
    func enqueue(_ element: T) {
        count += 1
        guard let list = list else {
            self.list = SinglyLinkedList(firstValue: element)
            return
        }
        list.insert(value: element)
    }
    
    /**
    Pops the next element off of the front of the queue. Returns `nil` if the queue is empty. When an element is returned, it is removed from the queue.
    - returns: The first element in the queue, based on a first-in-first-out rule.
    */
    func dequeue() -> T? {
        guard let currentList = list else {
            return nil
        }
        list = list?.newListByIncrementingRoot()
        count -= 1
        return currentList.rootNode.value
    }
    
    /**
    Returns the next element in the queue without dequeueing it.
    - returns: The element at the front of the queue.
    */
    var peek: T? {
        return list?.rootNode.value
    }
    
    /**
    Dequeues all elements from the queue in order and returns them as an array. As this is iterative, this method is exectuted in O(n) time.
    - returns: An array of the elements, in dequeueing order.
    */
    func dequeueAll() -> [T] {
        let output = list?.asArray() ?? []
        list = nil
        count = 0
        return output
    }
    
}
