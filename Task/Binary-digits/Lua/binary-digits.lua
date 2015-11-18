function dec2bin (n)
	local bin, number, bit = "", tonumber(n) -- can pass n as string
	while number > 0 do
		bit = number % 2
		number = math.floor(number/2)
		bin = bit .. bin
	end
	return bin
end

print(dec2bin(5))
print(dec2bin(50))
print(dec2bin(9000))
