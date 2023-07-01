Class SelfishPhilosopher
   Inherits PhilosopherBase
   Public Sub New(ByVal name As String, ByVal right As Fork, ByVal left As Fork)
       MyBase.New(name, right, left)
   End Sub

   Public Overrides Sub MainLoop()
       Do
           Console.WriteLine(Name & " sat down")
           SyncLock m_Left
               Console.WriteLine(Name & " picked up fork " & m_Left.Number)

               SyncLock m_Right
                   Console.WriteLine(Name & " picked up fork " & m_Right.Number)

                   Console.WriteLine(Name & " ate!!!!")

                   Console.WriteLine(Name & " put down fork " & m_Right.Number)
               End SyncLock


               Console.WriteLine(Name & " put down fork " & m_Left.Number)
           End SyncLock

           Console.WriteLine(Name & " stood up")

           Thread.Sleep(rnd.Next(0, 10000))
       Loop Until m_Disposed
   End Sub

End Class
