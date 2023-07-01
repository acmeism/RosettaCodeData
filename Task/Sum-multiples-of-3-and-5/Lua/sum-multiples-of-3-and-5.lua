function tri (n) return n * (n + 1) / 2 end

function sum35 (n)
	n = n - 1
	return	(	3 * tri(math.floor(n / 3)) +
			5 * tri(math.floor(n / 5)) -
			15 * tri(math.floor(n / 15))
		)
end

print(sum35(1000))
print(sum35(1e+20))
