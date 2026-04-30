Option Explicit
Const numchars=127  'plain ASCII

Function LZWCompress(si)
  Dim oDict,  intMaxCode, i,z,ii,ss,strCurrent,strNext,j
  Set oDict = CreateObject("Scripting.Dictionary")
  ReDim a(Len(si))

  intMaxCode = numchars
  For i = 0 To numchars
    oDict.Add Chr(i), i
  Next
  'strCurrent = ofread.ReadText(1)
  strCurrent = Left(si,1)
  j=0
  For ii=2 To Len(si)
    strNext = Mid(si,ii,1)
    ss=strCurrent & strNext
    If oDict.Exists(ss) Then
      strCurrent = ss
    Else
      a(j)=oDict.Item(strCurrent) :j=j+1
      intMaxCode = intMaxCode + 1
      oDict.Add ss, intMaxCode
      strCurrent = strNext
    End If
  Next
  a(j)=oDict.Item(strCurrent)
  ReDim preserve a(j)
  LZWCompress=a
  Set oDict = Nothing
End Function

Function lzwUncompress(sc)
  Dim intNext, intCurrent, intMaxCode, i,ss,istr,s,j
  s=""
  reDim dict(1000)
  intMaxCode = numchars
  For i = 0 To numchars : dict(i)= Chr(i) :  Next
    intCurrent=sc(0)

    For j=1 To UBound(sc)
      ss=dict(intCurrent)
      s= s & ss
      intMaxCode = intMaxCode + 1
      intnext=sc(j)
      If intNext<intMaxCode Then
        dict(intMaxCode)=ss & Left(dict(intNext), 1)
      Else
        dict(intMaxCode)=ss & Left(ss, 1)
      End If
      intCurrent = intNext
    Next
    s= s & dict(intCurrent)
    lzwUncompress=s
End function

Sub printvec(a)
  Dim s,i,x
  s="("
  For i=0 To UBound (a)
   s=s & x & a(i)
   x=", "
  Next
  WScript.echo s &")"
End sub

Dim a,b
b="TOBEORNOTTOBEORTOBEORNOT"
WScript.Echo b
a=LZWCompress (b)
printvec(a)
WScript.echo lzwUncompress (a )
wscript.quit 1
