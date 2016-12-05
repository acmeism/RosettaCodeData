/*REXX program  finds and displays  the  shortest  greatest continuous subsequence  sum.*/
parse arg @;         w=words(@)                  /*get arg list;  number words in list. */
say 'words='w    "   list="@                     /*show number words & LIST to terminal.*/
sum=0;      at=w+1                               /*default sum, length, and "starts at".*/
L=0                                              /* [↓]  process the list of numbers.   */
     do j=1  for w;     f=word(@, j)             /*select one number at a time from list*/
         do k=j  to w;  s=f                      /* [↓]  process a sub─list of numbers. */
                        do m=j+1  to k;    s=s+word(@, m);    end  /*m*/
         if s>sum  then do;       sum=s;   at=j;  L=k-j+1;    end
         end   /*k*/                             /* [↑]  chose greatest sum of numbers. */
     end       /*j*/
say
$=subword(@,at,L);    if $==''  then $="[NULL]"  /*Englishize the  null  (value).       */
say 'sum='sum/1             "   sequence="$      /*stick a fork in it,  we're all done. */
