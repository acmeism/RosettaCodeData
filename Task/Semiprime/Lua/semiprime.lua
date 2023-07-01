function semiprime (n)
	local divisor, count = 2, 0
	while count < 3 and n ~= 1 do
		if n % divisor == 0 then
			n = n / divisor
			count = count + 1
		else
			divisor = divisor + 1
		end
	end
	return count == 2
end

for n = 1675, 1680 do
	print(n, semiprime(n))
end
