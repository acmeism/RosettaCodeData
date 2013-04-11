dim s as string

' assign an empty string to a variable:
s = ""

' test if a string is empty:
if s = "" then Debug.Print "empty!"
' or:
if Len(s) = 0 then Debug.Print "still empty!"

'test if a string is not empty:
if s <> "" then Debug.Print "not an empty string"
'or:
if Len(s) > 0 then Debug.Print "not empty."
