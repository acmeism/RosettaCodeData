Option Explicit

Sub Test_a_function()
Dim a, i&
    a = Array("abba", "mom", "dennis sinned", "Un roc lamina l animal cornu", "palindrome", "ba _ ab", "racecars", "racecar", "wombat", "in girum imus nocte et consumimur igni")
    For i = 0 To UBound(a)
        Debug.Print a(i) & " is a palidrome ? " & IsPalindrome(CStr(a(i)))
    Next
End Sub

Function IsPalindrome(txt As String) As Boolean
Dim tempTxt As String
    tempTxt = LCase(Replace(txt, " ", ""))
    IsPalindrome = (tempTxt = StrReverse(tempTxt))
End Function
