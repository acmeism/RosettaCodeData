const CACHE = 256
buf = zeros(Int,CACHE)
buf[1] = 1
#happy(n) returns 1 if happy, 0 if not
function happy(n)
	if n < CACHE
		buf[n] > 0 && return 2-buf[n]
		buf[n] = 2
	end
	sum = 0
	nn = n
	while nn != 0
		x = nn%10
		sum += x*x
		nn = int8(nn/10)
	end
	x = happy(sum)
	n < CACHE && (buf[n] = 2-x)
	return x
end
function main()
	i = 1; counter = 1000000
	while counter > 0
		if happy(i) == 1
			counter -= 1
		end
		i += 1
	end
	return i-1
end
