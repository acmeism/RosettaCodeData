Module Module1

    Private rand As New Random

    Sub Main()
        For numInputs As Integer = 1 To 10 '10 is the number of bracket sequences to test.
            Dim input As String = GenerateBrackets(rand.Next(0, 5)) '5 represents the number of pairs of brackets (n)
            Console.WriteLine(String.Format("{0} : {1}", input.PadLeft(10, CChar(" ")), If(IsBalanced(input) = True, "OK", "NOT OK")))
        Next
        Console.ReadLine()
    End Sub

    Private Function GenerateBrackets(n As Integer) As String

        Dim randomString As String = ""
        Dim numOpen, numClosed As Integer

        Do Until numOpen = n And numClosed = n
            If rand.Next(0, 501) Mod 2 = 0 AndAlso numOpen < n Then
                randomString = String.Format("{0}{1}", randomString, "[")
                numOpen += 1
            ElseIf rand.Next(0, 501) Mod 2 <> 0 AndAlso numClosed < n Then
                randomString = String.Format("{0}{1}", randomString, "]")
                numClosed += 1
            End If
        Loop
        Return randomString
    End Function

    Private Function IsBalanced(brackets As String) As Boolean

        Dim numOpen As Integer = 0
        Dim numClosed As Integer = 0

        For Each character As Char In brackets
            If character = "["c Then numOpen += 1
            If character = "]"c Then
                numClosed += 1
                If numClosed > numOpen Then Return False
            End If
        Next
        Return numOpen = numClosed
    End Function
End Module
