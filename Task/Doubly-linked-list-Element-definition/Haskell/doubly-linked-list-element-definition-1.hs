data DList a = Leaf | Node (DList a) a (DList a)

updateLeft _ Leaf = Leaf
updateLeft Leaf (Node _ v r) = Node Leaf v r
updateLeft new@(Node nl _ _) (Node _ v r) = current
    where current = Node prev v r
          prev = updateLeft nl new

updateRight _ Leaf = Leaf
updateRight Leaf (Node l v _) = Node l v Leaf
updateRight new@(Node _ _ nr) (Node l v _) = current
    where current = Node l v next
          next = updateRight nr new
