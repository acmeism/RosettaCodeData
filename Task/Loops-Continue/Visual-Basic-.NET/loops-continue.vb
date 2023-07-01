For i = 1 To 10
    Console.Write(i)
    If i Mod 5 = 0 Then
        Console.WriteLine()
    Else
        Console.Write(", ")
    End If
Next
