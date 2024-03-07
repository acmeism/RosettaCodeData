import "./queue" for Queue

var q = Queue.new()
q.push(1)
q.push(2)
System.print("Queue contains %(q)")
System.print("Number of elements in queue = %(q.count)")
var item = q.pop()
System.print("'%(item)' popped from the queue")
System.print("First element is now %(q.peek())")
q.clear()
System.print("Queue cleared")
System.print("Is queue now empty? %((q.isEmpty) ? "yes" : "no")")
