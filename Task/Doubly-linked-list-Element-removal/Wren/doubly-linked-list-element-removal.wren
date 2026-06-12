import "./llist" for DLinkedList

var dll = DLinkedList.new(["dog", "cat", "bear"])
System.print("Before removals: %(dll)")
dll.remove("cat") // remove by element
System.print("After removal 1: %(dll)")
dll.removeAt(0)   // remove by index
System.print("After removal 2: %(dll)")
