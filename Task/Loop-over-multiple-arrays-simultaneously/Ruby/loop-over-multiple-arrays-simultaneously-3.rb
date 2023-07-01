irb(main):001:0> ['a','b','c'].zip(['A','B'], [1,2,3,4]) {|a| puts a.join}
aA1
bB2
c3
=> nil
irb(main):002:0> ['a','b','c'].zip(['A','B'], [1,2,3,4])
=> [["a", "A", 1], ["b", "B", 2], ["c", nil, 3]]
