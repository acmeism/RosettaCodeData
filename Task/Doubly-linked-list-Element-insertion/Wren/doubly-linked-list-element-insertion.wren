import "/llist" for DLinkedList

var dll = DLinkedList.new(["A", "B"])
dll.insertAfter("A", "C")
System.print(dll)
