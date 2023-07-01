/*REXX program shows ranges of numbers with ordinal (st/nd/rd/th) suffixes attached.*/
Call tell 0,25                      /* display the  1st  range of numbers  */
Call tell 250,265                   /* "       "    2nd    "    "    "     */
Call tell 1000,1025                 /* "       "    3rd    "    "    "     */
Exit                                /* stick a fork in it,  we're all done */
/*-------------------------------------------------------------------------*/
tell: Procedure
  Parse Arg low,high                /* get the Low and High numbers        */
  out.=''
  Do n=low To high                  /* process the range, from low         */
    out.1=out.1 th(n)
    out.2=out.2 th2(n)
    out.3=out.3 th3(n)
    End
  Say 'numbers from' low 'to' high '(inclusive):' /*display the output     */
  Say strip(out.1)
  Say ''
  If out.2<>out.1 Then Say 'th2 must be wrong'
  If out.3<>out.1 Then Say 'th3 must be wrong'
  Return
/*-------------------------------------------------------------------------*/
th:                                 /* compact original                    */
  Parse Arg z
  x=abs(z)
  Return z||word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
/*-------------------------------------------------------------------------*/
th2:                                /* rather verbose logic                */
  Parse Arg z
  x=abs(z)
  Select
    When length(x)=1 Then
      If x<4 Then
        suffix=word('th st nd rd',x+1)
      Else
        suffix='th'
    When suffixstr(x,length(x)-1,1)=1 Then
      suffix='th'
    When right(x,1)<4 Then
      suffix=word('th st nd rd',right(x,1)+1)
    Otherwise
      suffix='th'
    End
  Return z||suffix
/*-------------------------------------------------------------------------*/
th3:                                /* compact yet quite readable          */
  Parse Arg z
  Parse Value reverse(z) with last +1 prev +1
  If last<4 &,                      /* last digit is 0,1,2,3               */
     prev<>1 Then                   /* and number is not **1x              */
    suffix=word('th st nd rd',last+1)
  Else                              /* all oher cases                      */
    suffix='th'
  Return z||suffix
