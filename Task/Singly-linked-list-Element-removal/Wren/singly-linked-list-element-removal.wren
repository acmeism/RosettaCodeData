import "./llist" for LinkedList

var ll = LinkedList.new(["dog", "cat", "bear"])
System.print("Before removals: %(ll)")
ll.remove("cat") // remove by element
System.print("After removal 1: %(ll)")
ll.removeAt(0)   // remove by index
System.print("After removal 2: %(ll)")
