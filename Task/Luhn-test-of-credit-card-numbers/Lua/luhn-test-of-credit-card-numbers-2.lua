function luhn(digits)
	local sum = 0
	for odd,even in digits:reverse():gmatch"(.)(.?)" do
		local number = 2 * (tonumber(even) or 0)
		sum = sum + odd + number%10 + number//10
	end
	return sum%10==0
end
