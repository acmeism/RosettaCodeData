Sub magicsquare()
    'Magic squares of odd order
    Const n = 9
    Dim i, j, v As Integer
    Console.WriteLine("The square order is: " & n)
    For i = 1 To n
        For j = 1 To n
            v = ((i * 2 - j + n - 1) Mod n) * n + ((i * 2 + j - 2) Mod n) + 1
            Console.Write(" " & Right(Space(5) & v, 5))
        Next j
        Console.WriteLine("")
    Next i
    Console.WriteLine("The magic number is: " & n * (n * n + 1) \ 2)
End Sub 'magicsquare
