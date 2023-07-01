Imports System.Threading

Module Module1

   Sub Main()
       Dim t1 As New Thread(AddressOf Reader)
       Dim t2 As New Thread(AddressOf Writer)
       t1.Start()
       t2.Start()
       t1.Join()
       t2.Join()
   End Sub

   Sub Reader()
       For Each line In IO.File.ReadAllLines("input.txt")
           m_WriterQueue.Enqueue(line)
       Next
       m_WriterQueue.Enqueue(Nothing)

       Dim result As Integer
       Do Until m_ReaderQueue.TryDequeue(result)
           Thread.Sleep(10)
       Loop

       Console.WriteLine(result)

   End Sub

   Sub Writer()
       Dim count = 0
       Dim line As String = Nothing
       Do
           Do Until m_WriterQueue.TryDequeue(line)
               Thread.Sleep(10)
           Loop
           If line IsNot Nothing Then
               Console.WriteLine(line)
               count += 1
           Else
               m_ReaderQueue.Enqueue(count)
               Exit Do
           End If
       Loop
   End Sub

   Private m_WriterQueue As New SafeQueue(Of String)
   Private m_ReaderQueue As New SafeQueue(Of Integer)

End Module

Class SafeQueue(Of T)
   Private m_list As New Queue(Of T)
   Public Function TryDequeue(ByRef result As T) As Boolean
       SyncLock m_list
           If m_list.Count = 0 Then Return False
           result = m_list.Dequeue
           Return True
       End SyncLock
   End Function
   Public Sub Enqueue(ByVal value As T)
       SyncLock m_list
           m_list.Enqueue(value)
       End SyncLock
   End Sub
End Class
