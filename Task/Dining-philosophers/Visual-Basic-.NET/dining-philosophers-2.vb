Class Fork
   Private ReadOnly m_Number As Integer
   Public Sub New(ByVal number As Integer)
       m_Number = number
   End Sub
   Public ReadOnly Property Number() As Integer
       Get
           Return m_Number
       End Get
   End Property
End Class
