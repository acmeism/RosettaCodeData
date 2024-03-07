import "./queue" for Queue

var q = Queue.new()
var item = q.pop()
if (item == null) {
    System.print("ERROR: attempted to pop from an empty queue")
} else {
    System.print("'%(item)' was popped")
}
