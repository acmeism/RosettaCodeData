import collection.mutable.{ Stack => Stak }

class Stack[T] extends Stak[T] {
  override def pop: T = {
    if (this.length == 0) error("Can't Pop from an empty Stack.")
    else super.pop
  }
  def peek: T = this.head
}
