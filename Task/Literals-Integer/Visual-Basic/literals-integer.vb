Sub Main()

'Long:    4 Bytes (signed), type specifier = &
Dim l1 As Long, l2 As Long, l3 As Long
'Integer: 2 Bytes (signed), type specifier = %
Dim i1 As Integer, i2 As Integer, i3 As Integer
'Byte:    1 Byte (unsigned), no type specifier
Dim b1 As Byte, b2 As Byte, b3 As Byte

  l1 = 1024&
  l2 = &H400&
  l3 = &O2000&
  Debug.Assert l1 = l2
  Debug.Assert l2 = l3

  i1 = 1024
  i2 = &H400
  i3 = &O2000
  Debug.Assert i1 = i2
  Debug.Assert i2 = i3

  b1 = 255
  b2 = &O377
  b3 = &HFF
  Debug.Assert b1 = b2
  Debug.Assert b2 = b3

End Sub
