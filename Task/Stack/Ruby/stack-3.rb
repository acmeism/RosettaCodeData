s = Stack.new
s.empty?                           # => true
s.pop                              # => nil
s.pop(1)                           # => []
s.push(1)                          # => Stack[1]
s.push(2, 3)                       # => Stack[1, 2, 3]
s.pop                              # => 3
s.pop(1)                           # => [2]
s.empty?                           # => false

s = Stack[:a, :b, :c]
s.pop                              # => :c
