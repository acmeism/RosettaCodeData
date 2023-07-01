Randomize
Dim n(9) 'nine is the upperbound.
         'since VBS arrays are 0-based, it will have 10 elements.
For L = 0 to 9
   n(L) = Int(Rnd * 32768)
Next

WScript.StdOut.Write "ORIGINAL : "
For L = 0 to 9
   WScript.StdOut.Write n(L) & ";"
Next

InsertionSort n

WScript.StdOut.Write vbCrLf & "  SORTED : "
For L = 0 to 9
   WScript.StdOut.Write n(L) & ";"
Next

'the function
Sub InsertionSort(theList)
   For insertionElementIndex = 1 To UBound(theList)
      insertionElement = theList(insertionElementIndex)
      j = insertionElementIndex - 1
      Do While j >= 0
         'necessary for BASICs without short-circuit evaluation
         If insertionElement < theList(j) Then
            theList(j + 1) = theList(j)
            j = j - 1
         Else
            Exit Do
         End If
      Loop
      theList(j + 1) = insertionElement
   Next
End Sub
