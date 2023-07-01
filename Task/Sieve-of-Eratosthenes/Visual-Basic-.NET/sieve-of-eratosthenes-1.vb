Dim n As Integer, k As Integer, limit As Integer
Console.WriteLine("Enter number to search to: ")
limit = Console.ReadLine
Dim flags(limit) As Integer
For n = 2 To Math.Sqrt(limit)
    If flags(n) = 0 Then
        For k = n * n To limit Step n
            flags(k) = 1
        Next k
    End If
Next n

' Display the primes
For n = 2 To limit
    If flags(n) = 0 Then
        Console.WriteLine(n)
    End If
Next n
