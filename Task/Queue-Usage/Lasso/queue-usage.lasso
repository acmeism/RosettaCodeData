local(queue) = queue
#queue->size
// => 0

#queue->insert('a')
#queue->insert('b')
#queue->insert('c')
#queue->size
// => 3

loop(#queue->size) => {
  stdoutnl(#queue->get)
}
// =>
// a
// b
// c

#queue->size == 0
// => true
