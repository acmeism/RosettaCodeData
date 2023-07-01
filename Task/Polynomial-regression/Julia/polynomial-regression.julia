polyfit(x::Vector, y::Vector, deg::Int) = collect(v ^ p for v in x, p in 0:deg) \ y

x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
y = [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321]
@show polyfit(x, y, 2)
