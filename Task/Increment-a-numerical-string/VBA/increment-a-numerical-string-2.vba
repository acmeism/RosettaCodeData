Public Function Lincr(astring As String) As String
'increment a number string, of whatever length
'calls function "increment" or "decrement"
Dim result As String

'see if it is a negative number
If left$(astring, 1) = "-" Then
  'negative x: decrease |x| by 1, then add "-"
  '(except if the result is zero)
  result = decrement(Mid$(astring, 2))
  If result <> "0" Then result = "-" & result
Else
  '0 or positive x: increase x by 1
  If left$(astring, 1) = "+" Then  'allow a + before the number
    result = increment(Mid$(astring, 2))
  Else
    result = increment(astring)
  End If
End If
Lincr = result
End Function

Public Function increment(astring) As String
Dim result As String
'increment a string representing a positive number
'does not work with negative numbers
carry = 1
L = Len(astring)
result = ""
For j = L To 1 Step -1
  digit = Val(Mid$(astring, j, 1)) + carry
  If digit > 9 Then
    digit = digit - 10
    carry = 1
  Else
    carry = 0
  End If
  result = CStr(digit) & result
Next
If carry = 1 Then result = CStr(carry) & result
increment = result
End Function

Public Function decrement(astring) As String
Dim result As String
'decrement a string representing a positive number
'does not work with zero or negative numbers
borrow = 1
L = Len(astring)
result = ""
For j = L To 1 Step -1
  digit = Val(Mid$(astring, j, 1)) - borrow
  If digit < 0 Then
    digit = digit + 10
    borrow = 1
  Else
    borrow = 0
  End If
  result = CStr(digit) & result
Next
'remove leading zero, if necessary
If (Len(result) > 1) And (left$(result, 1) = "0") Then result = Mid$(result, 2)
decrement = result
End Function
