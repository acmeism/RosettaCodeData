/*REXX program finds the  longest  greatest continuous subsequence  sum.      */
parse arg @;         w=words(@)        /*get arg list;  number words in list. */
say 'words='w    "   list="@           /*show number words & LIST to terminal,*/
sum=0;  L=0;  at=w+1                   /*default sum, length, and "starts at".*/
                                       /* [↓]  process the list of numbers.   */
  do j=1  for w;     f=word(@,j)       /*select one number at a time from list*/
      do k=j  to w;  _=k-j+1;     s=f  /* [↓]  process a sub─list of numbers. */
                     do m=j+1  to k;   s=s+word(@,m);    end  /*m*/
      if (s==sum & _>L)  |  s>sum  then do;  sum=s;   at=j;    L=_;    end
      end   /*k*/                      /* [↑]  chose the longest greatest sum.*/
  end       /*j*/

$=subword(@,at,L);    if $==''  then $="[NULL]"       /*Englishize the  null. */
say;  say 'sum='sum/1  "   sequence="$ /*stick a fork in it,  we're all done. */
