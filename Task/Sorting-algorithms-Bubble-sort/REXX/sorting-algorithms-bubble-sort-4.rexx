/*REXX program sorts an array (of any kind of numbers)  using the bubble─sort algorithm.*/
parse arg N seed .                               /*obtain optional size of array from CL*/
if N=='' | N==","       then N=30                /*Not specified?  Then use the default.*/
if datatype(seed, 'W')  then call random ,,seed  /*An integer?  Use the seed for RANDOM.*/
call gen    N                                    /*generate the array elements (items). */
call show        'before sort:'                  /*show the   before   array elements.  */
              $$= $                              /*keep "before" copy for after the sort*/
call bSort  N                                    /*invoke the bubble sort  with N items.*/
          say $$
call show        ' after sort:'                  /*show the   after    array elements.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bSort: procedure expose @.;  parse arg #         /*N: is the number of @ array elements.*/
       call disp                                 /*show a snapshot of the unsorted array*/
       do m=#-1  by -1  until ok;    ok=1        /*keep sorting the  @ array until done.*/
           do j=1  for m;   k=j+1
           if @.j>@.k  then do;     parse value    @.j  @.k  0      with      @.k  @.j  ok
                            end
           end   /*j*/                           /* [↑]  swap 2 elements, flag as ¬done.*/
       call disp                                 /*show snapshot of partially sorted @. */
       end       /*m*/;      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen:   do j=1  for N;  @.j= j;  end
       do k=1  for N;  g= random(1,N);  parse value @.k @.g  with  @.g @.k;  end;   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  parse arg $;  do k=1  for N;  $=$  right(@.k, length(N));  end;     say $;   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
disp:  'CLS';    $.=                             /*"CLS" is the command to clear screen.*/
                     do e=1  for #;         $.e= '│'overlay("☼", $.e, @.e);     end  /*e*/
                     do s=#  for #  by -1;  say $.s;                            end  /*s*/
       say "└"copies('─', #)                     /*display the horizontal axis at bottom*/
       return
