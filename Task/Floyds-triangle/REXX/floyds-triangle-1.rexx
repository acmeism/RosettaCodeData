/* REXX ***************************************************************
* Parse Arg rowcount
* 12.07.2012 Walter Pachl  - translated from Python
**********************************************************************/
Parse Arg rowcount
col=0
ll=''                               /* last line of triangle         */
Do j=rowcount*(rowcount-1)/2+1 to rowcount*(rowcount+1)/2
  col=col+1                         /* column number                 */
  ll=ll j                           /* build last line               */
  len.col=length(j)                 /* remember length of column     */
  End
Do i=1 To rowcount-1                /* now do and output the rest    */
  ol=''
  col=0
  Do j=i*(i-1)/2+1 to i*(i+1)/2     /* elements of line i            */
    col=col+1
    ol=ol right(j,len.col)          /* element in proper length      */
    end
  Say ol                            /* output ith line               */
  end
Say ll                              /* output last line              */
