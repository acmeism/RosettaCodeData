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
