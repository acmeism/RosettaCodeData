/* REXX ***************************************************************
* 27.05.2013 Walter Pachl
**********************************************************************/
Numeric Digits 100
say center('input IP address'   ,30),
    center('hex IP address'     ,32),
    center('decimal IP address' ,39)         'space  port'

say copies(_,30) copies(_,32) copies(_,39) copies(_,5) copies(_,5) /*hdr*/
call expand '127.0.0.1'
call expand '127.0.0.1:80'
call expand '::1'
call expand '[::1]:80'
call expand '2605:2700:0:3::4713:93e3'
call expand '[2605:2700:0:3::4713:93e3]:80'
Say ' '
Say 'The following 2 are the same'
Call expand '2001:0db8:0:0:0:0:1428:57ab'
Call expand '2001:db8::1428:57ab'
Say ' '
Say 'The following 3 are all the same'
Call expand '2001:0db8:0:0:8d3:0:0:0'
Call expand '2001:db8:0:0:8d3::'
Call expand '2001:db8::8d3:0:0:0'
Exit

expand: Procedure
Parse Arg s
If pos('.',s)>0 Then
  Parse Value expand_ip4(s) With exp space port
Else
  Parse Value expand_ip6(s) With exp space port
Say left(s,30) right(exp,32) right(x2d(exp),39) right(space,5) right(port,5)
Return

expand_ip4: Procedure
Parse Arg s
If pos(':',s)>0 Then
  Parse Var s s ':' port
Else
  port=''
Do i=1 To 4
  Parse Var s a.i '.' s
  End
res=''
Do i=1 To 4
  res=res||d2x(a.i,2)
  End
Return res 'IPv4' port

expand_ip6: Procedure
/**********************************************************************
* Note: Doublecolon ('::') requires the inclusion of as many 0000
* tokens as necessary to result in 8 tokens
**********************************************************************/
Parse Arg s
If pos(']:',s)>0 Then
  Parse Var s '[' s ']:' port
Else
  port=''
sc=s
ii=0
Do i=1 To 8 While s<>''
  Parse Var s x.i ':' s
  If left(s,1)=':' Then Do
    ii=i
    s=substr(s,2)
    End
  End
n=i-1
ol=''
o2=''
Do i=1 To n
  ol=ol||right(x.i,4,'0')
  o2=o2||right(x.i,4,'0')
  If i=ii Then Do
    ol=ol||'----'
    Do j=1 To 8-n
      o2=o2||'0000'
      End
    End
  End
Return o2 'IPv6' port
