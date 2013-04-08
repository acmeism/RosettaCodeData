a = 1.0/0       # => Infinity
a.finite?       # => false
a.infinite?     # => 1

a = -1/0.0      # => -Infinity
a.infinite?     # => -1

a = Float::MAX  # => 1.79769313486232e+308
a.finite?       # => true
a.infinite?     # => nil
