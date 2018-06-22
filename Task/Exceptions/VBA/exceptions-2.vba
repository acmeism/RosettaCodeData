Sub bar1()
'by convention, a simple handler
    On Error GoTo catch
    foo1
    MsgBox " No Error"
    Exit Sub
catch:
    'handle all exceptions
    MsgBox Err.Number & vbCrLf & Err.Description
    Exit Sub
End Sub

Sub bar2()
'a more complex handler, illustrating some of the flexibility of VBA exception handling
    On Error GoTo catch
100     foo1
200     foo2
    'finally block may be placed anywhere: this is complexity for it's own sake:
   GoTo finally
catch:
   If Erl = 100 Then
      ' handle exception at first line: in this case, by ignoring it:
      Resume Next
   Else
      Select Case Err.Number
         Case vbObjectError + 1050
             ' handle exceptions of type 1050
             MsgBox "type 1050"
         Case vbObjectError + 1051
             ' handle exceptions of type 1051
             MsgBox "type 1051"
         Case Else
             ' handle any type of exception not handled by above catches or line numbers
             MsgBox Err.Number & vbCrLf & Err.Description
      End Select
      Resume finally
  End If
finally:
   'code here occurs whether or not there was an exception
   'block may be placed anywhere
   'by convention, often just a drop through to an Exit Sub, rather tnan a code block
   GoTo end_try:

end_try:
    'by convention, often just a drop through from the catch block
End Sub
