ary = [1,1,2,1,'redundant',[1,2,3],[1,2,3],'redundant']
p ary.uniq              # => [1, 2, "redundant", [1, 2, 3]]
