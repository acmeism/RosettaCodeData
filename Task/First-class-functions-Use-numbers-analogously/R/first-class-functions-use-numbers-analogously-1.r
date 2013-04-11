multiplier <- function(n1,n2) { (function(m){n1*n2*m}) }
x  = 2.0
xi = 0.5
y  = 4.0
yi = 0.25
z  = x + y
zi = 1.0 / ( x + y )
num = c(x,y,z)
inv = c(xi,yi,zi)

multiplier(num,inv)(0.5)

Output
[1] 0.5 0.5 0.5
