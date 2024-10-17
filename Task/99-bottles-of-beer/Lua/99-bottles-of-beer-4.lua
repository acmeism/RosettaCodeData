local bottlesCount = 99
local word = function(n) return n == 1 and "bottle" or "bottles" end
while bottlesCount do
	print (string.format("%d %s of beer on the wall, %d %s of beer", bottlesCount, word(bottlesCount),bottlesCount, word(bottlesCount)))
	print ("You take one down, pass it around, ")
	bottlesCount = bottlesCount - 1
	if bottlesCount > 0 then
		print (string.format("%d %s of beer on the wall", bottlesCount, word(bottlesCount)))
	else
		print ("No more bottles of beer on the wall.")
	end
	if bottlesCount == 0 then bottlesCount = false end 		-- coud use reserved word break instead
end
