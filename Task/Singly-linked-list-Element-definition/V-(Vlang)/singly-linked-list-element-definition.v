struct Node[T] {
    mut:
	data T
	next ?&Node[T]
}

// method override of built-in `str()`
fn (n Node[T]) str() string {
	mut result := n.data.str()
	mut current := n.next
	for current != none {
		result += " -> ${current or {continue}.data.str()}"
		current = current or {continue}.next
	}
	return result
}

fn main() {
	n := Node{1, ?&Node{2, ?&Node{3, none}}}
	println(n.str())
}
