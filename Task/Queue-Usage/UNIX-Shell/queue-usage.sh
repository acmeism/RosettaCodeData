# any valid variable name can be used as a queue without initialization

queue_empty foo && echo foo is empty || echo foo is not empty

queue_push foo bar
queue_push foo baz
queue_push foo "element with spaces"

queue_empty foo && echo foo is empty || echo foo is not empty

print "peek: $(queue_peek foo)"; queue_pop foo
print "peek: $(queue_peek foo)"; queue_pop foo
print "peek: $(queue_peek foo)"; queue_pop foo
print "peek: $(queue_peek foo)"; queue_pop foo
