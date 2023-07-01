Module Module1

    Function Delta_Bearing(b1 As Decimal, b2 As Decimal) As Decimal
        Dim d As Decimal = 0

        ' Convert bearing to W.C.B
        While b1 < 0
            b1 += 360
        End While
        While b1 > 360
            b1 -= 360
        End While

        While b2 < 0
            b2 += 360
        End While
        While b2 > 0
            b2 -= 360
        End While

        ' Calculate delta bearing
        d = (b2 - b1) Mod 360
        ' Convert result to Q.B
        If d > 180 Then
            d -= 360
        ElseIf d < -180 Then
            d += 360
        End If

        Return d
    End Function

    Sub Main()
        ' Calculate standard test cases
        Console.WriteLine(Delta_Bearing(20, 45))
        Console.WriteLine(Delta_Bearing(-45, 45))
        Console.WriteLine(Delta_Bearing(-85, 90))
        Console.WriteLine(Delta_Bearing(-95, 90))
        Console.WriteLine(Delta_Bearing(-45, 125))
        Console.WriteLine(Delta_Bearing(-45, 145))
        Console.WriteLine(Delta_Bearing(29.4803, -88.6381))
        Console.WriteLine(Delta_Bearing(-78.3251, -159.036))

        ' Calculate optional test cases
        Console.WriteLine(Delta_Bearing(-70099.742338109383, 29840.674378767231))
        Console.WriteLine(Delta_Bearing(-165313.6666297357, 33693.9894517456))
        Console.WriteLine(Delta_Bearing(1174.8380510598456, -154146.66490124757))
        Console.WriteLine(Delta_Bearing(60175.773067955459, 42213.071923543728))
    End Sub

End Module
