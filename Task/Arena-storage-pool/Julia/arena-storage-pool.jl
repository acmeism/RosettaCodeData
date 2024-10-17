matrix = zeros(Float64, (1000,1000,1000))
# use matrix, then when done set variable to 0 to garbage collect the matrix:
matrix = 0 # large memory pool will now be collected when needed
