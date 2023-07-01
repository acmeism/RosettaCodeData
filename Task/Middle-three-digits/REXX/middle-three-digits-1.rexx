/* REXX ***************************************************************
* 03.02.2013 Walter Pachl
* 19.04.2013 mid 3 is now a function returning the middle 3 digits
*            or an error indication
**********************************************************************/
sl='123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345',
   '2 -1 -10 2002 -2002 0 abc 1e3 -17e-3'
Do While sl<>''                        /* loop through test values   */
  Parse Var sl s sl                    /* pick next value            */
  Say left(s,12) '->' mid3(s)          /* test it                    */
  End
Exit

mid3: Procedure
Parse arg d                            /* take the argument          */
Select                                 /* first test for valid input */
  When datatype(d)<>'NUM'   Then  Return 'not a number'
  When pos('E',translate(d))>0 Then  Return 'not just digits'
  When length(abs(d))<3     Then  Return 'less than 3 digits'
  When length(abs(d))//2<>1 Then  Return 'not an odd number of digits'
  Otherwise Do                         /* input is ok                */
    dx=abs(d)                          /* get rid of optional sign   */
    ld=length(dx)                      /* length of digit string     */
    z=(ld-3)/2                         /* number of digits to cut    */
    res=substr(dx,z+1,3)               /* get middle 3 digits        */
    End
  End
  Return res
