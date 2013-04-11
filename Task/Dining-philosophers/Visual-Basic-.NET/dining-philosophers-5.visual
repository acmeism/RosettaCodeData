Class SelflessPhilosopher
   Inherits PhilosopherBase

   Public Sub New(ByVal name As String, ByVal right As Fork, ByVal left As Fork)
       MyBase.New(name, right, left)
   End Sub

   Public Overrides Sub MainLoop()
       Do
           Console.WriteLine(Name & " sat down")
           Dim needDelay = False
TryAgain:
           If needDelay Then Thread.Sleep(rnd.Next(0, 10000))
           Try
               Monitor.Enter(m_Left)
               Console.WriteLine(Name & " picked up fork " & m_Left.Number)

               If Monitor.TryEnter(m_Right) Then
                   Console.WriteLine(Name & " picked up fork " & m_Right.Number)

                   Console.WriteLine(Name & " ate!!!!!!")

                   Console.WriteLine(Name & " put down fork " & m_Right.Number)
                   Monitor.Exit(m_Right)
               Else
                   Console.WriteLine(Name & " is going to wait")
                   needDelay = True
                   GoTo TryAgain
               End If
           Finally
               Console.WriteLine(Name & " put down fork " & m_Left.Number)
           End Try

           Console.WriteLine(Name & " stood up")

           Thread.Sleep(rnd.Next(0, 10000))

       Loop Until m_Disposed
   End Sub

End Class
