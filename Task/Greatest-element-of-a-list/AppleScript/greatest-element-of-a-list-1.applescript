max({1, 2, 3, 4, 20, 6, 11, 3, 9, 7})

on max(aList)
	set _curMax to first item of aList
	repeat with i in (rest of aList)
		if i > _curMax then set _curMax to contents of i
	end repeat
	return _curMax
end max
