""" true if num is a forbidden number """
function isforbidden(num)
	fours, pow4 = num, 0
	while fours > 1 && fours % 4 == 0
		fours ÷= 4
		pow4 += 1
	end
	return (num ÷ 4^pow4) % 8 == 7
end

const f500M = filter(isforbidden, 1:500_000_000)

for (idx, fbd) in enumerate(f500M[begin:begin+49])
	print(lpad(fbd, 4), idx % 10 == 0 ? '\n' : "")
end

for fbmax in [500, 5000, 50_000, 500_000, 500_000_000]
	println("\nThere are $(sum(x <= fbmax for x in f500M)) forbidden numbers <= $fbmax.")
end
