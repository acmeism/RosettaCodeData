function sma(period)
	local t = {}
	function sum(a, ...)
		if a then return a+sum(...) else return 0 end
	end
	function average(n)
		if #t == period then table.remove(t, 1) end
		t[#t + 1] = n
		return sum(unpack(t)) / #t
	end
	return average
end

sma5 = sma(5)
sma10 = sma(10)
print("SMA 5")
for v=1,15 do print(sma5(v)) end
print("\nSMA 10")
for v=1,15 do print(sma10(v)) end
