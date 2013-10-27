class Stack[T] {
  private var items = List[T]()

  def isEmpty = items.isEmpty

  def peek = items match {
    case List()       => error("Stack empty")
    case head :: rest => head
  }

  def pop = items match {
    case List()       => error("Stack empty")
    case head :: rest => items = rest; head
  }

  def push(value: T) = items = value +: items
}
