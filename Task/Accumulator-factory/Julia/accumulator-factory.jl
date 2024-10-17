function accumulator(i)
	f(n) = i += n
	return f
end

x = accumulator(1)
@show x(5)

accumulator(3)
@show x(2.3)
