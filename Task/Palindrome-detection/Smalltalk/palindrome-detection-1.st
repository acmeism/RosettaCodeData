isPalindrome := [:aString |
	str := (aString select: [:chr| chr isAlphaNumeric]) collect: [:chr | chr asLowercase].
	str = str reversed.
	].
