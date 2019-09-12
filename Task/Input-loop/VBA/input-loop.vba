Public Sub test()
    Dim filesystem As Object, stream As Object, line As String
    Set filesystem = CreateObject("Scripting.FileSystemObject")
    Set stream = filesystem.OpenTextFile("D:\test.txt")
    Do While stream.AtEndOfStream <> True
        line = stream.ReadLine
        Debug.Print line
    Loop
    stream.Close
End Sub
