require 'matrix'

# creating a matrix
p m0 = Matrix.zero(3)       #=> Matrix[[0, 0, 0], [0, 0, 0], [0, 0, 0]]
p m1 = Matrix.identity(3)   #=> Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]]
p m2 = Matrix[[11, 12], [21, 22]]
                            #=> Matrix[[11, 12], [21, 22]]
p m3 = Matrix.build(3) {|row, col| row - col}
                            #=> Matrix[[0, -1, -2], [1, 0, -1], [2, 1, 0]]

p m2[0,0]               #=> 11
p m1 * 5                #=> Matrix[[5, 0, 0], [0, 5, 0], [0, 0, 5]]
p m1 + m3               #=> Matrix[[1, -1, -2], [1, 1, -1], [2, 1, 1]]
p m1 * m3               #=> Matrix[[0, -1, -2], [1, 0, -1], [2, 1, 0]]

# creating a Vector
p v1 = Vector[1,3,5]    #=> Vector[1, 3, 5]
p v2 = Vector[0,1,2]    #=> Vector[0, 1, 2]
p v1[1]                 #=> 3
p v1 * 2                #=> Vector[2, 6, 10]
p v1 + v2               #=> Vector[1, 4, 7]

p m1 * v1               #=> Vector[1, 3, 5]
p m3 * v1               #=> Vector[-13, -4, 5]
