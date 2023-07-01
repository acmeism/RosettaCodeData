Public Function isPalindrome(aString as string) as Boolean
dim tempstring as string
  tempstring = Lcase(Replace(aString, " ", ""))
  isPalindrome = (tempstring = Reverse(tempstring))
End Function
