const CACHE = 256
buf = zeros(Int, CACHE)
buf[begin] = 1

function happy(n)
	if n < CACHE
		buf[n] > 0 && return 2-buf[n]
		buf[n] = 2
	end
	sqsum = 0
	nn = n
	while nn != 0
		nn, x = divrem(nn, 10)
		sqsum += x * x
	end
	x = happy(sqsum)
	n < CACHE && (buf[n] = 2 - x)
	return x
end

function main()
	i, counter = 1, 1000000
	while counter > 0
		if happy(i) != 0
			counter -= 1
		end
		i += 1
	end
	return i - 1
end
