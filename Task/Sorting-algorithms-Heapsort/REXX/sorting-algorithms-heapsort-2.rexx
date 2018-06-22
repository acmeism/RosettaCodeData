/*REXX pgm sorts an array (names of epichoric Greek letters) using a heapsort algorithm.*/
parse arg g                                      /*obtain optional arguments from the CL*/
if g=''  then g='alpha beta gamma delta digamma epsilon zeta eta theta iota kappa lambda',
                "mu nu xi omicron pi san qoppa  rho sigma tau upsilon phi chi psi omega"
#=words(g);                     do i=1  for #;   @.i=word(g,i);   end   /*assign to @.  */
call show      "before sort:"
call heapSort     #;            say copies('▒', 40)                     /*sort; show sep*/
call show      " after sort:"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
heapSort: procedure expose @.; arg n;   do j=n%2 by -1 to 1;  call shuffle  j,n; end /*j*/
              do n=n  by -1  to 2;      _=@.1;   @.1=@.n;   @.n=_;    call shuffle  1, n-1
              end   /*n*/                        /* [↑]  swap two elements; and shuffle.*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
shuffle:  procedure expose @.;  parse arg i,n;    $=@.i                 /*obtain parent.*/
                                        do  while i+i<=n;        j=i+i;    k=j+1
                                        if k<=n    then  if  @.k>@.j  then j=k
                                        if $>=@.j  then leave;   @.i=@.j;  i=j
                                        end   /*while*/
          @.i=$;    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:     do s=1  for #;  say '    element' right(s, length(#)) arg(1) @.s;  end;   return
