case class IntNode(value: Int, left: Option[IntNode] = None, right: Option[IntNode] = None) {

  def preorder(f: IntNode => Unit) {
    f(this)
    left.map(_.preorder(f)) // Same as: if(left.isDefined) left.get.preorder(f)
    right.map(_.preorder(f))
  }

  def postorder(f: IntNode => Unit) {
    left.map(_.postorder(f))
    right.map(_.postorder(f))
    f(this)
  }

  def inorder(f: IntNode => Unit) {
    left.map(_.inorder(f))
    f(this)
    right.map(_.inorder(f))
  }

  def levelorder(f: IntNode => Unit) {

    def loVisit(ls: List[IntNode]): Unit = ls match {
      case Nil => None
      case node :: rest => f(node); loVisit(rest ++ node.left ++ node.right)
    }

    loVisit(List(this))
  }
}

object TreeTraversal extends App {
  implicit def intNode2SomeIntNode(n: IntNode) = Some[IntNode](n)

  val tree = IntNode(1,
    IntNode(2,
      IntNode(4,
        IntNode(7)),
      IntNode(5)),
    IntNode(3,
      IntNode(6,
        IntNode(8),
        IntNode(9))))

  List(
    "  preorder: " -> tree.preorder _, // `_` denotes the function value of type `IntNode => Unit` (returning nothing)
    "   inorder: " -> tree.inorder _,
    " postorder: " -> tree.postorder _,
    "levelorder: " -> tree.levelorder _) foreach {
      case (name, func) =>
        val s = new StringBuilder(name)
        func(n => s ++= n.value.toString + " ")
        println(s)
    }
}
