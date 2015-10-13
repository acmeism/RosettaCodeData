/*REXX pgm sorts an array (modern Greek alphabet) using a heapsort algorithm. */
g = 'alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu nu xi',
    "omicron pi rho sigma tau upsilon phi chi psi omega"      /*adjust #  [↓] */
                            do #=1  for words(g);  @.#=word(g,#);  end;    #=#-1
call show      "before sort:"
call heapSort  #;                   say copies('▒',40)        /*sort; show sep*/
call show      " after sort:"
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
heapSort:  procedure expose @.;  parse arg n;        do j=n%2  by -1  to 1
                                                     call shuffle  j,n
                                                     end   /*j*/
           do n=n  by -1  to 2
           _=@.1;  @.1=@.n;  @.n=_;   call shuffle 1,n-1   /*swap and shuffle.*/
           end   /*n*/
return
/*────────────────────────────────────────────────────────────────────────────*/
shuffle:   procedure expose @.;  parse arg i,n;   $=@.i    /*obtain the parent*/
                 do  while i+i<=n;      j=i+i;    k=j+1
                 if k<=n  then  if  @.k>@.j  then j=k
                 if $>=@.j  then leave
                 @.i=@.j;   i=j
                 end   /*while*/
@.i=$;   return
/*────────────────────────────────────────────────────────────────────────────*/
show: do e=1 for #; say '    element' right(e,length(#)) arg(1) @.e; end; return
