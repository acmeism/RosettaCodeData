/*REXX program to find the best shuffle  (for a character string).      */
parse arg list                         /*get words from the command line*/
if list='' then list='tree abracadabra seesaw elk grrrrrr up a'  /*def.?*/
w=0                                    /*widest word , for prettifing.  */
        do i=1  for words(list)
        w=max(w,length(word(list,i)))  /*the maximum word width so far. */
        end   /*i*/
w=w+5                                  /*add five spaces to widest word.*/
        do n=1  for words(list)        /*process the words in the list. */
        $=word(list,n)                 /*the original word in the list. */
        new=bestShuffle($)             /*shufflized version of the word.*/
        say 'original:' left($,w) 'new:' left(new,w) 'count:' kSame($,new)
        end   /*n*/
exit                                   /*stick a fork in it, we're done.*/
/*ââââââââââââââââââââââââââââââââââBESTSHUFFLE subroutineââââââââââââââ*/
bestShuffle: procedure;    parse arg x 1 ox;    Lx=length(x)
if Lx<3 then return reverse(x)         /*fast track these puppies.      */

   do j=1  for Lx-1                    /*first take care of replications*/
   a=substr(x,j  ,1)
   b=substr(x,j+1,1);          if a\==b then iterate
   _=verify(x,a); if _==0 then iterate /*switch 1st rep with some char. */
   y=substr(x,_,1);      x=overlay(a,x,_)
                         x=overlay(y,x,j)
   rx=reverse(x); _=verify(rx,a); if _==0 then iterate   /*Â¬ enuf unique*/
   y=substr(rx,_,1);  _=lastpos(y,x)   /*switch 2nd rep with later char.*/
   x=overlay(a,x,_);  x=overlay(y,x,j+1)  /*OVERLAYs: a fast way to swap*/
   end    /*j*/

           do k=1  for Lx              /*take care of same o'-same o's. */
           a=substr(x, k,1)
           b=substr(ox,k,1);   if a\==b then iterate
           if k==Lx then x=left(x,k-2)a || substr(x,k-1,1)   /*last case*/
                    else x=left(x,k-1)substr(x,k+1,1)a || substr(x,k+2)
           end   /*k*/
return x
/*ââââââââââââââââââââââââââââââââââKSAME procedureâââââââââââââââââââââ*/
kSame: procedure;    parse arg x,y;    k=0
                  do m=1  for min(length(x),length(y))
                  k=k + (substr(x,m,1) == substr(y,m,1))
                  end   /*m*/
return k
