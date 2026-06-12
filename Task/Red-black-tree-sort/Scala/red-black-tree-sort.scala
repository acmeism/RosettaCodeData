// ------------------------------------------------------------
// Colour is encoded as a sealed trait so pattern-matching works
// ------------------------------------------------------------
sealed trait Colour
case object Red   extends Colour
case object Black extends Colour

// ------------------------------------------------------------
// A node in the Red-Black tree
// ------------------------------------------------------------
case class Node(var value: Int,
                var colour: Colour = Red,
                var parent: Option[Node] = None,
                var left:   Option[Node] = None,
                var right:  Option[Node] = None)

// ------------------------------------------------------------
// The tree itself
// ------------------------------------------------------------
class RBTree {

  private var root: Option[Node] = None

  /* ----------  Public API  ---------- */

  def insert(key: Int): Unit = {
    val node = Node(key)
    var y: Option[Node] = None
    var x = root

    while (x.isDefined) {
      y = x
      if (key < x.get.value) x = x.get.left
      else                   x = x.get.right
    }

    node.parent = y
    y match {
      case None    => root = Some(node)
      case Some(p) =>
        if (key < p.value) p.left  = Some(node)
        else               p.right = Some(node)
    }

    if (node.parent.isEmpty) {
      node.colour = Black
      return
    }
    if (node.parent.get.parent.isEmpty) return

    fixInsert(node)
  }

  def delete(key: Int): Unit = {
    val z = findNode(root, key)
    if (z.isEmpty) {
      println(s"Value $key not present in tree")
      return
    }

    var y        = z.get
    val yOrigCol = y.colour
    val x: Option[Node] =
      if (y.left.isEmpty) {
        val tmp = y.right
        transplant(y, y.right)
        tmp
      } else if (y.right.isEmpty) {
        val tmp = y.left
        transplant(y, y.left)
        tmp
      } else {
        y = minimum(y.right.get)
        val yOrigCol2 = y.colour
        val x2        = y.right
        if (y.parent.contains(z.get)) x2.foreach(_.parent = Some(y))
        else {
          transplant(y, y.right)
          y.right = z.get.right
          y.right.foreach(_.parent = Some(y))
        }
        transplant(z.get, Some(y))
        y.left = z.get.left
        y.left.foreach(_.parent = Some(y))
        y.colour = z.get.colour
        x2
      }

    if (yOrigCol == Black) x.foreach(fixDelete)
  }

  def printTree(): Unit = {
    def go(node: Option[Node], indent: String, last: Boolean): Unit = node match {
      case Some(n) =>
        print(indent)
        print(if (last) "R----" else "L----")
        val colour = if (n.colour == Red) "RED" else "BLACK"
        println(s"${n.value}($colour)")
        val newIndent = indent + (if (last) "     " else "|    ")
        go(n.left,  newIndent, last = false)
        go(n.right, newIndent, last = true)
      case None => // nothing to print
    }
    go(root, "", last = true)
  }

  /* ----------  Internal helpers  ---------- */

  private def findNode(start: Option[Node], key: Int): Option[Node] = start match {
    case None                          => None
    case Some(n) if n.value == key    => Some(n)
    case Some(n) if key <= n.value    => findNode(n.left, key)
    case Some(n)                      => findNode(n.right, key)
  }

  private def minimum(node: Node): Node = {
    var cur = node
    while (cur.left.isDefined) cur = cur.left.get
    cur
  }

  private def transplant(u: Node, v: Option[Node]): Unit = {
    u.parent match {
      case None        => root = v
      case Some(p)     =>
        if (p.left.contains(u))  p.left  = v
        else                     p.right = v
    }
    v.foreach(_.parent = u.parent)
  }

  /* ----------  Rotations  ---------- */

  private def leftRotate(x: Node): Unit = {
    val y = x.right.get
    x.right = y.left
    y.left.foreach(_.parent = Some(x))

    y.parent = x.parent
    x.parent match {
      case None        => root = Some(y)
      case Some(p)     =>
        if (p.left.contains(x))  p.left  = Some(y)
        else                     p.right = Some(y)
    }
    y.left   = Some(x)
    x.parent = Some(y)
  }

