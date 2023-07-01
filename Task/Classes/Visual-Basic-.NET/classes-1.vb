Class Foo
   Private m_Bar As Integer

   Public Sub New()

   End Sub

   Public Sub New(ByVal bar As Integer)
       m_Bar = bar
   End Sub

   Public Property Bar() As Integer
       Get
           Return m_Bar
       End Get
       Set(ByVal value As Integer)
           m_Bar = value
       End Set
   End Property

   Public Sub DoubleBar()
       m_Bar *= 2
   End Sub

   Public Function MultiplyBar(ByVal x As Integer) As Integer
       Return x * Bar
   End Function

End Class
