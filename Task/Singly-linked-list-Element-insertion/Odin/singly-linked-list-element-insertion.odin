package main

Node :: struct {
	data: rune,
	next: ^Node,
}

insert_after :: proc(node, new_node: ^Node) {
  new_node.next = node.next
  node.next = new_node
}

main :: proc() {
  a := new(Node)
  a.data = 'A'

  b := new(Node)
  b.data = 'B'

  c := new(Node)
  c.data = 'C'

  insert_after(a, b) // A -> B
  insert_after(a, c) // A -> C -> B

  assert(a.data == 'A')
  assert(a.next.data == 'C')
  assert(a.next.next.data == 'B')
}
