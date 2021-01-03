# Swift Data Strucutres

The Swift standard library comes with a handful of data structures, including arrays, dictionaries, and sets. For 99% of use cases, these are all you need. However, for specialized cases, other structres are better optimized. This repository (which will eventually be available in one or a combination of Swift Package Manager, Cocoapods, and Carthage), seeks to collect/implement as many of those as possible. Feel free to submit pull requests and contribute!

## The Current List

#### Have:
- Singly-linked list
- Doubly-linked list
- Queue

#### Need:
- Stack
- Heap
- Graph
- Binary search tree

Want to create one of the needed structures? Want to submit one that's not on the list? Want to make a correction or optimization to something that's already here? Feel free to submit a PR!

### Submissions

For submissions of new implementations, please include in your PR:

- Unit tests for your data structure using regular, vanilla XCTest
- Documentation comments, so users can get option+click functionality (For help, read this: <https://nshipster.com/swift-documentation>)
- Debug functionality for your data structure (i.e. at least conform to `CustomStringConvertible` to support `print(_:)` and string interpolation functionality.)
- An update this readme file if adding a new data structure.
- 1 data structure per PR, please

## License

SwiftStructures is available under the MIT license. Feel free to use this code however you would like.
