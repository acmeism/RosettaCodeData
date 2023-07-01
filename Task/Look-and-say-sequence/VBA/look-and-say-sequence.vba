Public Sub LookAndSay(Optional Niter As Integer = 10)
'generate "Niter" members of the look-and-say sequence
'(argument is optional; default is 10)

Dim s As String            'look-and-say number
Dim news As String         'next number in sequence
Dim curdigit As String     'current digit in s
Dim newdigit As String     'next digit in s
Dim curlength As Integer   'length of current run
Dim p As Integer           'position in s
Dim L As Integer           'length of s

On Error GoTo Oops          'to catch overflow, i.e. number too long

'start with "1"
s = "1"
For i = 1 To Niter
  'initialise
  L = Len(s)
  p = 1
  curdigit = Left$(s, 1)
  curlength = 1
  news = ""
  For p = 2 To L
    'check next digit in s
    newdigit = Mid$(s, p, 1)
    If curdigit = newdigit Then 'extend current run
      curlength = curlength + 1
    Else ' "output" run and start new run
      news = news & CStr(curlength) & curdigit
      curdigit = newdigit
      curlength = 1
    End If
  Next p
  ' "output" last run
  news = news & CStr(curlength) & curdigit
  Debug.Print news
  s = news
Next i
Exit Sub

Oops:
  Debug.Print
  If Err.Number = 6 Then 'overflow
    Debug.Print "Oops - number too long!"
  Else
    Debug.Print "Error: "; Err.Number, Err.Description
  End If
End Sub
