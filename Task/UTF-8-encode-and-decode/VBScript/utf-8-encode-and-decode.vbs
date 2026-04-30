Option Explicit
Dim m_1,m_2,m_3,m_4
Dim d_2,d_3,d_4
Dim h_0,h_2,h_3,h_4
Dim mc_0,mc_2,mc_3,mc_4

m_1=&h3F
d_2=m_1+1
m_2=m_1 * d_2
d_3= (m_2 Or m_1)+1
m_3= m_2* d_2
d_4=(m_3 Or m_2 Or m_1)+1

h_0=&h80
h_2=&hC0
h_3=&hE0
h_4=&hF0

mc_0=&h3f
mc_2=&h1F
mc_3=&hF
mc_4=&h7

Function cp2utf8(cp)  'cp as long, returns string
If cp<&h80 Then
  cp2utf8=Chr(cp)
ElseIf (cp <=&H7FF) Then
  cp2utf8=Chr(h_2 or (cp \ d_2) )&Chr(h_0 Or (cp And m_1))
ElseIf (cp <=&Hffff&) Then
  cp2utf8= Chr(h_3 Or (cp\ d_3)) & Chr(h_0 Or (cp And  m_2)\d_2) & Chr(h_0 Or (cp And m_1))
Else
  cp2utf8= Chr(h_4 Or (cp\d_4))& Chr(h_0 Or ((cp And m_3) \d_3))& Chr(h_0 Or ((cp And  m_2)\d_2)) & Chr(h_0 Or (cp And m_1))
End if
End Function

Function utf82cp(utf) 'utf as string, returns long
   Dim a,b,m
   m=strreverse(utf)
   b= Len(utf)
   a=asc(mid(m,1,1))
   utf82cp=a And &h7f
   if b=1 Then Exit Function
   a=asc(mid(m,2,1))
   If b=2 Then utf82cp= utf82cp Or (a And mc_2)*d_2 :Exit function
   utf82cp= utf82cp Or (a And m_1)*d_2
   a=asc(mid(m,3,1))
   If b=3 Then utf82cp= utf82cp Or (a And mc_3)*d_3 :Exit function
   utf82cp= utf82cp Or (a And m_1)*d_3 Or  (a=asc(mid(m,4,1)) And mc_4)*d_4
End Function

Sub print(s):
    On Error Resume Next
    WScript.stdout.Write (s)
    If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
End Sub

Function utf8displ(utf)
  Dim s,i
  s=""
  For i=1 To Len(utf)
    s=s &" "& Hex(Asc(Mid(utf,i,1)))
  Next
  utf8displ= pad(s,12)
End function

function pad(s,n) if n<0 then pad= right(space(-n) & s ,-n) else  pad= left(s& space(n),n) end if :end function

Sub check(i)
Dim c,c0,c1,c2,u
c=b(i):c0=pad(c(0),29) :c1=c(1) :c2=pad(c(2),12):u=cp2utf8(c1)
print c0 & " CP:" & pad("U+" & Hex(c1),-8) & "    my utf8:" & utf8displ (u) & " should be:" & c2 & " back to CP:" & pad("U+" & Hex(utf82cp(u)),-8)& vbCrLf
End Sub

Dim b
b=Array(_
  Array("LATIN CAPITAL LETTER A ",&h41," 41"),_
  Array("LATIN SMALL LETTER O WITH DIAERESIS ",&hF6," C3 B6"),_
  Array("CYRILLIC CAPITAL LETTER ZHE ",&h416," D0 96"),_
  Array("EURO SIGN",&h20AC," E2 82 AC "),_
  Array("MUSICAL SYMBOL G CLEF ",&h1D11E," F0 9D 84 9E"))

check 0
check 1
check 2
check 3
check 4
