using .Triangles

t1 = [0 0; 5 0; 0 5]
t2 = [0 0; 5 0; 0 6]
@show Triangles.overlap(t1, t2)

t1 = [0 0; 0 5; 5 0]
t2 = [0 0; 0 6; 5 0]
@show Triangles.overlap(t1, t2, widing=Both())

t1 = [0 0; 5 0; 0 5]
t2 = [-10 0; -5 0; -1 6]
@show Triangles.overlap(t1, t2)

t1 = [0 0; 5 0; 2.5 5]
t2 = [0 4; 2.5 -1; 5 4]
@show Triangles.overlap(t1, t2)

t1 = [0 0; 1 1; 0 2]
t2 = [2 1; 3 0; 3 2]
@show Triangles.overlap(t1, t2)

t1 = [0 0; 1 1; 0 2]
t2 = [2 1; 3 -2; 3 4]
@show Triangles.overlap(t1, t2)

# Barely touching
t1 = [0 0; 1 0; 0 1]
t2 = [1 0; 2 0; 1 1]
@show Triangles.overlap(t1, t2, StrictCheck())

# Barely touching
t1 = [0 0; 1 0; 0 1]
t2 = [1 0; 2 0; 1 1]
@show Triangles.overlap(t1, t2, MildCheck())
