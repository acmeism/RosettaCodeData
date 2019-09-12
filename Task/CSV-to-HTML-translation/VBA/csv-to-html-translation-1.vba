Public Sub CSV_TO_HTML()
    input_ = "Character,Speech\n" & _
        "The multitude,The messiah! Show us the messiah!\n" & _
        "Brians mother,<angry>Now you listen here! He's not the messiah; " & _
            "he's a very naughty boy! Now go away!</angry>\n" & _
        "The multitude,Who are you?\n" & _
        "Brians mother,I'm his mother; that's who!\n" & _
        "The multitude,Behold his mother! Behold his mother!"

    Debug.Print "<table>" & vbCrLf & "<tr><td>"
    For i = 1 To Len(input_)
        Select Case Mid(input_, i, 1)
            Case "\"
                If Mid(input_, i + 1, 1) = "n" Then
                    Debug.Print "</td></tr>" & vbCrLf & "<tr><td>";
                    i = i + 1
                Else
                    Debug.Print Mid(input_, i, 1);
                End If
            Case ",": Debug.Print "</td><td>";
            Case "<": Debug.Print "&lt;";
            Case ">": Debug.Print "&gt;";
            Case "&": Debug.Print "&amp;";
            Case Else: Debug.Print Mid(input_, i, 1);
        End Select
    Next i
    Debug.Print "</td></tr>" & vbCrLf & "</table>"
End Sub
