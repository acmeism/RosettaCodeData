typealias NodePtr<T> = UnsafeMutablePointer<Node<T>>

class Node<T> {
  var value: T
  fileprivate var prev: NodePtr<T>?
  fileprivate var next: NodePtr<T>?

  init(value: T, prev: NodePtr<T>? = nil, next: NodePtr<T>? = nil) {
    self.value = value
    self.prev = prev
    self.next = next
  }
}

@discardableResult
func insert<T>(_ val: T, after: Node<T>? = nil, list: NodePtr<T>? = nil) -> NodePtr<T> {
  let node = NodePtr<T>.allocate(capacity: 1)

  node.initialize(to: Node(value: val))

  var n = list

  while n != nil {
    if n?.pointee !== after {
      n = n?.pointee.next

      continue
    }

    node.pointee.prev = n
    node.pointee.next = n?.pointee.next
    n?.pointee.next?.pointee.prev = node
    n?.pointee.next = node

    break
  }

  return node
}

// [1]
let list = insert(1)

// [1, 2]
insert(2, after: list.pointee, list: list)

// [1, 3, 2]
insert(3, after: list.pointee, list: list)
