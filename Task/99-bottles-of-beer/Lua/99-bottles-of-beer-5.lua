word = function(n) return n == 1 and "bottle" or "bottles" end

coldOne = function (bottlesCount)
	if bottlesCount < 1 then return print ("drunk, eh?") end
	if bottlesCount == 1 then return  print ("1 bottle of beer and it's mine!") end
	print (string.format("%d %s of beer on the wall, %d %s of beer", bottlesCount, word(bottlesCount),bottlesCount, word(bottlesCount)))
	print ("You take one down, pass it around, ")
	print (string.format("%d %s of beer on the wall", bottlesCount-1, word(bottlesCount-1)))
	coldOne ( bottlesCount - 1)
end
