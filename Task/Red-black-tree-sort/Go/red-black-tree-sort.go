package main

import (
	"fmt"
	//"strings"
)

// Node represents a node in the Red-Black Tree
type Node struct {
	val    int
	parent *Node
	left   *Node
	right  *Node
	color  int // 1 for Red, 0 for Black
}

// RBTree represents a Red-Black Tree
type RBTree struct {
	nullNode *Node
	root     *Node
}

// NewNode creates a new node with the given value
func NewNode(val int) *Node {
	return &Node{
		val:    val,
		parent: nil,
		left:   nil,
		right:  nil,
		color:  1, // Red
	}
}

// NewRBTree creates a new Red-Black Tree
func NewRBTree() *RBTree {
	nullNode := &Node{
		val:   0,
		color: 0, // Black
		left:  nil,
		right: nil,
	}
	return &RBTree{
		nullNode: nullNode,
		root:     nullNode,
	}
}

// InsertNode inserts a new node with the given key
func (t *RBTree) InsertNode(key int) {
	node := NewNode(key)
	node.parent = nil
	node.left = t.nullNode
	node.right = t.nullNode
	node.color = 1 // Red

	var y *Node = nil
	x := t.root

	for x != t.nullNode {
		y = x
		if node.val < x.val {
			x = x.left
		} else {
			x = x.right
		}
	}

	node.parent = y
	if y == nil {
		t.root = node
	} else if node.val < y.val {
		y.left = node
	} else {
		y.right = node
	}

	if node.parent == nil {
		node.color = 0 // Black
		return
	}

	if node.parent.parent == nil {
		return
	}

	t.fixInsert(node)
}

// minimum finds the node with the minimum value in the subtree rooted at node
func (t *RBTree) minimum(node *Node) *Node {
	for node.left != t.nullNode {
		node = node.left
	}
	return node
}

// LR performs a left rotation on the given node
func (t *RBTree) LR(x *Node) {
	y := x.right
	x.right = y.left
	if y.left != t.nullNode {
		y.left.parent = x
	}

	y.parent = x.parent
	if x.parent == nil {
		t.root = y
	} else if x == x.parent.left {
		x.parent.left = y
	} else {
		x.parent.right = y
	}
	y.left = x
	x.parent = y
}

// RR performs a right rotation on the given node
func (t *RBTree) RR(x *Node) {
	y := x.left
	x.left = y.right
	if y.right != t.nullNode {
		y.right.parent = x
	}

	y.parent = x.parent
	if x.parent == nil {
		t.root = y
	} else if x == x.parent.right {
		x.parent.right = y
	} else {
		x.parent.left = y
	}
	y.right = x
	x.parent = y
}

// fixInsert fixes the Red-Black Tree after insertion
func (t *RBTree) fixInsert(k *Node) {
	for k.parent.color == 1 {
		if k.parent == k.parent.parent.right {
			u := k.parent.parent.left
			if u.color == 1 {
				u.color = 0
				k.parent.color = 0
				k.parent.parent.color = 1
				k = k.parent.parent
			} else {
				if k == k.parent.left {
					k = k.parent
					t.RR(k)
				}
				k.parent.color = 0
				k.parent.parent.color = 1
				t.LR(k.parent.parent)
			}
		} else {
			u := k.parent.parent.right
			if u.color == 1 {
				u.color = 0
				k.parent.color = 0
				k.parent.parent.color = 1
				k = k.parent.parent
			} else {
				if k == k.parent.right {
					k = k.parent
					t.LR(k)
				}
				k.parent.color = 0
				k.parent.parent.color = 1
				t.RR(k.parent.parent)
			}
		}
		if k == t.root {
			break
		}
	}
	t.root.color = 0
}

