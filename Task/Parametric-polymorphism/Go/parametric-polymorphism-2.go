package rosettacode

type Tree(type T) struct {
    val T
    left *Tree(T)
    right *Tree(T)
}

func (t *Tree(T)) ReplaceAll(rep T) {
    t.val = rep
    if t.left != nil  { t.left.ReplaceAll(rep) }
    if t.right != nil { t.right.ReplaceAll(rep) }
}
