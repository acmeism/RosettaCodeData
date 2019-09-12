Option Base 1
Private Sub pascal_triangle(n As Integer)
    Dim odd() As String
    Dim eve() As String
    ReDim odd(1)
    ReDim eve(2)
    odd(1) = "  1"
    For i = 1 To n
        If i Mod 2 = 1 Then
            Debug.Print String$(2 * n - 2 * i, " ") & Join(odd, " ")
            eve(1) = "  1"
            ReDim Preserve eve(i + 1)
            For j = 2 To i
                eve(j) = Format(CStr(Val(odd(j - 1)) + Val(odd(j))), "@@@")
            Next j
            eve(i + 1) = "  1"
        Else
            Debug.Print String$(2 * n - 2 * i, " ") & Join(eve, " ")
            odd(1) = "  1"
            ReDim Preserve odd(i + 1)
            For j = 2 To i
                odd(j) = Format(CStr(Val(eve(j - 1)) + Val(eve(j))), "@@@")
            Next j
            odd(i + 1) = "  1"
        End If
    Next i
End Sub
Public Sub main()
    pascal_triangle 13
End Sub
