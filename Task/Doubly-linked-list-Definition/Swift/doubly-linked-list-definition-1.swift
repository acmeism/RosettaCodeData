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

struct DoublyLinkedList<T> {
  fileprivate var head: NodePtr<T>?
  fileprivate var tail: NodePtr<T>?

  @discardableResult
  mutating func insert(_ val: T, at: InsertLoc<T> = .last) -> Node<T> {
    let node = NodePtr<T>.allocate(capacity: 1)

    node.initialize(to: Node(value: val))

    if head == nil && tail == nil {
      head = node
      tail = node

      return node.pointee
    }

    switch at {
    case .first:
      node.pointee.next = head
      head?.pointee.prev = node
      head = node
    case .last:
      node.pointee.prev = tail
      tail?.pointee.next = node
      tail = node
    case let .after(insertNode):
      var n = head

      while n != nil {
        if n!.pointee !== insertNode {
          n = n?.pointee.next

          continue
        }

        node.pointee.prev = n
        node.pointee.next = n!.pointee.next
        n!.pointee.next = node

        if n == tail {
          tail = node
        }

        break
      }
    }

    return node.pointee
  }

  @discardableResult
  mutating func remove(_ node: Node<T>) -> T? {
    var n = head

    while n != nil {
      if n!.pointee !== node {
        n = n?.pointee.next

        continue
      }

      if n == head {
        n?.pointee.next?.pointee.prev = nil
        head = n?.pointee.next
      } else if n == tail {
        n?.pointee.prev?.pointee.next = nil
        tail = n?.pointee.prev
      } else {
        n?.pointee.prev?.pointee.next = n?.pointee.next
        n?.pointee.next?.pointee.prev = n?.pointee.prev
      }

      break
    }

    if n == nil {
      return nil
    }

    defer {
      n?.deinitialize(count: 1)
      n?.deallocate()
    }

    return n?.pointee.value
  }

  enum InsertLoc<T> {
    case first
    case last
    case after(Node<T>)
  }
}

extension DoublyLinkedList: CustomStringConvertible {
  var description: String {
    var res = "["
    var node = head

    while node != nil {
      res += "\(node!.pointee.value), "
      node = node?.pointee.next
    }

    return (res.count > 1 ? String(res.dropLast(2)) : res) + "]"
  }
}

var list = DoublyLinkedList<Int>()
var node: Node<Int>!

for i in 0..<10 {
  let insertedNode = list.insert(i)

  if i == 5 {
    node = insertedNode
  }
}

print(list)

list.insert(100, at: .after(node!))

print(list)

list.remove(node!)

print(list)
