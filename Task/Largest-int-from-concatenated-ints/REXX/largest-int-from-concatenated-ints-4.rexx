/*REXX program constructs the largest integer from an integer list using concatenation.*/
l.='';    l.1 = '1 34 3 98 9 76 45 4'           /*the  1st  integer list to be used.   */
          l.2 = '54 546 548 60'                 /* "   2nd     "      "   "  "   "     */
          l.3 = ' 4  45  54  5'                 /* "   3rd     "      "   "  "   "     */
          l.4 = ' 4  45  54  5  6.6e77'         /* "   4th     "      "   "  "   "     */
          l.5 = ' 3 3 .2'                       /* "   5th     "      "   "  "   "     */
          l.6 = ' 4  45  54  5  6.6e1001'       /* "   6th     "      "   "  "   "     */
          l.7 = ' 4.0000 45 54 5.00'            /* "   7th     "      "   "  "   "     */
          l.8 = ' 10e999999999 5'               /* "   8th     "      "   "  "   "     */
l_length=0
Do li=1 By 1 While l.li<>''
  l_length=max(l_length,length(space(l.li)))
  End

Do li=1 By 1 While l.li<>''
  z=''
  msg=''
  Do j=1 To words(l.li)
    int=integer(word(l.li,j))
    If int='?' Then Do
      Say left(space(l.li),l_length) '-> ** invalid ** bad list item:' word(l.li,j) msg
      Iterate li
      End
    Else
      z=z int
    End
  zz=largeint(z)
  If length(zz)<60 Then
    Say left(space(l.li),l_length) '->' zz
  Else
    Say left(space(l.li),l_length) '->' left(zz,5)'...'right(zz,5)
  End
Exit

integer: Procedure Expose msg
Numeric Digits 1000
Parse Arg z
If Datatype(z,'W') Then
  Return z/1
Else Do
  If Datatype(z,'NUM') Then Do
    Do i=1 To 6 Until dig>=999999999
      dig= digits()*10
      dig=min(dig,999999999)
      Numeric Digits dig
      If Datatype(z,'W') Then
        Return z/1
      End
    msg='cannot convert it to an integer'
    Return '?'
    End
  Else Do
    msg='not a number (larger than what this REXX can handle)'
    Return '?'
    End
  End

largeint: Procedure
Parse Arg list
w.0=words(list)
Do i=1 To w.0
  w.i=word(list,i)
  End
Do wx=1 To w.0-1
  Do wy=wx+1 To w.0
    xx=w.wx
    yy=w.wy
    xy=xx||yy
    yx=yy||xx
    if xy < yx then do
      /* swap xx and yy */
      w.wx = yy
      w.wy = xx
      end
    End
  End
list=''
Do ww=1 To w.0
  list=list w.ww
  End
Return space(list,0)
