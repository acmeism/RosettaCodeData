import strutils

var s: string = "alphaBETA_123"
echo s, " as upper case: ", toUpperAscii(s)
echo s, " as lower case: ", toLowerAscii(s)
echo s, " as capitalized: ", capitalizeAscii(s)
echo s, " as normal case: ", normalize(s)  # to lower case without underscores.
