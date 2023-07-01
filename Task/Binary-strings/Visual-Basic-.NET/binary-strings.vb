Module Module1

    Sub Main()
        'string creation
        Dim x = "hello world"

        ' mark string for garbage collection
        x = Nothing

        ' string assignment with a null byte
        x = "ab" + Chr(0)
        Console.WriteLine(x)
        Console.WriteLine(x.Length)

        'string comparison
        If x = "hello" Then
            Console.WriteLine("equal")
        Else
            Console.WriteLine("not equal")
        End If

        If x.CompareTo("bc") = -1 Then
            Console.WriteLine("x is lexicographically less than 'bc'")
        End If

        'string cloning
        Dim c(3) As Char
        x.CopyTo(0, c, 0, 3)
        Dim objecty As New String(c)
        Dim y As New String(c)

        Console.WriteLine(x = y)        'same as string.equals
        Console.WriteLine(x.Equals(y))  'it overrides object.equals

        Console.WriteLine(x = objecty)  'uses object.equals, return false

        'check if empty
        Dim empty = ""
        Dim nullString As String = Nothing
        Dim whitespace = "    "
        If IsNothing(nullString) AndAlso empty = String.Empty _
            AndAlso String.IsNullOrEmpty(nullString) AndAlso String.IsNullOrEmpty(empty) _
            AndAlso String.IsNullOrWhiteSpace(nullString) AndAlso String.IsNullOrWhiteSpace(empty) _
            AndAlso String.IsNullOrWhiteSpace(whitespace) Then
            Console.WriteLine("Strings are null, empty or whitespace")
        End If

        'append a byte
        x = "helloworld"
        x += Chr(83)
        Console.WriteLine(x)

        'substring
        Dim slice = x.Substring(5, 5)
        Console.WriteLine(slice)

        'replace bytes
        Dim greeting = x.Replace("worldS", "")
        Console.WriteLine(greeting)

        'join strings
        Dim join = greeting + " " + slice
        Console.WriteLine(join)
    End Sub

End Module
