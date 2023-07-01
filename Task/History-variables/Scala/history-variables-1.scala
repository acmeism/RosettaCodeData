class HVar[A](initialValue: A) extends Proxy {
  override def self = !this
  override def toString = "HVar(" + !this + ")"

  def history = _history

  private var _history = List(initialValue)
  def unary_! = _history.head
  def :=(newValue: A): Unit = {
    _history = newValue :: _history
  }
  def modify(f: A => A): Unit = {
    _history = f(!this) :: _history
  }
  def undo: A = {
    val v = !this
    _history = _history.tail
    v
  }
}
