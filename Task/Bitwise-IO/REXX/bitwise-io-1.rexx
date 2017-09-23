/* REXX ****************************************************************
* 01.11.2012 Walter Pachl
***********************************************************************/
s='STRING'                             /* Test input                  */
Say 's='s
ol=''                                  /* initialize target           */
Do While s<>''                         /* loop through input          */
  Parse Var s c +1 s                   /* pick a character            */
  cx=c2x(c)                            /* convert to hex              */
  cb=x2b(cx)                           /* convert to bits             */
  ol=ol||substr(cb,2)                  /* append to target            */
  End
l=length(ol)                           /* current length              */
lm=l//8
ol=ol||copies('0',8-lm)                /* pad to multiple of 8        */
pd=copies(' ',l)||copies('0',8-lm)
Say 'b='ol                             /* show target                 */
Say '  'pd 'padding'
r=''                                   /* initialize result           */
Do While length(ol)>6                  /* loop through target         */
  Parse Var ol b +7 ol                 /* pick 7 bits                 */
  b='0'||b                             /* add a leading '0'           */
  x=b2x(b)                             /* convert to hex              */
  r=r||x2c(x)                          /* convert to character        */
  End                                  /* and append to result        */
Say 'r='r                              /* show result                 */
