/*REXX program determines and displays the best shuffle for any list of words/characters*/
parse arg $                                      /*get some words from the command line.*/
if $=''  then $= 'tree abracadabra seesaw elk grrrrrr up a'          /*use the defaults?*/
w=0;                #=words($)                   /* [↑]  finds the widest word in $ list*/
        do i=1  for #;  @.i=word($,i);  w=max(w, length(@.i)  );     end  /*i*/
w=w+9                                            /*add 9 blanks for output indentation. */
        do n=1  for #;  new=bestShuffle(@.n)     /*process the examples in the @ array. */
        same=0;                    do m=1  for length(@.n)
                                   same=same  +  (substr(@.n, m, 1) == substr(new, m, 1) )
                                   end   /*m*/
        say 'original:'  left(@.n, w)   'new:'   left(new,w)    'count:'   same
        end   /*n*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bestShuffle: procedure; parse arg x 1 ox;    L=length(x);   if L<3  then return reverse(x)
                                                             /*[↑] fast track short strs*/
                do j=1  for L-1;  parse var x =(j) a +1 b +1 /*get A,B at Jth & J+1 pos.*/
                if a\==b  then iterate                       /*ignore any replicates.   */
                c=verify(x,a);    if c==0  then iterate      /*   "    "      "         */
                x=overlay( substr(x,c,1), overlay(a,x,c), j) /*swap the  x,c  characters*/
                rx=reverse(x)                                /*obtain the reverse of X. */
                y=substr(rx, verify(rx,a), 1)                /*get 2nd replicated char. */
                x=overlay(y, overlay(a,x, lastpos(y,x)),j+1) /*fast swap of 2 characters*/
                end   /*j*/
                             do k=1  for L;  a=substr(x,k,1) /*handle a possible rep.   */
                             if a\==substr(ox,k,1)  then iterate /*skip non-replications*/
                             if k==L  then x=left(x,k-2)a || substr(x,k-1,1) /*last case*/
                                      else x=left(x,k-1)substr(x,k+1,1)a || substr(x, k+2)
                             end   /*k*/
             return x
