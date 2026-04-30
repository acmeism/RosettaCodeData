function sma(period)
	local t = {}
	local function sum(t)
		local tot = 0
		for _, v in ipairs(t) do
			tot = tot + v
		end
		return tot
	end
	local function average(n)
		if #t == period then table.remove(t, 1) end
		t[#t + 1] = n
		return sum(t) / #t
	end
	return average
end

sma5 = sma(5)
sma10 = sma(10)
print("SMA 5")
for v=1,15 do print(sma5(v)) end
print("\nSMA 10")
for v=1,15 do print(sma10(v)) end
