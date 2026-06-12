package main

import "fmt"

type Node struct {
	Value any
	Next  *Node
}

type LinkedList struct {
	Head *Node
	Tail *Node
}

func (self *LinkedList) Append(value any) {
	node := Node{Value: value}

	if self.Head == nil {
		self.Head = &node
		self.Tail = &node
		return
	}

	self.Tail.Next = &node
	self.Tail = &node
}

func (self *LinkedList) Reverse() {
	head := self.Tail
	head.Next = self.Head
	tmp := self.Head.Next

	for tmp != self.Tail {
		old := tmp.Next
		tmp.Next = head.Next
		head.Next = tmp
		tmp = old
	}

	self.Tail = self.Head
	self.Tail.Next = nil
	self.Head = head
}

func (self *LinkedList) PrintValues() {
	tmp := self.Head

	for tmp != nil {
		fmt.Printf("%v ", tmp.Value)
		tmp = tmp.Next
	}

	fmt.Println()
}

func main() {
	ll := LinkedList{}

	for i := range 10 {
		ll.Append(i)
	}

	ll.PrintValues()
	ll.Reverse()
	ll.PrintValues()
	ll.Reverse()
	ll.PrintValues()
	ll.Reverse()
	ll.PrintValues()
}
