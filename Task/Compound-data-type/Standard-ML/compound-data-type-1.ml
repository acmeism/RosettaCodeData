datatype tree = Empty
              | Leaf of int
              | Node of tree * tree

val t1 = Node (Leaf 1, Node (Leaf 2, Leaf 3))
