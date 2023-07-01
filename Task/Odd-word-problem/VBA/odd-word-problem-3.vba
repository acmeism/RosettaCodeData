Option Explicit

Sub Main()
   Debug.Print "Input : " & "we,are;not,in,kansas;any,more."
   Debug.Print "First way : " & OddWordFirst("we,are;not,in,kansas;any,more.")
   Debug.Print "Second way : " & OddWordSecond("we,are;not,in,kansas;any,more.")
   Debug.Print ""
   Debug.Print "Input : " & "what,is,the;meaning,of:life."
   Debug.Print "First way : " & OddWordFirst("what,is,the;meaning,of:life.")
   Debug.Print "Second way : " & OddWordSecond("what,is,the;meaning,of:life.")
End Sub
