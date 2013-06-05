/* REXX **************************************************************
* While REXX can multiply arbitrary large integers
* here is the algorithm asked for by the task description
* 13.05.2013 Walter Pachl
*********************************************************************/
cnt.=0
Numeric Digits 100
Call test 123 123
Call test 12 12
Call test 123456789012 44444444444
Call test 2**64 2**64
Call test 0 0
say cnt.0ok 'ok'
say cnt.0nok 'not ok'
Exit
test:
  Parse Arg a b
  soll=a*b
  haben=multiply(a b)
  Say 'soll =' soll
  Say 'haben=' haben
  If haben<>soll Then
    cnt.0nok=cnt.0nok+1
  Else
    cnt.0ok=cnt.0ok+1
  Return

multiply: Procedure
/* REXX **************************************************************
* Multiply(a b) -> a*b
*********************************************************************/
  Parse Arg a b
  Call s2a 'a'
  Call s2a 'b'
  r.=0
  rim=1
  r0=0
  Do bi=1 To b.0
    Do ai=1 To a.0
      ri=ai+bi-1
      p=a.ai*b.bi
      Do i=ri by 1 Until p=0
        s=r.i+p
        r.i=s//10
        p=s%10
        End
      rim=max(rim,i)
      End
    End
  res=strip(a2s('r'),'L','0')
  If res='' Then
    res='0'
  Return res

s2a:
/**********************************************************************
* copy characters of a string into a corresponding array
* digits are numbered 1 to n fron right to left
**********************************************************************/
  Parse arg name
  string=value(name)
  lstring=length(string)
  do z=1 to lstring
    Call value name'.'z,substr(string,lstring-z+1,1)
    End
  Call value name'.0',lstring
  Return

a2s:
/**********************************************************************
* turn the array of digits into a string
**********************************************************************/
  call trace 'o'
  Parse Arg name
  ol=''
  Do z=rim To 1 By -1
    ol=ol||value(name'.z')
    End
  Return ol
