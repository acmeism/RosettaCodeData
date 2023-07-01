' version 18-03-2016
' compile with: fbc -s console
' doubly even magic square 4, 8, 12, 16...

Sub Err_msg(msg As String)
    Print msg
    Beep : Sleep 5000, 1 : Exit Sub
End Sub

Sub de_magicsq(n As UInteger, filename As String = "")

    ' filename <> "" then save square in a file
    ' filename can contain directory name
    ' if filename exist it will be overwriten, no error checking

    If n < 4 Then
        Err_msg( "Error: n is to small")
        Exit Sub
    End If

    If (n Mod 4) <> 0 Then
        Err_msg "Error: not possible to make doubly" + _
        " even magic square size " + Str(n)
        Exit Sub
    End If

    Dim As UInteger sq(1 To n, 1 To n)
    Dim As UInteger magic_sum = n * (n ^ 2 +1) \ 2
    Dim As UInteger q = n \ 4
    Dim As UInteger x, y, nr = 1
    Dim As String frmt = String(Len(Str(n * n)) +1, "#")

    ' set up the square
    For y = 1 To n
        For x = q +1 To n - q
            sq(x,y) = 1
        Next
    Next
    For x = 1 To n
        For y = q +1 To n - q
            sq(x, y) Xor= 1
        Next
    Next

    ' fill the square
    q = n * n +1
    For y = 1 To n
        For x = 1 To n
            If sq(x,y) = 0 Then
                sq(x,y) = q - nr
            Else
                sq(x,y) = nr
            End If
            nr += 1
        Next
    Next

    ' check columms and rows
    For y = 1 To n
        nr = 0 : q = 0
        For x = 1 To n
            nr += sq(x,y)
            q += sq(y,x)
        Next
        If nr <> magic_sum Or q <> magic_sum Then
            Err_msg "Error: value <> magic_sum"
            Exit Sub
        End If
    Next

    ' check diagonals
    nr = 0 : q = 0
    For x = 1 To n
        nr += sq(x, x)
        q += sq(n - x +1, n - x +1)
    Next
    If nr <> magic_sum Or q <> magic_sum Then
        Err_msg "Error: value <> magic_sum"
        Exit Sub
    End If

    ' printing square's on screen bigger when
    ' n > 19 results in a wrapping of the line
    Print "Single even magic square size: "; n; "*"; n
    Print "The magic sum = "; magic_sum
    Print
    For y = 1 To n
        For x = 1 To n
            Print Using frmt; sq(x, y);
        Next
        Print
    Next

    ' output magic square to a file with the name provided
    If filename <> "" Then
        nr = FreeFile
        Open filename For Output As #nr
        Print #nr, "Single even magic square size: "; n; "*"; n
        Print #nr, "The magic sum = "; magic_sum
        Print #nr,
        For y = 1 To n
            For x = 1 To n
                Print #nr, Using frmt; sq(x,y);
            Next
            Print #nr,
        Next
        Close #nr
    End If

End Sub

' ------=< MAIN >=------

de_magicsq(8, "magic8de.txt") : Print

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
