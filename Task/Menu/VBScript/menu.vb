'The Function
Function Menu(ArrList, Prompt)
    Select Case False   'Non-standard usage hahaha
        Case IsArray(ArrList)
           Menu = ""   'Empty output string for non-arrays
           Exit Function
        Case UBound(ArrList) >= LBound(ArrList)
           Menu = ""   'Empty output string for empty arrays
           Exit Function
    End Select
    'Display menu and prompt
    Do While True
        For i = LBound(ArrList) To UBound(ArrList)
            WScript.StdOut.WriteLine((i + 1) & ". " & ArrList(i))
        Next
        WScript.StdOut.Write(Prompt)
        Choice = WScript.StdIn.ReadLine
        'Check if input is valid
        If IsNumeric(Choice) Then   'Check for numeric-ness
            If CStr(CLng(Choice)) = Choice Then   'Check for integer-ness (no decimal part)
                Index = Choice - 1   'Arrays are 0-based
                'Check if Index is in array
                If LBound(ArrList) <= Index And Index <= UBound(ArrList) Then
                    Exit Do
                End If
            End If
        End If
        WScript.StdOut.WriteLine("Invalid choice.")
    Loop
    Menu = ArrList(Index)
End Function

'The Main Thing
Sample = Array("fee fie", "huff and puff", "mirror mirror", "tick tock")
InputText = "Which is from the three pigs: "
WScript.StdOut.WriteLine("Output: " & Menu(Sample, InputText))
