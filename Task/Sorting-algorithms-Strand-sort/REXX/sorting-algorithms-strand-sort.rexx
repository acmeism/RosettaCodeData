/*REXX program sorts a random list of words (or numbers) using the strand sort algorithm*/
parse arg size minv maxv old                     /*obtain optional arguments from the CL*/
if size=='' | size==","  then size=20            /*Not specified?  Then use the default.*/
if minv=='' | minv==","  then minv= 0            /*Not specified?  Then use the default.*/
if maxv=='' | maxv==","  then maxv=size          /*Not specified?  Then use the default.*/
               do i=1  for size                  /*generate a list of random numbers.   */
               old=old  random(0,maxv-minv)+minv /*append a random number to a list.    */
               end  /*i*/
old=space(old)                                   /*elide extraneous blanks from the list*/
          say center('unsorted list', length(old), "─");         say old
new=strand_sort(old)                             /*sort the list of the random numbers. */
say;      say center('sorted list'  , length(new), "─");         say new
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
strand_sort: procedure; parse arg x;                       y=
                          do  while words(x)\==0;          w=words(x)
                                 do j=1  for w-1                /*anything out of order?*/
                                 if word(x,j)>word(x,j+1)  then do;  w=j;  leave;  end
                                 end   /*j*/
                          y=merge(y,subword(x,1,w));       x=subword(x,w+1)
                          end            /*while*/
             return y
/*──────────────────────────────────────────────────────────────────────────────────────*/
merge:       procedure; parse arg a.1,a.2;    p=
                   do forever;  w1=words(a.1);  w2=words(a.2)   /*do while 2 lists exist*/
                   if w1==0 | if w2==0              then leave  /*Any list empty?  Stop.*/
                   if word(a.1,w1)  <= word(a.2,1)  then leave  /*lists are now sorted? */
                   if word(a.2,w2)  <= word(a.1,1)  then return space(p a.2 a.1)
                   #=1+(word(a.1,1) >= word(a.2,1));  p=p word(a.#,1);  a.#=subword(a.#,2)
                   end   /*forever*/
             return space(p a.1 a.2)
