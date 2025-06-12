property bins : {}

local limits, theData, n, i, p, flag, output
set limits to {14, 18, 249, 312, 389, 392, 513, 591, 634, 720}
set theData to {445, 814, 519, 697, 700, 130, 255, 889, 481, 122, 932, 77, 323, 525, 570, 219, 367, 523, 442, 933, ¬
	416, 589, 930, 373, 202, 253, 775, 47, 731, 685, 293, 126, 133, 450, 545, 100, 741, 583, 763, 306, ¬
	655, 267, 248, 477, 549, 238, 62, 678, 98, 534, 622, 907, 406, 714, 184, 391, 913, 42, 560, 247, ¬
	346, 860, 56, 138, 546, 38, 985, 948, 58, 213, 799, 319, 390, 634, 458, 945, 733, 507, 916, 123, ¬
	345, 110, 720, 917, 313, 845, 426, 9, 457, 628, 410, 723, 354, 895, 881, 953, 677, 137, 397, 97, ¬
	854, 740, 83, 216, 421, 94, 517, 479, 292, 963, 376, 981, 480, 39, 257, 272, 157, 5, 316, 395, ¬
	787, 942, 456, 242, 759, 898, 576, 67, 298, 425, 894, 435, 831, 241, 989, 614, 987, 770, 384, 692, ¬
	698, 765, 331, 487, 251, 600, 879, 342, 982, 527, 736, 795, 585, 40, 54, 901, 408, 359, 577, 237, ¬
	605, 847, 353, 968, 832, 205, 838, 427, 876, 959, 686, 646, 835, 127, 621, 892, 443, 198, 988, 791, ¬
	466, 23, 707, 467, 33, 670, 921, 180, 991, 396, 160, 436, 717, 918, 8, 374, 101, 684, 727, 749}

repeat (count limits) + 1 times
	set end of bins to 0
end repeat

repeat with n in theData
	set flag to false
	repeat with i from 1 to count limits
		if n < item i of limits then
			set flag to true
			exit repeat
		end if
	end repeat
	if flag then
		set item i of bins to (item i of bins) + 1
	else
		set item -1 of bins to (item -1 of bins) + 1
	end if
end repeat
set p to item 1 of limits
set output to "< " & p & " := " & (item 1 of bins) & linefeed
repeat with i from 2 to count limits
	set n to item i of limits
	set output to output & ">= " & p & " .. < " & n & " := " & (item i of bins) & linefeed
	set p to n
end repeat
set output to output & ">= " & p & " := " & (item -1 of bins)
get output
