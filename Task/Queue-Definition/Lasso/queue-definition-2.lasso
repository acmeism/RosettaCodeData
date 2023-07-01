local(q) = myqueue('a')
#q->isEmpty
// => false

#q->push('b')
#q->pop
// => a
#q->pop
// => b

#q->isEmpty
// => true
#q->pop
// => void
