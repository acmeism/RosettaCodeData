pub type Tree(a) {
  Empty
  Leaf(a)
  Node(Tree(a), Tree(a))
}

pub fn main() -> Nil {
  let t1 = Node(Leaf(1), Node(Leaf(2), Leaf(3)))
  Nil
}
