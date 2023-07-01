Option Strict On

Imports System.Text

Module Module1

    Sub PrintVerse(name As String)
        Dim sb As New StringBuilder(name.ToLower())
        sb(0) = Char.ToUpper(sb(0))

        Dim x = sb.ToString()
        Dim y = If("AEIOU".IndexOf(x(0)) > -1, x.ToLower(), x.Substring(1))
        Dim b = "b" + y
        Dim f = "f" + y
        Dim m = "m" + y
        Select Case x(0)
            Case "B"c
                b = y
                Exit Select
            Case "F"c
                f = y
                Exit Select
            Case "M"c
                m = y
                Exit Select
        End Select

        Console.WriteLine("{0}, {0}, bo-{1}", x, b)
        Console.WriteLine("Banana-fana fo-{0}", f)
        Console.WriteLine("Fee-fi-mo-{0}", m)
        Console.WriteLine("{0}!", x)
        Console.WriteLine()
    End Sub

    Sub Main()
        Dim nameList As New List(Of String) From {"Gary", "Earl", "Billy", "Felix", "Mary", "Steve"}
        nameList.ForEach(AddressOf PrintVerse)
    End Sub

End Module
