-- Example usage
local x1, y1, r1 = 0, 0, 1
local x2, y2, r2 = 4, 0, 1
local x3, y3, r3 = 2, 4, 2

print(solveApollonius(
x1, y1, r1,
x2, y2, r2,
x3, y3, r3,
1, 1, 1
))

print(solveApollonius(
x1, y1, r1,
x2, y2, r2,
x3, y3, r3,
-1, -1, -1
))
--Output:
--2.0	2.1	3.9
--2.0	0.83333333333333	1.1666666666667
