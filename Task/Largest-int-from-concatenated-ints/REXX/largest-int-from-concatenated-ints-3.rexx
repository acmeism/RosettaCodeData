/*REXX program constructs the largest integer  from an integer list using concatenation.*/
l.='';    l.1 = '1 34 3 98 9 76 45 4'   /*the  1st  integer list to be used.   */
          l.2 = '54 546 548 60'             /* "   2nd     "      "   "  "   "     */
          l.3 = ' 4  45  54  5'             /* "   3rd     "      "   "  "   "     */
          l.4 = ' 4  45  54  5  6.6e77'    /* "   4th     "      "   "  "   "     */
          l.5 = ' 3 3 .2'                  /* "   5th     "      "   "  "   "     */
/*
soll.1=998764543431
soll.2=6054854654
soll.3=554454
soll.4=660000000000000000000000000000000000000000000000000000000000000000000000000000545454
*/
l_length=0
Do li=1 By 1 While l.li<>''
  l_length=max(l_length,length(space(l.li)))
  End

Do li=1 By 1 While l.li<>''
  z=''
  Do j=1 To words(l.li)
    int=integer(word(l.li,j))
    If int='?' Then Do
      Say left(space(l.li),l_length) '-> ** invalid ** bad integer' word(l.li,j)
      Iterate li
      End
    Else
      z=z int
    End
/*Say copies(' ',l_length) '  ' soll.li */
  Say left(space(l.li),l_length) '->' largeint(l.li)
  End
Exit

integer: Procedure
Numeric Digits 1000
Parse Arg z
If Datatype(z,'W') Then
  Return z+0
Else
  Return '?'

largeint:
result=''
Do While z<>''                                 /* [?]  check the rest of the integers.*/
  big=word(z,1); index=1; LB=length(big)       /*assume that first integer is biggest.*/
  do k=2 to words(z);
    n=word(z,k)                                /*obtain an integer from the list.     */
    L=max(LB,length(n))                        /*get the maximum length of the integer*/
    if left(n,L,left(n,1))<<=left(big,L,left(big,1)) then iterate
    big=n; index=k                             /*we found a new biggie (and the index)*/
    LB=length(big)
    End   /*k*/
  z=delword(z,index,1)                         /*delete this maximum integer from list*/
  result=result||big                           /*append   "     "       "    ---?  $. */
  end     /*while z*/                          /* [?]  process all integers in a list.*/
Return result
