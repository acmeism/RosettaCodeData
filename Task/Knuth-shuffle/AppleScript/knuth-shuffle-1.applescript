set n to 25

set array to {}
repeat with i from 1 to n
	set end of array to i
end repeat
copy {array, array} to {unshuffled, shuffled}
repeat with i from n to 1 by -1
	set j to (((random number) * (i - 1)) as integer) + 1
	set shuffled's item i to array's item j
	if j ≠ i's contents then set array's item j to array's item i
end repeat

return {unshuffled, shuffled}
