s = "rosettacode.org"

'starting from n characters in and of m length
WScript.StdOut.WriteLine Mid(s,8,4)

'starting from n characters in, up to the end of the string
WScript.StdOut.WriteLine Mid(s,8,Len(s)-7)

'whole string minus last character
WScript.StdOut.WriteLine Mid(s,1,Len(s)-1)

'starting from a known character within the string and of m length
WScript.StdOut.WriteLine Mid(s,InStr(1,s,"c"),4)

'starting from a known substring within the string and of m length
WScript.StdOut.WriteLine Mid(s,InStr(1,s,"ose"),6)
