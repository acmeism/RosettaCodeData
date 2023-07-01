/*REXX program calculates/displays 20 pancake numbers (from 1 to 20,inclusive). */
/* Gerard Schildberger's code reformatted and refurbished                       */
pad=copies(' ',10)                                               /*indentation. */
Say pad center('pancakes',10    ) center('pancake flips',15)     /*show the hdr.*/
Say pad center(''        ,10,"-") center('',15,"-")              /*  "   "  sep.*/
Do pcn=1 To 20
  Say pad center(pcn,10) center(pancake(pcn),15)                 /*index,flips. */
  End
Exit                                      /*stick a fork in it, we're all done. */
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
