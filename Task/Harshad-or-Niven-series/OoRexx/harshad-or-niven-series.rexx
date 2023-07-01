/* REXX ---------------------------------------------------------------
* 21.01.2014 Walter Pachl modi-(simpli-)fied from REXX version 1
*--------------------------------------------------------------------*/
  Parse Arg x y .                   /* get optional arguments:  X  Y */
  If x='' Then x=20                 /* Not specified?  Use default   */
  If y='' Then y=1000               /* "      "        "     "       */
  n=0                               /* Niven count                   */
  nl=''                             /* Niven list.                   */

  Do j=1 Until n=x                  /* let's go Niven number hunting.*/
    If j//sumdigs(j)=0 Then Do      /* j is a Niven number           */
      n=n+1                         /* bump Niven count              */
      nl=nl j                       /* add to list.                  */
      End
    End

  Say 'first' n 'Niven numbers:'nl

  Do j=y+1                          /* start with first candidate    */
    If j//sumdigs(j)=0 Then         /* j is a Niven number           */
      Leave
    End

  Say 'first Niven number >' y 'is:' j
  Exit

sumdigs: Procedure                  /* compute sum of n's digits     */
  Parse Arg n
  sum=left(n,1)
  Do k=2 To length(n)
    sum=sum+substr(n,k,1)
    End
  Return sum
