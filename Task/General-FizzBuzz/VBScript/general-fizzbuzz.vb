'The Function
Function FizzBuzz(range, mapping)
    data = Array()

    'Parse the mapping and put to "data" array
    temp = Split(mapping, ",")
    ReDim data(UBound(temp),1)
    For i = 0 To UBound(temp)
        map = Split(temp(i), " ")
        data(i, 0) = map(0)
        data(i, 1) = map(1)
    Next

    'Do the loop
    For i = 1 to range
        noMatch = True
        For j = 0 to UBound(data, 1)
            If (i Mod data(j, 0)) = 0 Then
                WScript.StdOut.Write data(j, 1)
                noMatch = False
            End If
        Next
        If noMatch Then WScript.StdOut.Write i
        WScript.StdOut.Write vbCrLf
    Next
End Function

'The Main Thing
WScript.StdOut.Write "Range? "
x = WScript.StdIn.ReadLine
WScript.StdOut.Write "Mapping? "
y = WScript.StdIn.ReadLine
WScript.StdOut.WriteLine ""
FizzBuzz x, y
