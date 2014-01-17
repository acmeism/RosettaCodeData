' VBScript has a String() function that can repeat a character a given number of times
' but this only works with single characters (or the 1st char of a string):
WScript.Echo String(10, "123")	' Displays "1111111111"

' To repeat a string of chars, you can use either of the following "hacks"...
WScript.Echo Replace(Space(10), " ", "Ha")
WScript.Echo Replace(String(10, "X"), "X", "Ha")
