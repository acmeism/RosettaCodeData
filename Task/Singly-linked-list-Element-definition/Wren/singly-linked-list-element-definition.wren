import "/llist" for Node

var n1 = Node.new(1)
var n2 = Node.new(2)
n1.next = n2
System.print(["node 1", "data = %(n1.data)", "next = %(n1.next)"])
System.print(["node 2", "data = %(n2.data)", "next = %(n2.next)"])
