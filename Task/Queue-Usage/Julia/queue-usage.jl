using DataStructures

queue = Queue(String)
@show enqueue!(queue, "foo")
@show enqueue!(queue, "bar")
@show dequeue!(queue) # -> foo
@show dequeue!(queue) # -> bar
