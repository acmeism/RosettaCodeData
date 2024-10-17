type tree = Empty
          | Leaf of int
          | Node of tree * tree

let t1 = Node (Leaf 1, Node (Leaf 2, Leaf 3))
