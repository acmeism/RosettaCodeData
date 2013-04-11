Module Module1

   Sub Main()
       Dim doors(100) As Boolean 'Door 1 is at index 0

       For i = 1 To 10
           doors(i ^ 2 - 1) = True
       Next

       For door = 0 To 99
           Console.WriteLine("Door # " & (door + 1) & " is " & If(doors(door), "Open", "Closed"))
       Next

       Console.ReadLine()
   End Sub

End Module
