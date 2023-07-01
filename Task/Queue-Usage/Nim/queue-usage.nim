import deques

var queue = initDeque[int]()

queue.addLast(26)
queue.addLast(99)
queue.addLast(2)
echo "Queue size: ", queue.len()
echo "Popping: ", queue.popFirst()
echo "Popping: ", queue.popFirst()
echo "Popping: ", queue.popFirst()
echo "Popping: ", queue.popFirst()