  private def rightRotate(x: Node): Unit = {
    val y = x.left.get
    x.left = y.right
    y.right.foreach(_.parent = Some(x))

    y.parent = x.parent
    x.parent match {
      case None        => root = Some(y)
      case Some(p)     =>
        if (p.right.contains(x)) p.right = Some(y)
        else                     p.left  = Some(y)
    }
    y.right  = Some(x)
    x.parent = Some(y)
  }

  /* ----------  Balance after insert  ---------- */

  private def fixInsert(k: Node): Unit = {
    var curr = k
    while (curr.parent.exists(_.colour == Red)) {
      val parent      = curr.parent.get
      val grandParent = parent.parent.get

      if (parent eq grandParent.left.orNull) {
        val uncle = grandParent.right
        uncle match {
          case Some(u) if u.colour == Red =>
            parent.colour   = Black
            u.colour        = Black
            grandParent.colour = Red
            curr = grandParent
          case _ =>
            if (curr eq parent.right.orNull) {
              curr = parent
              leftRotate(curr)
            }
            parent.colour        = Black
            grandParent.colour   = Red
            rightRotate(grandParent)
        }
      } else {
        val uncle = grandParent.left
        uncle match {
          case Some(u) if u.colour == Red =>
            parent.colour   = Black
            u.colour        = Black
            grandParent.colour = Red
            curr = grandParent
          case _ =>
            if (curr eq parent.left.orNull) {
              curr = parent
              rightRotate(curr)
            }
            parent.colour        = Black
            grandParent.colour   = Red
            leftRotate(grandParent)
        }
      }
    }
    root.foreach(_.colour = Black)
  }

  /* ----------  Balance after delete  ---------- */

  private def fixDelete(x: Node): Unit = {
    var curr: Option[Node] = Some(x)
    while (curr.exists(n => n ne root.orNull) && curr.exists(_.colour == Black)) {
      curr.foreach { xNode =>
        if (xNode eq xNode.parent.get.left.orNull) {
          var s = xNode.parent.get.right.get
          if (s.colour == Red) {
            s.colour = Black
            xNode.parent.get.colour = Red
            leftRotate(xNode.parent.get)
            s = xNode.parent.get.right.get
          }
          if (s.left.forall(_.colour == Black) && s.right.forall(_.colour == Black)) {
            s.colour = Red
            curr = xNode.parent
          } else {
            if (s.right.forall(_.colour == Black)) {
              s.left.foreach(_.colour = Black)
              s.colour = Red
              rightRotate(s)
              s = xNode.parent.get.right.get
            }
            s.colour = xNode.parent.get.colour
            xNode.parent.get.colour = Black
            s.right.foreach(_.colour = Black)
            leftRotate(xNode.parent.get)
            curr = root
          }
        } else {
          var s = xNode.parent.get.left.get
          if (s.colour == Red) {
            s.colour = Black
            xNode.parent.get.colour = Red
            rightRotate(xNode.parent.get)
            s = xNode.parent.get.left.get
          }
          if (s.right.forall(_.colour == Black) && s.left.forall(_.colour == Black)) {
            s.colour = Red
            curr = xNode.parent
          } else {
            if (s.left.forall(_.colour == Black)) {
              s.right.foreach(_.colour = Black)
              s.colour = Red
              leftRotate(s)
              s = xNode.parent.get.left.get
            }
            s.colour = xNode.parent.get.colour
            xNode.parent.get.colour = Black
            s.left.foreach(_.colour = Black)
            rightRotate(xNode.parent.get)
            curr = root
          }
        }
      }
    }
    curr.foreach(_.colour = Black)
  }
}

/* ------------------------------------------------------------
 * Demo / sanity check
 * ------------------------------------------------------------ */
object RBTreeDemo extends App {
  val tree = new RBTree

  println("State of the tree after inserting the 30 keys:")
  (1 until 30).foreach(tree.insert)
  tree.printTree()

  println("\nState of the tree after deleting the 15 keys:")
  (1 until 15).foreach(tree.delete)
  tree.printTree()
}
