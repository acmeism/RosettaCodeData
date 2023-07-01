import "/seq" for Stack

var s = Stack.new()
s.push(1)
s.push(2)
System.print("Stack contains %(s.toList)")
System.print("Number of elements in stack = %(s.count)")
var item = s.pop()
System.print("'%(item)' popped from the stack")
System.print("Last element is now %(s.peek())")
s.clear()
System.print("Stack cleared")
System.print("Is stack now empty? %((s.isEmpty) ? "yes" : "no")")
