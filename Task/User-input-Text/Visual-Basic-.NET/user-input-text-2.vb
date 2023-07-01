Dim i As Integer
Dim iString As String
Console.WriteLine("Enter an Integer")
iString = Console.ReadLine()
Try
    i = Convert.ToInt32(iString)
Catch ex As Exception
    Console.WriteLine("This is not an Integer")
End Try
