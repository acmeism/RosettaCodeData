/*REXX program sorts an array (names of modern Greek letters) using a heapsort algorithm*/
@.=;  @.1='alpha'  ;    @.6 ="zeta" ;    @.11='lambda' ;    @.16="pi"    ;    @.21='phi'
      @.2='beta'   ;    @.7 ="eta"  ;    @.12='mu'     ;    @.17="rho"   ;    @.22='chi'
      @.3='gamma'  ;    @.8 ="theta";    @.13='nu'     ;    @.18="sigma" ;    @.23='psi'
      @.4='delta'  ;    @.9 ="iota" ;    @.14='xi'     ;    @.19="tau"   ;    @.24='omega'
      @.5='epsilon';    @.10="kappa";    @.15='omicron';    @.20="upsilon"
                            do #=1  while @.#\=='';  end;    #=#-1     /*find # entries.*/
call show      "before sort:"
call heapSort        #;          say copies('▒', 40)                   /*sort; show sep.*/
call show      " after sort:"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
heapSort: procedure expose @.; arg n;   do j=n%2 by -1 to 1;  call shuffle  j,n; end /*j*/
              do n=n  by -1  to 2;  _=@.1;  @.1=@.n;  @.n=_;  call shuffle  1,n-1
              end   /*n*/                        /* [↑]  swap two elements; and shuffle.*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
shuffle:  procedure expose @.;  parse arg i,n;    $=@.i                /*obtain parent. */
                                        do  while i+i<=n;        j=i+i;    k=j+1
                                        if k<=n    then  if  @.k>@.j  then j=k
                                        if $>=@.j  then leave;   @.i=@.j;  i=j
                                        end   /*while*/
          @.i=$;    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:     do e=1  for #;  say '    element' right(e,length(#)) arg(1) @.e;  end;    return
