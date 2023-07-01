Sub Rosetta_100Doors()
Dim Door(100) As Boolean, i As Integer, j As Integer
For i = 1 To 100 Step 1
    For j = i To 100 Step i
        Door(j) = Not Door(j)
    Next j
    If Door(i) = True Then
        Debug.Print "Door " & i & " is Open"
    Else
        Debug.Print "Door " & i & " is Closed"
    End If
Next i
End Sub
<!-- /lang -->

*** USE THIS ONE, SEE COMMENTED LINES, DONT KNOW WHY EVERYBODY FOLLOWED OTHERS ANSWERS AND CODED THE PROBLEM DIFFERENTLY ***
*** ALWAYS USE AND TEST A READABLE, EASY TO COMPREHEND CODING BEFORE 'OPTIMIZING' YOUR CODE AND TEST THE 'OPTIMIZED' CODE AGAINST THE 'READABLE' ONE.
Panikkos Savvides.


Sub Rosetta_100Doors2()
Dim Door(100) As Boolean, i As Integer, j As Integer
Dim strAns As String
' There are 100 doors in a row that are all initially closed.
' You make 100 passes by the doors.
For j = 1 To 100
    ' The first time through, visit every door and toggle the door
    ' (if the door is closed, open it; if it is open, close it).
    For i = 1 To 100 Step 1
      Door(i) = Not Door(i)
    Next i
    ' The second time, only visit every 2nd door (door #2, #4, #6, ...), and toggle it.
    For i = 2 To 100 Step 2
      Door(i) = Not Door(i)
    Next i
    ' The third time, visit every 3rd door (door #3, #6, #9, ...), etc, until you only visit the 100th door.
    For i = 3 To 100 Step 3
      Door(i) = Not Door(i)
    Next i
Next j

For j = 1 To 100
    If Door(j) = True Then
        strAns = j & strAns & ", "
    End If
Next j

If Right(strAns, 2) = ", " Then strAns = Left(strAns, Len(strAns) - 2)
If Len(strAns) = 0 Then strAns = "0"
Debug.Print "Doors [" & strAns & "] are open, the rest are closed."
' Doors [0] are open, the rest are closed., AKA ZERO DOORS OPEN
End Sub
