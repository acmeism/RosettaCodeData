/*REXX program  finds and displays  the  longest  greatest continuous subsequence  sum. */
parse arg @;         w= words(@);      p= w + 1  /*get arg list;  number words in list. */
say 'words='w    "   list="@                     /*show number words & LIST to terminal,*/
     do #=1  for w;  @.#= word(@, #);  end       /*build an array for faster processing.*/
L=0;                    sum= 0                   /* [↓]  process the list of numbers.   */
     do j=1  for w                               /*select one number at a time from list*/
         do k=j  to w;  _= k-j+1;    s= @.j      /* [↓]  process a sub─list of numbers. */
                                         do m=j+1  to k;     s= s + @.m;        end  /*m*/
         if (s==sum & _>L) | s>sum  then do;       sum= s;   p= j;      L= _;   end
         end   /*k*/                             /* [↑]  chose the longest greatest sum.*/
     end       /*j*/
say
$= subword(@,p,L);   if $==''  then $= "[NULL]"  /*Englishize the  null   (value).      */
say 'sum='sum/1            "   sequence="$       /*stick a fork in it,  we're all done. */
