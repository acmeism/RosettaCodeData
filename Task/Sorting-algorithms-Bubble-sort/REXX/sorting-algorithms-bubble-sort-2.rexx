/*REXX program sorts an array (of any kind of numbers)  using the bubble─sort algorithm.*/
parse arg N .;   if N=='' | N==","  then N=30    /*obtain optional size of array from CL*/
call gen  N                                      /*generate the array elements (items). */
call show        'before sort:'                  /*show the   before   array elements.  */
call bSort  N                                    /*invoke the bubble sort  with N items.*/
call show        ' after sort:'                  /*show the   after    array elements.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bSort: procedure expose @.;  parse arg n         /*N: is the number of @ array elements.*/
       do m=n-1  by -1  until ok;     ok=1       /*keep sorting the  @ array until done.*/
           do j=1  for m;   k=j+1;  if @.j>@.k  then parse value @.j @.k 0 with @.k @.j ok
           end   /*j*/                           /* [↑]  swap 2 elements, flag as ¬done.*/
       end       /*m*/;      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen:   h=min(N+N,1e5);  w=length(h);      do j=1  for N;  @.j=random(h);  end;      return
show:  parse arg $;  do k=1  for N;  $=$  right(@.k, w);         end;     say $;    return
