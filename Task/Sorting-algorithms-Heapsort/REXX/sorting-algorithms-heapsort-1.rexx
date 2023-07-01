/*REXX pgm sorts an array (names of epichoric Greek letters) using a heapsort algorithm.*/
parse arg x;                 call init           /*use args or default,  define @ array.*/
call show     "before sort:"                     /*#:    the number of elements in array*/
call heapSort       #;       say copies('▒', 40) /*sort; then after sort, show separator*/
call show     " after sort:"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
init: _= 'alpha beta gamma delta digamma epsilon zeta eta theta iota kappa lambda mu nu' ,
                         "xi omicron pi san qoppa rho sigma tau upsilon phi chi psi omega"
      if x=''  then x= _;                 #= words(x)          /*#: number of words in X*/
            do j=1  for #;  @.j= word(x, j);  end;     return  /*assign letters to array*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
heapSort: procedure expose @.; arg n;  do j=n%2  by -1 to 1;  call shuffle  j,n; end /*j*/
            do n=n  by -1  to 2;    _= @.1;    @.1= @.n;    @.n= _;   call heapSuff 1,n-1
            end   /*n*/;           return        /* [↑]  swap two elements; and shuffle.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
heapSuff: procedure expose @.;  parse arg i,n;        $= @.i            /*obtain parent.*/
            do  while i+i<=n;   j= i+i;   k= j+1;     if k<=n  then  if @.k>@.j  then j= k
            if $>=@.j  then leave;      @.i= @.j;     i= j
            end   /*while*/;            @.i= $;       return            /*define lowest.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:     do s=1  for #;  say '    element' right(s, length(#)) arg(1) @.s;  end;   return
