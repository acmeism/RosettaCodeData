/*REXX program sorts an  array  using the   count─sort   algorithm.           */
$=1 3 6 2 7 13 20 12 21 11 22 10 23 9 24 8 25 43 62 42 63 41 18 42 17 43 16 44 15 45 14 46 79 113 78 114 77 39 78 38
#=words($);  w=length(#);        do i=1  for #
                                 @.i=word($,i)  /*get a Recaman # from a list.*/
                                 end   /*i*/
call show 'before sort: '              /*show the   before   array elements.  */
say  copies('▒',55)                    /*show a pretty separator line.        */
call countSort  #                      /*sort a number of entries of @. array.*/
call show ' after sort: '              /*show the    after   array elements.  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
countSort: procedure expose @.;     parse arg N;    L=@.1;    h=L;   _.=0;   x=1
       do j=1  for N; z=@.j;  _.z=_.z+1;  L=min(L,@.j); h=max(h,@.j);  end /*j*/
       do k=L  to  h;    do x=x for _.k;  @.x=k;        end /*x*/;     end /*k*/
return
/*────────────────────────────────────────────────────────────────────────────*/
show: do s=1  for #;  say right("element",20) right(s,w) arg(1) @.s; end; return