// fixDelete fixes the Red-Black Tree after deletion
func (t *RBTree) fixDelete(x *Node) {
	for x != t.root && x.color == 0 {
		if x == x.parent.left {
			s := x.parent.right
			if s.color == 1 {
				s.color = 0
				x.parent.color = 1
				t.LR(x.parent)
				s = x.parent.right
			}

			if s.left.color == 0 && s.right.color == 0 {
				s.color = 1
				x = x.parent
			} else {
				if s.right.color == 0 {
					s.left.color = 0
					s.color = 1
					t.RR(s)
					s = x.parent.right
				}

				s.color = x.parent.color
				x.parent.color = 0
				s.right.color = 0
				t.LR(x.parent)
				x = t.root
			}
		} else {
			s := x.parent.left
			if s.color == 1 {
				s.color = 0
				x.parent.color = 1
				t.RR(x.parent)
				s = x.parent.left
			}

			if s.right.color == 0 && s.left.color == 0 {
				s.color = 1
				x = x.parent
			} else {
				if s.left.color == 0 {
					s.right.color = 0
					s.color = 1
					t.LR(s)
					s = x.parent.left
				}

				s.color = x.parent.color
				x.parent.color = 0
				s.left.color = 0
				t.RR(x.parent)
				x = t.root
			}
		}
	}
	x.color = 0
}

// rbTransplant replaces one subtree with another
func (t *RBTree) rbTransplant(u, v *Node) {
	if u.parent == nil {
		t.root = v
	} else if u == u.parent.left {
		u.parent.left = v
	} else {
		u.parent.right = v
	}
	v.parent = u.parent
}

// deleteNodeHelper is a helper function for DeleteNode
func (t *RBTree) deleteNodeHelper(node *Node, key int) {
	z := t.nullNode
	temp := node
	for temp != t.nullNode {
		if temp.val == key {
			z = temp
		}

		if temp.val <= key {
			temp = temp.right
		} else {
			temp = temp.left
		}
	}

	if z == t.nullNode {
		fmt.Println("Value not present in Tree !!")
		return
	}

	y := z
	yOriginalColor := y.color
	var x *Node
	if z.left == t.nullNode {
		x = z.right
		t.rbTransplant(z, z.right)
	} else if z.right == t.nullNode {
		x = z.left
		t.rbTransplant(z, z.left)
	} else {
		y = t.minimum(z.right)
		yOriginalColor = y.color
		x = y.right
		if y.parent == z {
			x.parent = y
		} else {
			t.rbTransplant(y, y.right)
			y.right = z.right
			y.right.parent = y
		}

		t.rbTransplant(z, y)
		y.left = z.left
		y.left.parent = y
		y.color = z.color
	}
	if yOriginalColor == 0 {
		t.fixDelete(x)
	}
}

// DeleteNode deletes a node with the given value
func (t *RBTree) DeleteNode(val int) {
	t.deleteNodeHelper(t.root, val)
}

// printCall recursively prints the tree
func (t *RBTree) printCall(node *Node, indent string, last bool) {
	if node != t.nullNode {
		fmt.Print(indent)
		if last {
			fmt.Print("R----")
			indent += "     "
		} else {
			fmt.Print("L----")
			indent += "|    "
		}

		var sColor string
		if node.color == 1 {
			sColor = "RED"
		} else {
			sColor = "BLACK"
		}
		fmt.Printf("%d(%s)\n", node.val, sColor)
		t.printCall(node.left, indent, false)
		t.printCall(node.right, indent, true)
	}
}

// PrintTree prints the entire tree
func (t *RBTree) PrintTree() {
	t.printCall(t.root, "", true)
}

func main() {
	bst := NewRBTree()

	fmt.Println("State of the tree after inserting the 30 keys:")
	for x := 1; x < 30; x++ {
		bst.InsertNode(x)
	}
	bst.PrintTree()

	fmt.Println("\nState of the tree after deleting the 15 keys:")
	for x := 1; x < 15; x++ {
		bst.DeleteNode(x)
	}
	bst.PrintTree()
}
