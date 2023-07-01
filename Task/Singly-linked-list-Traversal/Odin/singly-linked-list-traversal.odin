package main

import "core:fmt"

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

  for n := a; n != nil; n = n.next {
	  fmt.print(n.data)
  } // prints: ACB
}
