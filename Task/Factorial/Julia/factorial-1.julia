function fact(n::Integer)
    n < 0 && return zero(n)
    f = one(n)
    for i in 2:n
        f *= i
    end
    return f
end

for i in 10:20
	println("$i -> ", fact(i))
end
