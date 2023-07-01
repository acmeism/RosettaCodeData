p s = Stack.new                 # => Stack[]
p s.empty?                      # => true
p s.size                        # => 0
p s.top                         # => nil
p s.pop                         # => nil
p s.pop(1)                      # => []
p s.push(1)                     # => Stack[1]
p s.push(2, 3)                  # => Stack[1, 2, 3]
p s.top                         # => 3
p s.top(2)                      # => [2, 3]
p s                             # => Stack[1, 2, 3]
p s.size                        # => 3
p s.pop                         # => 3
p s.pop(1)                      # => [2]
p s.empty?                      # => false

p s = Stack[:a, :b, :c]         # => Stack[:a, :b, :c]
p s << :d                       # => Stack[:a, :b, :c, :d]
p s.pop                         # => :d
