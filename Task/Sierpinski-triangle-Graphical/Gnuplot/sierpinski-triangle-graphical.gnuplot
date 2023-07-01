# triangle_x(n) and triangle_y(n) return X,Y coordinates for the
# Sierpinski triangle point number n, for integer n.
triangle_x(n) = (n > 0 ? 2*triangle_x(int(n/3)) + digit_to_x(int(n)%3) : 0)
triangle_y(n) = (n > 0 ? 2*triangle_y(int(n/3)) + digit_to_y(int(n)%3) : 0)
digit_to_x(d) = (d==0 ? 0 : d==1 ? -1 : 1)
digit_to_y(d) = (d==0 ? 0 : 1)

# Plot the Sierpinski triangle to "level" many replications.
# "trange" and "samples" are chosen so the parameter t runs through
# integers t=0 to 3**level-1, inclusive.
#
level=6
set trange [0:3**level-1]
set samples 3**level
set parametric
set key off
plot triangle_x(t), triangle_y(t) with points
