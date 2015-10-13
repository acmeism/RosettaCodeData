set blocks to {"bo", "xk", "dq", "cp", "na", "gt", "re", "tg", "qd", "fs", "jw", "hu", "vi", "an", "ob", "er", "fs", "ly", "pc", "zm"}

canMakeWordWithBlocks("a", blocks)
canMakeWordWithBlocks("bark", blocks)
canMakeWordWithBlocks("book", blocks)
canMakeWordWithBlocks("treat", blocks)
canMakeWordWithBlocks("common", blocks)
canMakeWordWithBlocks("squad", blocks)
canMakeWordWithBlocks("confuse", blocks)

on canMakeWordWithBlocks(theString, constBlocks)
	copy constBlocks to theBlocks
	if theString = "" then return true
	set i to 1
	repeat
		if i > (count theBlocks) then exit repeat
		if character 1 of theString is in item i of theBlocks then
			set item i of theBlocks to missing value
			set theBlocks to strings of theBlocks
			if canMakeWordWithBlocks(rest of characters of theString as string, theBlocks) then
				return true
			end if
		end if
		set i to i + 1
	end repeat
	return false
end canMakeWordWithBlocks
