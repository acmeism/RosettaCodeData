"""
Assumes x,y points go around the polygon in one direction.
"""
shoelacearea(x, y) =
			abs(sum([i * j for (i, j) in zip(x, append!(y[2:end], y[1]))]) -
				sum([i * j for (i, j) in zip(append!(x[2:end], x[1]), y)])) / 2

x, y = [3, 5, 12, 9, 5], [4, 11, 8, 5, 6]
@show x y shoelacearea(x, y)
