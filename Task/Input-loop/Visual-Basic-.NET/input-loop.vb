Sub Consume(ByVal stream As IO.StreamReader)
    Dim line = stream.ReadLine
    Do Until line Is Nothing
        Console.WriteLine(line)
        line = stream.ReadLine
    Loop
End Sub
