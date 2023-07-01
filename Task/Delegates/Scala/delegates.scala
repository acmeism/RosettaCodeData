trait Thingable {
  def thing: String
}

class Delegator {
  var delegate: Thingable = _

  def operation: String = if (delegate == null) "default implementation"
  else delegate.thing
}

class Delegate extends Thingable {
  override def thing = "delegate implementation"
}

// Example usage
// Memory management ignored for simplification
object DelegateExample extends App {

  val a = new Delegator
  assert(a.operation == "default implementation")
  // With a delegate:
  val d = new Delegate
  a.delegate = d
  assert(a.operation == "delegate implementation")
  // Same as the above, but with an anonymous class:
  a.delegate = new Thingable() {
    override def thing = "anonymous delegate implementation"
  }
  assert(a.operation == "anonymous delegate implementation")

}
