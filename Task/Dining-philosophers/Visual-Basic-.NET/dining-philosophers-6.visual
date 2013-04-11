Class WisePhilosopher
   Inherits PhilosopherBase
   Public Sub New(ByVal name As String, ByVal right As Fork, ByVal left As Fork)
       MyBase.New(name, right, left)
   End Sub

   Public Overrides Sub MainLoop()
       Do
           Console.WriteLine(Name & " sat down")

           Dim first As Fork, second As Fork
           If m_Left.Number > m_Right.Number Then
               first = m_Left
               second = m_Right
           Else
               first = m_Right
               second = m_Left
           End If

           SyncLock first
               Console.WriteLine(Name & " picked up fork " & m_Left.Number)

               SyncLock second
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
