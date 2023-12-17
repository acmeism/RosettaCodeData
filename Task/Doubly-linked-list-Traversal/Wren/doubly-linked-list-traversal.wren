import "./llist" for DLinkedList
import "./fmt" for Fmt

// create a new doubly-linked list and add the first 50 positive integers to it
var dll = DLinkedList.new(1..50)

// traverse the doubly-linked list from head to tail
for (i in dll) {
    Fmt.write("$4d ", i)
    if (i % 10 == 0) System.print()
}
System.print()
// traverse the doubly-linked list from tail to head
for (i in dll.reversed) {
    Fmt.write("$4d ", i)
    if (i % 10 == 1) System.print()
}
