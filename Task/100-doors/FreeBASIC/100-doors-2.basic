' version 27-10-2016
' compile with: fbc -s console

#Define max_doors 100

Dim As ULong c, n, n1, door(1 To max_doors)

' at start all doors are closed
' simple add 1 each time we open or close a door
' doors with odd numbers are open
' doors with even numbers are closed
For n = 1 To max_doors
    For n1 = n To max_doors Step n
        door(n1) += 1
    Next
Next

Print "doors that are open nr: ";
For n = 1 To max_doors
    If door(n) And 1 Then
        Print n; " ";
        c = c + 1
    End If
Next

Print : Print
Print "There are " + Str(c) + " doors open"

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
