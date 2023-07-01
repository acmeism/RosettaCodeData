Imports System.Console
Imports System.Linq.Enumerable

Module Program
    Sub Main()
        Dim Text = Function(index As Integer) If(index = 32, "Sp", If(index = 127, "Del", ChrW(index) & ""))

        Dim start = 32
        Do
            WriteLine(String.Concat(Range(0, 6).Select(Function(i) $"{start + 16 * i, -3} : {Text(start + 16 * i), -6}")))
            start += 1
        Loop While start + 16 * 5 < 128
    End Sub
End Module
