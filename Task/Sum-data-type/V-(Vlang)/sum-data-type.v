struct Moon {}

struct Mars {}

struct Venus {}

struct Empty {}

struct Node {
	value f64
	left  Tree
	right Tree
}

// The 'type' keyword is used to declare a sum type.

type World = Mars | Moon | Venus

type Tree = Empty | Node

// Below function is to sum up all node values.

fn sum_up(tree Tree) f64 {
	return match tree {
		Empty { 0 }
		Node { tree.value + sum_up(tree.left) + sum_up(tree.right) }
	}
}

fn main() {
	sum := World(Moon{})
	println(sum.type_name()) // Built-in method 'type_name' returns the name of the currently held type.
	println(sum)  // sum type

//	With sum types you could build recursive structures and write concise powerful code on them.

	left := Node{0.2, Empty{}, Empty{}}
	right := Node{0.3, Empty{}, Node{0.4, Empty{}, Empty{}}}
	tree := Node{0.5, left, right}
	println(sum_up(tree)) // 0.2 + 0.3 + 0.4 + 0.5 = 1.4
}
