Public Function Reverse(aString as String) as String
' returns the reversed string
dim L as integer        'length of string
dim newString as string

newString = ""
L = len(aString)
for i = L to 1 step -1
 newString = newString & mid$(aString, i, 1)
next
Reverse = newString
End Function
