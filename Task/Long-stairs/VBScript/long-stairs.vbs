Option Explicit
Randomize Timer

Function pad(s,n)
  If n<0 Then pad= right(space(-n) & s ,-n) Else  pad= left(s& space(n),n) End If
End Function

Sub print(s)
  On Error Resume Next
  WScript.stdout.WriteLine (s)
  If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
End Sub

Function Rounds(maxsecs,wiz,a)
  Dim mystep,maxstep,toend,j,i,x,d
  If IsArray(a) Then d=True: print "seconds behind pending"
  maxstep=100
  For j=1 To maxsecs
    For i=1 To wiz
      If Int(Rnd*maxstep)<=mystep Then mystep=mystep+1
      maxstep=maxstep+1
    Next
    mystep=mystep+1
    If mystep=maxstep Then Rounds=Array(j,maxstep) :Exit Function
    If d Then
      If j>=a(0) And j<=a(1) Then print pad(j,-7) & pad (mystep,-7) & pad (maxstep-mystep,-8)
    End If
  Next
  Rounds=Array(maxsecs,maxstep)
End Function


Dim n,r,a,sumt,sums,ntests,t,maxsecs
ntests=10000
maxsecs=7000
t=timer
a=Array(600,609)
For n=1 To ntests
  r=Rounds(maxsecs,5,a)
  If r(0)<>maxsecs Then
    sumt=sumt+r(0)
    sums=sums+r(1)
  End if
  a=""
Next

print vbcrlf & "Done " & ntests & " tests in " & Timer-t & " seconds"
print "escaped in " & sumt/ntests  & " seconds with " & sums/ntests & " stairs"
