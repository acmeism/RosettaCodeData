'VBScript Sudoku solver. Fast recursive algorithm adapted from the C version
'It can read a problem passed in the command line or  from a file /f:textfile
'if no problem passed it solves a hardwired problem (See the prob0 string)
'problem string can have 0's or dots in the place of unknown values. All chars different from .0123456789 are ignored

Option explicit
  Sub print(s):
    On Error Resume Next
    WScript.stdout.Write (s)
    If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
  End Sub

function parseprob(s)'problem string to array
  Dim i,j,m
  print "parsing: " & s & vbCrLf & vbcrlf
  j=0
   For i=1 To Len(s)
      m=Mid(s,i,1)
      Select Case m
      Case "0","1","2","3","4","5","6","7","8","9"
         sdku(j)=cint(m)
         j=j+1
      Case "."
         sdku(j)=0
         j=j+1
      Case Else  'all other chars are ignored as separators
      End Select
   Next
  ' print j
   If j<>81 Then parseprob=false Else parseprob=True
 End function

sub getprob  'get problem from file or from command line or from
 Dim s,s1
 With WScript.Arguments.Named
    If .exists("f") Then
        s1=.item("f")
        If InStr(s1,"\")=0 Then s1= Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))&s1
       On Error Resume Next
       s= CreateObject("Scripting.FileSystemObject").OpenTextFile (s1, 1).readall
       If err Then  print "can't open file " & s1 :  parseprob(prob0): Exit sub
       If parseprob(s) =True Then Exit sub
    End if
 End With
 With WScript.Arguments.Unnamed
    If .count<>0 Then
    s1=.Item(0)
     If parseprob(s1)=True Then exit sub
    End if
 End With
 parseprob(prob0)
 End sub

function solve(x,ByVal pos)
 'print pos & vbcrlf
 'display(x)

 Dim row,col,i,j,used
 solve=False
 If pos=81 Then solve= true :Exit function
 row= pos\9
 col=pos mod 9
 If x(pos) Then solve=solve(x,pos+1):Exit Function
 used=0
 For i=0 To 8
   used=used Or pwr(x(i * 9 + col))
 Next
For i=0 To 8
   used=used Or pwr(x(row*9 + i))
next
row = (row\ 3) * 3
col = (col \3) * 3
For i=row To row+2
  For j=col To col+2
   ' print i & " " & j &vbcrlf
    used = used Or pwr(x(i*9+j))
  Next
Next
'print pos & " " & Hex(used) & vbcrlf
For i=1 To 9
  If (used And pwr(i))=0 Then
     x(pos)=i
     'print pos & " " & i & " " & num2bin((used)) & vbcrlf
     solve= solve(x,pos+1)
     If solve=True Then Exit Function
     'x(pos)=0
  End If
Next
x(pos)=0
 solve=False
End Function

Sub display(x)
  Dim i,s
  For i=0 To 80
    If i mod 9=0  Then print s & vbCrLf :s=""
    If i mod 27=0 Then print vbCrLf
    If i mod 3=0 Then s=s & " "
    s=s& x(i)& " "
  Next
  print s & vbCrLf
End Sub

Dim pwr:pwr=Array(1,2,4,8,16,32,64,128,256,512,1024,2048)
Dim prob0:prob0= "001005070"&"920600000"& "008000600"&"090020401"& "000000000" & "304080090" & "007000300" & "000007069" &  "010800700"
Dim sdku(81),Time
getprob
print "The problem"
display(sdku)
Time=Timer
If solve (sdku,0) Then
 print vbcrlf &"solution found"  & vbcrlf
 display(sdku)
Else
  print "no solution found " & vbcrlf
End if
print vbcrlf & "time: " & Timer-Time & " seconds" & vbcrlf
