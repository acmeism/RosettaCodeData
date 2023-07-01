Sub walkTree(ByVal directory As IO.DirectoryInfo, ByVal pattern As String)
    For Each file In directory.GetFiles(pattern)
        Console.WriteLine(file.FullName)
    Next
    For Each subDir In directory.GetDirectories
        walkTree(subDir, pattern)
    Next
End Sub
