class Node {
  var data: Int
  var next = this

  def this(n: Int, link: Node) {
    this()
    if (next != null){
      data = n
      next = link
    }
  }
