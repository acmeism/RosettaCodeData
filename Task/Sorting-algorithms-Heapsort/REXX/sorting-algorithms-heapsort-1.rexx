/*REXX pgm sorts an array (names of epichoric Greek letters) using a heapsort algorithm.*/
@.=; @.1= 'alpha'  ;   @.7 = "zeta"  ;   @.13= 'mu'     ;  @.19= "qoppa"  ;  @.25= 'chi'
     @.2= 'beta'   ;   @.8 = "eta"   ;   @.14= 'nu'     ;  @.20= "rho"    ;  @.26= 'psi'
     @.3= 'gamma'  ;   @.9 = "theta" ;   @.15= 'xi'     ;  @.21= "sigma"  ;  @.27= 'omega'
     @.4= 'delta'  ;   @.10= "iota"  ;   @.16= 'omicron';  @.22= "tau"
     @.5= 'digamma';   @.11= "kappa" ;   @.17= 'pi'     ;  @.23= "upsilon"
     @.6= 'epsilon';   @.12= "lambda";   @.18= 'san'    ;  @.24= "phi"
                            do #=1  until @.#=='';  end;      #=# - 1  /*find # entries.*/
call show      "before sort:"
call heapSort        #;          say copies('▒', 40)                   /*sort; show sep.*/
call show      " after sort:"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
heapSort: procedure expose @.; arg n;   do j=n%2 by -1 to 1;  call shuffle  j,n; end /*j*/
              do n=n  by -1  to 2;       _=@.1;   @.1=@.n;   @.n=_;   call shuffle  1, n-1
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
show:     do s=1  for #;  say '    element' right(s, length(#)) arg(1) @.s;  end;   return
