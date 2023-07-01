b = proc {|x, y, z| (x||0) + (y||0) + (z||0) }
p b.curry[1][2][3]           #=> 6
p b.curry[1, 2][3, 4]        #=> 6
p b.curry(5)[1][2][3][4][5]  #=> 6
p b.curry(5)[1, 2][3, 4][5]  #=> 6
p b.curry(1)[1]              #=> 1

b = proc {|x, y, z, *w| (x||0) + (y||0) + (z||0) + w.inject(0, &:+) }
p b.curry[1][2][3]           #=> 6
p b.curry[1, 2][3, 4]        #=> 10
p b.curry(5)[1][2][3][4][5]  #=> 15
p b.curry(5)[1, 2][3, 4][5]  #=> 15
p b.curry(1)[1]              #=> 1
