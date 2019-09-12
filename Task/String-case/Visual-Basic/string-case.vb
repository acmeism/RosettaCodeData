Sub Main()
Const TESTSTRING As String = "alphaBETA"
Debug.Print "initial   =                                      " _
   & TESTSTRING
Debug.Print "uppercase =                                      " _
   & UCase(TESTSTRING)
Debug.Print "lowercase =                                      " _
   & LCase(TESTSTRING)
Debug.Print "first letter capitalized =                       " _
   & StrConv(TESTSTRING, vbProperCase)
Debug.Print "length (in characters) =                         " _
   & CStr(Len(TESTSTRING))
Debug.Print "length (in bytes) =                              " _
   & CStr(LenB(TESTSTRING))
Debug.Print "reversed =                                       " _
   & StrReverse(TESTSTRING)
Debug.Print "first position of letter A (case-sensitive) =    " _
   & InStr(1, TESTSTRING, "A", vbBinaryCompare)
Debug.Print "first position of letter A (case-insensitive) =  " _
   & InStr(1, TESTSTRING, "A", vbTextCompare)
Debug.Print "concatenated with '123' =                        " _
   & TESTSTRING & "123"
End Sub
