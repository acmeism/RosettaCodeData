Public Declare Function GetTickCount Lib "kernel32.dll" () As Long
Public Sub begin()
    start_int = GetTickCount()
    main
    Debug.Print (GetTickCount() - start_int) / 1000 & " seconds"
End Sub
Private Function pow(x, y) As Variant
    pow = CDec(Application.WorksheetFunction.Power(x, y))
End Function
Private Sub main()
    For x0 = 1 To 250
        For x1 = 1 To x0
            For x2 = 1 To x1
                For x3 = 1 To x2
                    sum = CDec(pow(x0, 5) + pow(x1, 5) + pow(x2, 5) + pow(x3, 5))
                    s1 = Int(pow(sum, 0.2))
                    If sum = pow(s1, 5) Then
                        Debug.Print x0 & "^5 + " & x1 & "^5 + " & x2 & "^5 + " & x3 & "^5 = " & s1
                        Exit Sub
                    End If
                Next x3
            Next x2
        Next x1
    Next x0
End Sub
