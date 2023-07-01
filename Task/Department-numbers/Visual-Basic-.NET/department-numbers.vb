Module Module1

    Sub Main()
        For p = 2 To 7 Step 2
            For s = 1 To 7
                Dim f = 12 - p - s
                If s >= f Then
                    Exit For
                End If
                If f > 7 Then
                    Continue For
                End If
                If s = p OrElse f = p Then
                    Continue For 'not even necessary
                End If
                Console.WriteLine($"Police:{p}, Sanitation:{s}, Fire:{f}")
                Console.WriteLine($"Police:{p}, Sanitation:{f}, Fire:{s}")
            Next
        Next
    End Sub

End Module
