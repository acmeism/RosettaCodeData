/*REXX pgm sorts a random list of words using the strand sort algorithm.*/
parse arg size minv maxv,old           /*get options from command line. */
if size==''  then size=20              /*no size?  Then use the default.*/
if minv==''  then minv=0               /*no minV?    "   "   "     "    */
if maxv==''  then maxv=size            /*no maxV?    "   "   "     "    */
                            do i=1  for size    /*generate random # list*/
                            old=old  random(0,maxv-minv)+minv
                            end  /*i*/
old=space(old)                         /*remove any extraneous blanks.  */
say center('unsorted list',length(old),"─");    say old;    say
new=strand_sort(old)                   /*sort the list of random numbers*/
say center('sorted list'  ,length(new),"─");    say new
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────STRAND_SORT subroutine──────────────*/
strand_sort:  procedure;    parse arg x;    y=
            do  while words(x)\==0;         w=words(x)
                     do j=1  for w-1   /*any number | word out of order?*/
                     if word(x,j)>word(x,j+1)  then do;  w=j;  leave;  end
                     end   /*j*/
            y=merge(y,subword(x,1,w));      x=subword(x,w+1)
            end            /*while*/
return y
/*──────────────────────────────────MERGE subroutine────────────────────*/
merge:  procedure;    parse arg a.1,a.2;    p=
   do forever                          /*keep at it while 2 lists exist.*/
     do i=1 for 2; w.i=words(a.i); end /*find number of entries in lists*/
   if w.1*w.2==0  then leave           /*if any list is empty, then stop*/
   if word(a.1,w.1) <= word(a.2,1) then leave    /*lists are now sorted?*/
   if word(a.2,w.2) <= word(a.1,1) then return space(p a.2 a.1)
   #=1+(word(a.1,1) >= word(a.2,1));  p=p word(a.#,1);  a.#=subword(a.#,2)
   end   /*forever*/
return space(p a.1 a.2)
