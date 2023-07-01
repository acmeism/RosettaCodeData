using .KnuthPowerTree: path, pow

for n in 0:17
    println("2 ^ $n:\n - path: ", join(path(n), ", "), "\n - result: ", pow(2, n))
end

for (x, n) in ((big(3), 191), (1.1, 81))
    println("$x ^ $n:\n - path: ", join(path(n), ", "), "\n - result: ", pow(x, n))
end
