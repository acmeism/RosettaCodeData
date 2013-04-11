Imports System.Threading
Module Module1
   Public rnd As New Random

   Sub Main()
       'Aristotle, Kant, Spinoza, Marx, and Russel
       Dim f1 As New Fork(1)
       Dim f2 As New Fork(2)
       Dim f3 As New Fork(3)
       Dim f4 As New Fork(4)
       Dim f5 As New Fork(5)

       Console.WriteLine("1: Deadlock")
       Console.WriteLine("2: Live lock")
       Console.WriteLine("3: Working")
       Select Console.ReadLine
           Case "1"
               Using _
                   Aristotle As New SelfishPhilosopher("Aristotle", f1, f2), _
                   Kant As New SelfishPhilosopher("Kant", f2, f3), _
                   Spinoza As New SelfishPhilosopher("Spinoza", f3, f4), _
                   Marx As New SelfishPhilosopher("Marx", f4, f5), _
                   Russel As New SelfishPhilosopher("Russel", f5, f1)

                   Console.ReadLine()
               End Using
           Case "2"
               Using _
                   Aristotle As New SelflessPhilosopher("Aristotle", f1, f2), _
                   Kant As New SelflessPhilosopher("Kant", f2, f3), _
                   Spinoza As New SelflessPhilosopher("Spinoza", f3, f4), _
                   Marx As New SelflessPhilosopher("Marx", f4, f5), _
                   Russel As New SelflessPhilosopher("Russel", f5, f1)

                   Console.ReadLine()
               End Using
           Case "3"
               Using _
                   Aristotle As New WisePhilosopher("Aristotle", f1, f2), _
                   Kant As New WisePhilosopher("Kant", f2, f3), _
                   Spinoza As New WisePhilosopher("Spinoza", f3, f4), _
                   Marx As New WisePhilosopher("Marx", f4, f5), _
                   Russel As New WisePhilosopher("Russel", f5, f1)

                   Console.ReadLine()
               End Using
       End Select
   End Sub

End Module
