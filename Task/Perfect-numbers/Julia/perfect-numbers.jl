isperfect(n::Integer) = n == sum([n % i == 0 ? i : 0 for i = 1:(n - 1)])
perfects(n::Integer) = filter(isperfect, 1:n)

@show perfects(10000)
