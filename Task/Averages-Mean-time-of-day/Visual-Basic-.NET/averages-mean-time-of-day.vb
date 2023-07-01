Module Module1

    Function TimeToDegrees(time As TimeSpan) As Double
        Return 360 * time.Hours / 24.0 + 360 * time.Minutes / (24 * 60.0) + 360 * time.Seconds / (24 * 3600.0)
    End Function

    Function DegreesToTime(angle As Double) As TimeSpan
        Return New TimeSpan((24 * 60 * 60 * angle \ 360) \ 3600, ((24 * 60 * 60 * angle \ 360) Mod 3600 - (24 * 60 * 60 * angle \ 360) Mod 60) \ 60, (24 * 60 * 60 * angle \ 360) Mod 60)
    End Function

    Function MeanAngle(angles As List(Of Double)) As Double
        Dim y_part = 0.0
        Dim x_part = 0.0
        Dim numItems = angles.Count

        For Each angle In angles
            x_part += Math.Cos(angle * Math.PI / 180)
            y_part += Math.Sin(angle * Math.PI / 180)
        Next

        Return Math.Atan2(y_part / numItems, x_part / numItems) * 180 / Math.PI
    End Function

    Sub Main()
        Dim digitimes As New List(Of Double)
        Dim digitime As TimeSpan
        Dim input As String

        Console.WriteLine("Enter times, end with no input: ")
        Do
            input = Console.ReadLine
            If Not String.IsNullOrWhiteSpace(input) Then
                If TimeSpan.TryParse(input, digitime) Then
                    digitimes.Add(TimeToDegrees(digitime))
                Else
                    Console.WriteLine("Seems this is wrong input: ingnoring time")
                End If
            End If
        Loop Until String.IsNullOrWhiteSpace(input)

        If digitimes.Count > 0 Then
            Console.WriteLine("The mean time is : {0}", DegreesToTime(360 + MeanAngle(digitimes)))
        End If
    End Sub

End Module
