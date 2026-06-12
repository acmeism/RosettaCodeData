/*REXX program performs a   cycle sort   on a list of items  (could be numbers or text).*/
parse arg z                                      /*obtain optional arguments from the CL*/
if z='' then z= -3.14 3 1 4 1 5 9 2 6 5 3 5 8 9 7 9 3 2 3 8 4 6 2 6 4 3 3 8 3 2 7 9 5 0 2 8 8 4
say 'unsorted list: '  z                         /*show the original unsorted numbers.  */
w= sortCycle(z)                                  /*W:  the number of writes done in sort*/
say '  sorted list: '  y                         /*show the original unsorted numbers.  */
say 'and required '    w       " writes."        /*show number of writes done in sort.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sortCycle: procedure expose y; parse arg y;  #= words(y);  mv= 0   /*MV: moves or writes*/
              do i=1  for #;   @.i= word(y,i)    /*put each of the items ───► @.  array.*/
              end   /*i*/                        /* [↓]  find a  "cycle"  to rotate.    */
  do    c=1   for #;    x=@.c;         p= c      /*X  is the  item  being sorted.       */
     do j=c+1  to #;    if @.j<x  then p= p + 1  /*determine where to put X into array @*/
     end   /*j*/
  if p==c  then  iterate                         /*Is it there?  No, this ain't a cycle.*/
  call .putX                                     /*put  X  right after any dups;  swap. */
     do while p\==c;    p= c                     /*rotate the rest of the "cycle".      */
         do k=c+1  to #;  if @.k<x  then p= p+1  /*determine where to put this element. */
         end   /*k*/
     call .putX                                  /*put  X  right after any dups;  swap. */
     end    /*while p\==c*/
  end       /*c*/
y=@.1;  do m=2  for #-1; y=y @.m; end; return mv /*put the array back into the  Y  list.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
.putX: mv= mv+1;   do p=p  while x==@.p;  end;    parse value @.p x  with  x @.p;   return
