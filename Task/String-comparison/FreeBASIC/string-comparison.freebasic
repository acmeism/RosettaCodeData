' FB 1.05.0

' Strings in FB natively support the relational operators which compare lexically on a case-sensitive basis.
' There are no special provisions for numerical strings.
' There are no other types of string comparison for the built-in types though 'user defined types'
' can specify their own comparisons by over-loading the relational operators.

Function StringCompare(s1 As Const String, s2 As Const String, ignoreCase As Boolean = false) As String
  Dim As String s, t ' need new string variables as the strings passed in can't be changed
  If ignoreCase Then
    s = LCase(s1)
    t = LCase(s2)
  Else
    s = s1
    t = s2
  End If
  If s < t Then Return " comes before "
  If s = t Then Return " is equal to "
  Return " comes after "
End Function

Dim As Integer result
Dim As String s1, s2, s3
s1 = "Dog" : s2 = "Dog"
Print s1; StringCompare(s1, s2); s2
s2 = "Cat"
Print s1; StringCompare(s1, s2); s2
s2 = "Rat"
Print s1; StringCompare(s1, s2); s2
s2 = "dog"
Print s1; StringCompare(s1, s2); s2
Print s1; StringCompare(s1, s2, True); s2; " if case is ignored"
s1  = "Dog" : s2 = "Pig"
s3 = StringCompare(s1, s2)
If s3 <> " is equal to " Then
  Print s1; " is not equal to "; s2
End If
Print
Print "Press any key to quit"
Sleep
