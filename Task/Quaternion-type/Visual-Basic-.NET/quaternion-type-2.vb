Module Program
    Sub Main()
        Dim q As New Quaternion(1, 2, 3, 4),
            q1 As New Quaternion(2, 3, 4, 5),
            q2 As New Quaternion(3, 4, 5, 6),
            r As Double = 7

        Console.WriteLine($"q = {q}")
        Console.WriteLine($"q1 = {q1}")
        Console.WriteLine($"q2 = {q2}")
        Console.WriteLine($"r = {r}")
        Console.WriteLine($"q.Norm = {q.Norm}")
        Console.WriteLine($"q1.Norm = {q1.Norm}")
        Console.WriteLine($"q2.Norm = {q2.Norm}")
        Console.WriteLine($"-q = {-q}")
        Console.WriteLine($"q.Conjugate = {q.Conjugate}")
        Console.WriteLine($"q + r = {q + r}")
        Console.WriteLine($"q1 + q2 = {q1 + q2}")
        Console.WriteLine($"q2 + q1 = {q2 + q1}")
        Console.WriteLine($"q * r = {q * r}")
        Console.WriteLine($"q1 * q2 = {q1 * q2}")
        Console.WriteLine($"q2 * q1 = {q2 * q1}")
        Console.WriteLine($"q1*q2 {If((q1 * q2) = (q2 * q1), "=", "!=")} q2*q1")
    End Sub
End Module
