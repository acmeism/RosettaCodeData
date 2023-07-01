aString = "radar"
bString = ""
for i=len(aString) to 1 step -1
    bString = bString + aString[i]
next
see aString
if aString = bString see " is a palindrome." + nl
else see " is not a palindrome" + nl ok
