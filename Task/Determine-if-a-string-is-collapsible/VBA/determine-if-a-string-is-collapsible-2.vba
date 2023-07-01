Sub CallCollapse()
Dim S As String
    S = vbNullString
    Debug.Print "String : <<<" & S & ">>>", "Lenght : " & Len(S)
    Debug.Print "Collapsed : <<<" & Collapse(S) & ">>>", "Lenght : " & Len(Collapse(S))
    S = """If I were two-faced, would I be wearing this one?"" --- Abraham Lincoln "
    Debug.Print "String : <<<" & S & ">>>", "Lenght : " & Len(S)
    Debug.Print "Collapsed : <<<" & Collapse(S) & ">>>", "Lenght : " & Len(Collapse(S))
    S = "..1111111111111111111111111111111111111111111111111111111111111117777888"
    Debug.Print "String : <<<" & S & ">>>", "Lenght : " & Len(S)
    Debug.Print "Collapsed : <<<" & Collapse(S) & ">>>", "Lenght : " & Len(Collapse(S))
    S = "I never give 'em hell, I just tell the truth, and they think it's hell. "
    Debug.Print "String : <<<" & S & ">>>", "Lenght : " & Len(S)
    Debug.Print "Collapsed : <<<" & Collapse(S) & ">>>", "Lenght : " & Len(Collapse(S))
    S = "                                                    --- Harry S Truman  "
    Debug.Print "String : <<<" & S & ">>>", "Lenght : " & Len(S)
    Debug.Print "Collapsed : <<<" & Collapse(S) & ">>>", "Lenght : " & Len(Collapse(S))
End Sub
