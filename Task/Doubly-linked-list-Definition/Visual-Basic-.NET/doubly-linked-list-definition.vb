Public Class DoubleLinkList(Of T)
   Private m_Head As Node(Of T)
   Private m_Tail As Node(Of T)

   Public Sub AddHead(ByVal value As T)
       Dim node As New Node(Of T)(Me, value)

       If m_Head Is Nothing Then
           m_Head = Node
           m_Tail = m_Head
       Else
           node.Next = m_Head
           m_Head = node
       End If

   End Sub

   Public Sub AddTail(ByVal value As T)
       Dim node As New Node(Of T)(Me, value)

       If m_Tail Is Nothing Then
           m_Head = node
           m_Tail = m_Head
       Else
           node.Previous = m_Tail
           m_Tail = node
       End If
   End Sub

   Public ReadOnly Property Head() As Node(Of T)
       Get
           Return m_Head
       End Get
   End Property

   Public ReadOnly Property Tail() As Node(Of T)
       Get
           Return m_Tail
       End Get
   End Property

   Public Sub RemoveTail()
       If m_Tail Is Nothing Then Return

       If m_Tail.Previous Is Nothing Then 'empty
           m_Head = Nothing
           m_Tail = Nothing
       Else
           m_Tail = m_Tail.Previous
           m_Tail.Next = Nothing
       End If
   End Sub

   Public Sub RemoveHead()
       If m_Head Is Nothing Then Return

       If m_Head.Next Is Nothing Then 'empty
           m_Head = Nothing
           m_Tail = Nothing
       Else
           m_Head = m_Head.Next
           m_Head.Previous = Nothing
       End If
   End Sub

End Class

Public Class Node(Of T)
   Private ReadOnly m_Value As T
   Private m_Next As Node(Of T)
   Private m_Previous As Node(Of T)
   Private ReadOnly m_Parent As DoubleLinkList(Of T)

   Public Sub New(ByVal parent As DoubleLinkList(Of T), ByVal value As T)
       m_Parent = parent
       m_Value = value
   End Sub

   Public Property [Next]() As Node(Of T)
       Get
           Return m_Next
       End Get
       Friend Set(ByVal value As Node(Of T))
           m_Next = value
       End Set
   End Property

   Public Property Previous() As Node(Of T)
       Get
           Return m_Previous
       End Get
       Friend Set(ByVal value As Node(Of T))
           m_Previous = value
       End Set
   End Property

   Public ReadOnly Property Value() As T
       Get
           Return m_Value
       End Get
   End Property

   Public Sub InsertAfter(ByVal value As T)
       If m_Next Is Nothing Then
           m_Parent.AddTail(value)
       ElseIf m_Previous Is Nothing Then
           m_Parent.AddHead(value)
       Else
           Dim node As New Node(Of T)(m_Parent, value)
           node.Previous = Me
           node.Next = Me.Next
           Me.Next.Previous = node
           Me.Next = node
       End If
   End Sub

   Public Sub Remove()
       If m_Next Is Nothing Then
           m_Parent.RemoveTail()
       ElseIf m_Previous Is Nothing Then
           m_Parent.RemoveHead()
       Else
           m_Previous.Next = Me.Next
           m_Next.Previous = Me.Previous
       End If
   End Sub

End Class
