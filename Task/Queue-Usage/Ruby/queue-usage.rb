q = Queue.new
q.push "Hello"  # .enq is an alias
q.push "world"
p q.pop         # .deq is an alias
p q.empty?      # => false
