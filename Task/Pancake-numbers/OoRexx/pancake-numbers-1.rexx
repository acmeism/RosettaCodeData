/*REXX program calculates/displays 20 pancake numbers (from 1 to 20,inclusive). */
ol=''
Do pcn=1 To 20
  ol=ol 'p('format(pcn,2)') ='format(pancake(pcn),3)' '
  If pcn//5=0 Then Do
    Say strip(ol)
    ol=''
    End
  End
Exit
/*------------------------------------------------------------------------------*/
pancake: Procedure
  Parse Arg n                            /* obtain  N                           */
  gap= 2                                 /* initialize the GAP.                 */
  sum= 2                                 /* initialize the SUM.                 */
  Do adj=0 While sum <n                  /* perform while  SUM is less than  N. */
    gap= gap*2 - 1                       /* calculate the GAP.                  */
    sum= sum + gap                       /* add the  GAP  to the  SUM.          */
    End   /*adj*/
  Return n +adj -1                       /* return an adjusted adjustment sum.  */
