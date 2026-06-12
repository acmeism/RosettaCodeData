Dim As Integer n, m
Dim As String list(1 To 2, 1 To 7) = {_
{"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}, _
{"Red","Orange","Yellow","Green","Blue","Purple"}}
Dim As Integer ind(1 To 3) = {1,4,5}

Print "All elements:"
For n = 1 To Ubound(list)
    For m = 1 To Ubound(list, 2)
        Print list(n, m); " ";
    Next m
    Print
Next n

Print !"\nFirst, fourth, and fifth elements:"
For n = 1 To Ubound(list)
    For m = 1 To Ubound(ind)
        Print list(n, ind(m)); " ";
    Next m
    Print
Next n

Print !"\nReverse first, fourth, and fifth elements:"
For m = 1 To Ubound(ind)
    Print list(1, Ubound(list,2)+1-ind(m)); " ";
Next m
Print
For m = 1 To Ubound(ind)
    Print list(2, Ubound(list,2)-ind(m)); " ";
Next m
Sleep
