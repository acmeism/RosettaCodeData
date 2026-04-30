arr = [1, 2, 3, 4, 5]

# basic form:
arr.reduce {|acc, n| acc + n }      # => 15

# with initial value:
arr.reduce(100) {|acc, n| acc + n } # => 115

# there are some built-in reducers:
arr.product                         # => 120
arr.sum                             # => 15
arr.accumulate                      # => [1, 3, 6, 10, 15]

# they allow for an initial value
# and/or a block to map the elements beforehand:
arr.sum(1000) {|elt| elt * 100 }    # => 2500
