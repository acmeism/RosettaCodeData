/*REXX program finds the  shortest  greatest continous subsequence  sum.*/
arg @                                  /*get the arugment LIST (if any).*/
say 'words='words(@) '   list='@       /*show WORDS and LIST to console.*/
sum=word(@,1)                          /*a "starter" sum (of a sequence)*/
w=words(@)                             /*number of words in the list.   */
at=1                                   /*where the sequence starts at.  */
L=0                                    /*the length of the sequence.    */
                                       /*process the list.              */
   do j=1 for w;  f=word(@,j)
                               do k=j to w; s=f
                                                    do m=j+1 to k
                                                    s=s+word(@,m)
                                                    end   /*m*/
                               if s>sum then do; sum=s; at=j; L=k-j+1; end
                               end   /*k*/
   end   /*j*/

seq=subword(@,at,L);     if seq=='' then seq="[NULL]"
say;    say 'sum='word(sum 0,1)/1 "   sequence="seq
                                       /*stick a fork in it, we're done.*/
