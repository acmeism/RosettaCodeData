f = FIFO.new
f.empty?                           # => true
f.pop                              # => nil
f.pop(2)                           # => []
f.push(14)                         # => FIFO[14]
f << "foo" << [1,2,3]              # => FIFO[14, "foo", [1, 2, 3]]
f.enqueue("bar", Hash.new, "baz")
# => FIFO[14, "foo", [1, 2, 3], "bar", {}, "baz"]
f.size                             # => 6
f.pop(3)                           # => [14, "foo", [1, 2, 3]]
f.dequeue                          # => "bar"
f.empty?                           # => false
g = FIFO[:a, :b, :c]
g.pop(2)                           # => [:a, :b]
g.pop(2)                           # => [:c]
g.pop(2)                           # => []
