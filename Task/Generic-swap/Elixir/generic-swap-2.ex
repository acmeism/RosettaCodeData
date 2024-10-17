swap = fn x,y -> [y|x] end
[x|y] = swap.(1,2)
x # => 2
y # => 1
