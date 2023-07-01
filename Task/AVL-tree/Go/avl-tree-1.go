package avl

// AVL tree adapted from Julienne Walker's presentation at
// http://eternallyconfuzzled.com/tuts/datastructures/jsw_tut_avl.aspx.
// This port uses similar indentifier names.

// The Key interface must be supported by data stored in the AVL tree.
type Key interface {
    Less(Key) bool
    Eq(Key) bool
}

// Node is a node in an AVL tree.
type Node struct {
    Data    Key      // anything comparable with Less and Eq.
    Balance int      // balance factor
    Link    [2]*Node // children, indexed by "direction", 0 or 1.
}

// A little readability function for returning the opposite of a direction,
// where a direction is 0 or 1.  Go inlines this.
// Where JW writes !dir, this code has opp(dir).
func opp(dir int) int {
    return 1 - dir
}

// single rotation
func single(root *Node, dir int) *Node {
    save := root.Link[opp(dir)]
    root.Link[opp(dir)] = save.Link[dir]
    save.Link[dir] = root
    return save
}

// double rotation
func double(root *Node, dir int) *Node {
    save := root.Link[opp(dir)].Link[dir]

    root.Link[opp(dir)].Link[dir] = save.Link[opp(dir)]
    save.Link[opp(dir)] = root.Link[opp(dir)]
    root.Link[opp(dir)] = save

    save = root.Link[opp(dir)]
    root.Link[opp(dir)] = save.Link[dir]
    save.Link[dir] = root
    return save
}

// adjust valance factors after double rotation
func adjustBalance(root *Node, dir, bal int) {
    n := root.Link[dir]
    nn := n.Link[opp(dir)]
    switch nn.Balance {
    case 0:
        root.Balance = 0
        n.Balance = 0
    case bal:
        root.Balance = -bal
        n.Balance = 0
    default:
        root.Balance = 0
        n.Balance = bal
    }
    nn.Balance = 0
}

func insertBalance(root *Node, dir int) *Node {
    n := root.Link[dir]
    bal := 2*dir - 1
    if n.Balance == bal {
        root.Balance = 0
        n.Balance = 0
        return single(root, opp(dir))
    }
    adjustBalance(root, dir, bal)
    return double(root, opp(dir))
}

func insertR(root *Node, data Key) (*Node, bool) {
    if root == nil {
        return &Node{Data: data}, false
    }
    dir := 0
    if root.Data.Less(data) {
        dir = 1
    }
    var done bool
    root.Link[dir], done = insertR(root.Link[dir], data)
    if done {
        return root, true
    }
    root.Balance += 2*dir - 1
    switch root.Balance {
    case 0:
        return root, true
    case 1, -1:
        return root, false
    }
    return insertBalance(root, dir), true
}

// Insert a node into the AVL tree.
// Data is inserted even if other data with the same key already exists.
func Insert(tree **Node, data Key) {
    *tree, _ = insertR(*tree, data)
}

func removeBalance(root *Node, dir int) (*Node, bool) {
    n := root.Link[opp(dir)]
    bal := 2*dir - 1
    switch n.Balance {
    case -bal:
        root.Balance = 0
        n.Balance = 0
        return single(root, dir), false
    case bal:
        adjustBalance(root, opp(dir), -bal)
        return double(root, dir), false
    }
    root.Balance = -bal
    n.Balance = bal
    return single(root, dir), true
}

func removeR(root *Node, data Key) (*Node, bool) {
    if root == nil {
        return nil, false
    }
    if root.Data.Eq(data) {
        switch {
        case root.Link[0] == nil:
            return root.Link[1], false
        case root.Link[1] == nil:
            return root.Link[0], false
        }
        heir := root.Link[0]
        for heir.Link[1] != nil {
            heir = heir.Link[1]
        }
        root.Data = heir.Data
        data = heir.Data
    }
    dir := 0
    if root.Data.Less(data) {
        dir = 1
    }
    var done bool
    root.Link[dir], done = removeR(root.Link[dir], data)
    if done {
        return root, true
    }
    root.Balance += 1 - 2*dir
    switch root.Balance {
    case 1, -1:
        return root, true
    case 0:
        return root, false
    }
    return removeBalance(root, dir)
}

// Remove a single item from an AVL tree.
// If key does not exist, function has no effect.
func Remove(tree **Node, data Key) {
    *tree, _ = removeR(*tree, data)
}
