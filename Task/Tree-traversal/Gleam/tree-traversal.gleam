import gleam/list

pub type Tree(a) {
  Empty
  Node(a, Tree(a), Tree(a))
}

pub fn preorder(t: Tree(a)) -> List(a) {
  case t {
    Empty -> []
    Node(v, l, r) -> [v, ..list.append(preorder(l), preorder(r))]
  }
}

pub fn inorder(t: Tree(a)) -> List(a) {
  case t {
    Empty -> []
    Node(v, l, r) -> list.append(list.append(inorder(l), [v]), inorder(r))
  }
}

pub fn postorder(t: Tree(a)) -> List(a) {
  case t {
    Empty -> []
    Node(v, l, r) -> list.append(list.append(postorder(l), postorder(r)), [v])
  }
}

pub fn levelorder(t: Tree(a)) -> List(a) {
  levelorder_helper([t])
}

fn levelorder_helper(trees: List(Tree(a))) -> List(a) {
  case trees {
    [] -> []
    [Empty, ..rest] -> levelorder_helper(rest)
    [Node(v, l, r), ..rest] -> [
      v,
      ..levelorder_helper(list.append(rest, [l, r]))
    ]
  }
}

pub fn main() -> Nil {
  let example =
    Node(
      1,
      Node(2, Node(4, Node(7, Empty, Empty), Empty), Node(5, Empty, Empty)),
      Node(3, Node(6, Node(8, Empty, Empty), Node(9, Empty, Empty)), Empty),
    )
  echo preorder(example)
  echo inorder(example)
  echo postorder(example)
  echo levelorder(example)
  Nil
}
