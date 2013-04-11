Private Const m_default = 10
Private m_bar As Integer

Private Sub Class_Initialize()
  'constructor, can be used to set default values
  m_bar = m_default
End Sub

Private Sub Class_Terminate()
  'destructor, can be used to do some cleaning up
  'here we just print a message
  Debug.Print "---object destroyed---"
End Sub
Property Let Bar(value As Integer)
  m_bar = value
End Property

Property Get Bar() As Integer
  Bar = m_bar
End Property

Function DoubleBar()
  m_bar = m_bar * 2
End Function

Function MultiplyBar(x As Integer)
  'another method
  MultiplyBar = m_bar * x
  'Note: instead of using the instance variable m_bar we could refer to the Bar property of this object using the special word "Me":
  '  MultiplyBar = Me.Bar * x
End Function
