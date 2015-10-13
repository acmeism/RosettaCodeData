/*REXX program finds the  best shuffle  (for any list of words (characters).  */
parse arg @                            /*get some words from the command line.*/
if @=''  then @ = 'tree abracadabra seesaw elk grrrrrr up a'   /*use default? */
w=0                                    /*width of the longest word; for output*/
        do i=1  for words(@)           /* [↓]  process all the words in list. */
        w=max(w, length(word(@, i)))   /*set the maximum word width (so far). */
        end   /*i*/                    /* [↑]  ··· finds the widest word in @.*/
w=w+9                                  /*add 9 blanks, the output looks nicer.*/
        do n=1  for words(@)           /*process all the words in the @ list. */
        $=word(@,n)                    /*get the original word in the @ list. */
        new=bestShuffle($)             /*get a shufflized version of the word.*/
        say 'original:'  left($,w)   'new:'  left(new,w)  'count:'  kSame($,new)
        end   /*n*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────BESTSHUFFLE subroutine────────────────────*/
bestShuffle: procedure;    parse arg x 1 ox;    Lx=length(x)
if Lx<3 then return reverse(x)         /*fast track these small # of puppies. */

   do j=1  for Lx-1;           jp=j+1  /* [↓]  handle any possible replicates.*/
   a=substr(x,j  ,1)
   b=substr(x,j+1,1);          if a\==b then iterate      /*ignore replicates.*/
   _=verify(x,a); if _==0 then iterate /*switch 1st replicate with some char. */
   y=substr(x,_,1);       x=overlay(a,x,_)
                          x=overlay(y,x,j)
   rx=reverse(x); _=verify(rx,a); if _==0 then iterate    /*¬enough uniqueness*/
   y=substr(rx,_,1);  _=lastpos(y,x)   /*switch 2nd replicate with later char.*/
   x=overlay(a,x,_); x=overlay(y,x,jp) /*OVERLAYs:  a fast way to swap chars. */
   end    /*j*/

           do k=1  for Lx              /*handle cases of possible replicates. */
           a=substr( x,k,1)
           b=substr(ox,k,1);    if a\==b  then iterate      /*skip replicate. */
           if k==Lx  then x=left(x,k-2)a || substr(x,k-1,1) /*handle last case*/
                     else x=left(x,k-1)substr(x,k+1,1)a || substr(x,k+2)
           end   /*k*/
return x
/*──────────────────────────────────KSAME procedure───────────────────────────*/
kSame: procedure;    parse arg x,y;       k=0
  do m=1  for min(length(x), length(y));  k=k + (substr(x,m,1) == substr(y,m,1))
  end   /*m*/
return k
