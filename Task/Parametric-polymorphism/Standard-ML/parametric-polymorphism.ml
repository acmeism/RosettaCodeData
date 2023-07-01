datatype 'a tree = Empty | Node of 'a * 'a tree * 'a tree

(** val map_tree = fn : ('a -> 'b) -> 'a tree -> 'b tree *)
fun map_tree f Empty = Empty
  | map_tree f (Node (x,l,r)) = Node (f x, map_tree f l, map_tree f r)
