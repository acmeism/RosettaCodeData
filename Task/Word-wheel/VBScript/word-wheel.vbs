Const wheel="ndeokgelw"

Sub print(s):
  On Error Resume Next
  WScript.stdout.WriteLine (s)
  If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
End Sub

Dim oDic
Set oDic = WScript.CreateObject("scripting.dictionary")
Dim cnt(127)
Dim fso
Set fso = WScript.CreateObject("Scripting.Filesystemobject")
Set ff=fso.OpenTextFile("unixdict.txt")
i=0
print "reading words of 3 or more letters"
While Not ff.AtEndOfStream
  x=LCase(ff.ReadLine)
  If Len(x)>=3 Then
    If  Not odic.exists(x) Then oDic.Add x,0
  End If
Wend
print "remaining words: "& oDic.Count & vbcrlf
ff.Close
Set ff=Nothing
Set fso=Nothing

Set re=New RegExp
print "removing words with chars not in the wheel"
re.pattern="[^"& wheel &"]"
For Each w In oDic.Keys
  If  re.test(w) Then oDic.remove(w)
Next
print "remaining words: "& oDic.Count & vbcrlf

print "ensuring the mandatory letter "& Mid(wheel,5,1) & " is present"
re.Pattern=Mid(wheel,5,1)
For Each w In oDic.Keys
  If  Not re.test(w) Then oDic.remove(w)
Next
print "remaining words: "& oDic.Count & vbcrlf

print "checking number of chars"

Dim nDic
Set nDic = WScript.CreateObject("scripting.dictionary")
For i=1 To Len(wheel)
  x=Mid(wheel,i,1)
  If nDic.Exists(x) Then
    a=nDic(x)
    nDic(x)=Array(a(0)+1,0)
  Else
    nDic.add x,Array(1,0)
  End If
Next

For Each w In oDic.Keys
  For Each c In nDic.Keys
    ndic(c)=Array(nDic(c)(0),0)
  Next
  For ii = 1 To len(w)
    c=Mid(w,ii,1)
    a=nDic(c)
    If (a(0)=a(1)) Then
      oDic.Remove(w):Exit For
    End If
    nDic(c)=Array(a(0),a(1)+1)
  Next
Next

print "Remaining words "& oDic.count
For Each w In oDic.Keys
  print w
Next
