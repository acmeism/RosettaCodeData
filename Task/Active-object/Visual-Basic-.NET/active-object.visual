Module Module1

    Sub Main()
        Using active As New Integrator
            active.Operation = Function(t As Double) Math.Sin(2 * Math.PI * 0.5 * t)
            Threading.Thread.Sleep(TimeSpan.FromSeconds(2))
            Console.WriteLine(active.Value)
            active.Operation = Function(t As Double) 0
            Threading.Thread.Sleep(TimeSpan.FromSeconds(0.5))
            Console.WriteLine(active.Value)
        End Using
        Console.ReadLine()
    End Sub

End Module

Class Integrator
    Implements IDisposable

    Private m_Operation As Func(Of Double, Double)
    Private m_Disposed As Boolean
    Private m_SyncRoot As New Object
    Private m_Value As Double

    Public Sub New()
        m_Operation = Function(void) 0.0
        Dim t As New Threading.Thread(AddressOf MainLoop)
        t.Start()
    End Sub

    Private Sub MainLoop()
        Dim epoch = Now
        Dim t0 = 0.0
        Do
            SyncLock m_SyncRoot
                Dim t1 = (Now - epoch).TotalSeconds
                m_Value = m_Value + (Operation(t1) + Operation(t0)) * (t1 - t0) / 2
                t0 = t1
            End SyncLock
            Threading.Thread.Sleep(10)
        Loop Until m_Disposed
    End Sub

    Public Property Operation() As Func(Of Double, Double)
        Get
            SyncLock m_SyncRoot
                Return m_Operation
            End SyncLock
        End Get
        Set(ByVal value As Func(Of Double, Double))
            SyncLock m_SyncRoot
                m_Operation = value
            End SyncLock
        End Set
    End Property

    Public ReadOnly Property Value() As Double
        Get
            SyncLock m_SyncRoot
                Return m_Value
            End SyncLock
        End Get
    End Property

    Protected Overridable Sub Dispose(ByVal disposing As Boolean)
        m_Disposed = True
    End Sub

    Public Sub Dispose() Implements IDisposable.Dispose
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub

End Class
