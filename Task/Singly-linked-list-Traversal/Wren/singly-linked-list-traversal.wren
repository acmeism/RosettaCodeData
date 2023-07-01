import "/llist" for LinkedList
import "/fmt" for Fmt

//create a new linked list and add the first 50 positive integers to it
var ll = LinkedList.new(1..50)

// traverse the linked list
for (i in ll) {
    Fmt.write("$4d ", i)
    if (i % 10 == 0) System.print()
}
