MustInherit Class PhilosopherBase
   Implements IDisposable

   Protected m_Disposed As Boolean
   Protected ReadOnly m_Left As Fork
   Protected ReadOnly m_Right As Fork
   Protected ReadOnly m_Name As String
   Public Sub New(ByVal name As String, ByVal right As Fork, ByVal left As Fork)
       m_Name = name
       m_Right = right
       m_Left = left
       Dim t As New Thread(AddressOf MainLoop)
       t.IsBackground = True
       t.Start()
   End Sub
   Protected Overridable Sub Dispose(ByVal disposing As Boolean)
       m_Disposed = True
   End Sub

   Public Sub Dispose() Implements IDisposable.Dispose
       Dispose(True)
       GC.SuppressFinalize(Me)
   End Sub
   Public ReadOnly Property Name() As String
       Get
           Return m_Name
       End Get
   End Property

   Public MustOverride Sub MainLoop()
End Class
