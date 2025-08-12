function shoelacearea2(x, y)
    n = length(x)
    abs(sum(x[mod1(i-1, n)] * y[i] - x[i] * y[mod1(i-1, n)] for i in 1:n)) / 2
end

x, y = [3, 5, 12, 9, 5], [4, 11, 8, 5, 6]

using BenchmarkTools
@btime shoelacearea(x, y)
@btime shoelacearea2(x, y)
