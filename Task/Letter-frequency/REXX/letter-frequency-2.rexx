/*REXX program counts the occurences of all characters in a file
* Adapted version 1 for TSO (EXECIO instead of linein)
* No translation to uppercase takes place
* There is no need for tails being hex
* 25.07.2012 Walter Pachl
***********************************************************************/

  Parse arg dsn .                    /*Data set to be processed       */
  if dsn='' Then                     /*none specified?                */
    dsn='PRIV.V100(TEST)'            /* Use default.                  */
  c.=0                               /* Character counts              */
  "ALLOC   FI(IN) DA("dsn") SHR REUSE"
  'EXECIO   * DISKR IN (STEM L. FINIS'
  'FREE   FI(IN)'
  totChars=0                         /*count of the total num of chars*/
  totLetters=0                       /*count of the total num letters.*/
  indent=left('',20)                 /*used for indentation of output.*/

  do j=1 to l.0                      /*process all lines              */
    rec=l.j                          /*take line number j             */
    Say '>'rec'<' length(rec)        /*that's in PRIV.V100(TEST)      */
    Say ' E8C44D8FF015674BCDEF'
    Say ' 61100711200000000002'
    do k=1 for length(rec)           /*loop over characters           */
      totChars=totChars+1            /*Increment total number of chars*/
      c=substr(rec,k,1)              /*get character number k         */
      c.c=c.c+1                      /*increment the character's count*/
      End
    End                              /*maybe we're ½ done by now, or ¬*/

  w=length(totChars)                 /*used for right-aligning counts.*/
  say 'file -----' dsn "----- has" j-1 'records.'
  say 'file -----' dsn "----- has" totChars 'characters.'

  do L=0 to 255                      /* display nonzero letter counts */
    c=d2c(l)                         /* the character in question     */
    if c.c>0 &,                      /* was found in the file         */
       datatype(c,'M')>0 Then Do     /* and is a Latin letter         */
      say indent "(Latin) letter " c 'count:' right(c.c,w) /* tell    */
      totLetters=totLetters+c.c      /* increment number of letters   */
      End
    End

  say 'file -----' dsn "----- has" totLetters '(Latin) letters.'
  say '                           other characters follow'
  other=0
  do m=0 to 255                      /* now for non-letters           */
    c=d2c(m)                         /* the character in question     */
    y=c2x(c)                         /* the hex representation        */
    if c.c>0 &,                      /* was found in the file         */
       datatype(c,'M')=0 Then Do     /* and is not a Latin letter     */
      other=other+c.c                /* increment count               */
      _=right(c.c,w)                 /* prepare output of count       */
      select                         /*make the character viewable.   */
       when c<<' ' | m==255 then say indent  "'"y"'x character count:" _
       when c==' '          then say indent   "blank character count:" _
       otherwise                 say indent "   " c 'character count:' _
       end
     end
   end
say 'file -----' dsn "----- has" other 'other characters.'
