import "./llist" for DLinkedList

var dll = DLinkedList.new()
for (i in 1..3) dll.add(i)
System.print(dll)
for (i in 1..3) dll.remove(i)
System.print(dll)
