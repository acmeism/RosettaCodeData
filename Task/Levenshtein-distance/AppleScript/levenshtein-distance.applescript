set dist to findLevenshteinDistance for "sunday" against "saturday"
to findLevenshteinDistance for s1 against s2
	script o
		property l : s1
		property m : s2
	end script
	if s1 = s2 then return 0
	set ll to length of s1
	set lm to length of s2
	if ll = 0 then return lm
	if lm = 0 then return ll
	
	set v0 to {}
	
	repeat with i from 1 to (lm + 1)
		set end of v0 to (i - 1)
	end repeat
	set item -1 of v0 to 0
	copy v0 to v1
	
	repeat with i from 1 to ll
		-- calculate v1 (current row distances) from the previous row v0
		
		-- first element of v1 is A[i+1][0]
		--   edit distance is delete (i+1) chars from s to match empty t
		set item 1 of v1 to i
		--  use formula to fill in the rest of the row
		repeat with j from 1 to lm
			if item i of o's l = item j of o's m then
				set cost to 0
			else
				set cost to 1
			end if
			set item (j + 1) of v1 to min3 for ((item j of v1) + 1) against ((item (j + 1) of v0) + 1) by ((item j of v0) + cost)
		end repeat
		copy v1 to v0
	end repeat
	return item (lm + 1) of v1
end findLevenshteinDistance

to min3 for anInt against anOther by theThird
	if anInt < anOther then
		if theThird < anInt then
			return theThird
		else
			return anInt
		end if
	else
		if theThird < anOther then
			return theThird
		else
			return anOther
		end if
	end if
end min3
