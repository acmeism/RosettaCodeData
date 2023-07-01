Module Module1

    Function EgyptianDivision(dividend As ULong, divisor As ULong, ByRef remainder As ULong) As ULong
        Const SIZE = 64
        Dim powers(SIZE) As ULong
        Dim doublings(SIZE) As ULong
        Dim i = 0

        While i < SIZE
            powers(i) = 1 << i
            doublings(i) = divisor << i
            If doublings(i) > dividend Then
                Exit While
            End If
            i = i + 1
        End While

        Dim answer As ULong = 0
        Dim accumulator As ULong = 0
        i = i - 1
        While i >= 0
            If accumulator + doublings(i) <= dividend Then
                accumulator += doublings(i)
                answer += powers(i)
            End If
            i = i - 1
        End While

        remainder = dividend - accumulator
        Return answer
    End Function

    Sub Main(args As String())
        If args.Length < 2 Then
            Dim name = Reflection.Assembly.GetEntryAssembly().Location
            Console.Error.WriteLine("Usage: {0} dividend divisor", IO.Path.GetFileNameWithoutExtension(name))
            Return
        End If

        Dim dividend = CULng(args(0))
        Dim divisor = CULng(args(1))
        Dim remainder As ULong

        Dim ans = EgyptianDivision(dividend, divisor, remainder)
        Console.WriteLine("{0} / {1} = {2} rem {3}", dividend, divisor, ans, remainder)
    End Sub

End Module
