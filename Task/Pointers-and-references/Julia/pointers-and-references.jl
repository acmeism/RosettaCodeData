x = [1, 2, 3, 7]

parr = pointer(x)

xx = unsafe_load(parr, 4)

println(xx)  #  Prints 7
