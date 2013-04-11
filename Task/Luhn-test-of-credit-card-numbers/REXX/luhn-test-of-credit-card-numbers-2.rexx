/* Rexx ***************************************************
* 09.04.2013 Walter Pachl
* Implements the task's description in a rather concise way
* Instead of reverting the ccn work it backwards
**********************************************************/
luhn:
Parse Arg ccn                /* credit card number       */
sum=0                        /* initialize test sum      */
even=0                       /* even indicator           */
Do i=length(ccn) To 1 By -1  /* process all digits       */
  c=substr(ccn,i,1)          /* pick one digit at a time */
  If even Then Do            /* even numbered digit      */
    c=c*2                    /* double it                */
    If c>=10 Then            /* 10, 12, 14, 16, 18       */
      c=c-9                  /* Sum of the two digits    */
    End                      /* end of even numbered     */
  even=\even                 /* flip even indicator      */
  sum=sum+c                  /* add into test sum        */
  End
Return right(sum,1)=0        /* ok if last digit is 0    */
