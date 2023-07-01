Module Module1

   Sub Main()
       Dim doors(100) As Boolean 'Door 1 is at index 0

       For pass = 1 To 100
           For door = pass - 1 To 99 Step pass
               doors(door) = Not doors(door)
           Next
       Next

       For door = 0 To 99
           Console.WriteLine("Door # " & (door + 1) & " is " & If(doors(door), "Open", "Closed"))
       Next

       Console.ReadLine()
   End Sub

End Module
