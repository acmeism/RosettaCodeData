/*REXX program sorts an  array  using the   heapsort   algorithm.       */
call gen@                              /*generate the array elements.   */
call show@    'before sort'            /*show the  before array elements*/
call heapSort  #                       /*invoke the heap  sort.         */
call show@    ' after sort'            /*show the   after array elements*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HEAPSORT subroutine─────────────────*/
heapSort:  procedure expose @.;  parse arg n;        do j=n%2  by -1  to 1
                                                     call shuffle  j,n
                                                     end   /*j*/
       do n=n  by -1  to 2
       _=@.1;  @.1=@.n;  @.n=_;  call shuffle 1,n-1  /*swap and shuffle.*/
       end   /*n*/
return
/*──────────────────────────────────SHUFFLE subroutine──────────────────*/
shuffle:  procedure expose @.;  parse arg i,n;             _=@.i
                                      do  while i+i<=n;    j=i+i;    k=j+1
                                      if k<=n  then  if  @.k>@.j  then j=k
                                      if _>=@.j  then leave
                                      @.i=@.j;   i=j
                                      end   /*while*/
@.i=_
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.=;  @.1='---modern Greek alphabet letters---' /*default;  title.*/
            @.2= copies('=', length(@.1))             /*match sep with ↑*/
@.3='alpha'   ;     @.9 ='eta'   ;     @.15='nu'      ;     @.21='tau'
@.4='beta'    ;     @.10='theta' ;     @.16='xi'      ;     @.22='upsilon'
@.5='gamma'   ;     @.11='iota'  ;     @.17='omicron' ;     @.23='phi'
@.6='delta'   ;     @.12='kappa' ;     @.18='pi'      ;     @.24='chi'
@.7='epsilon' ;     @.13='lambd' ;     @.19='rho'     ;     @.25='psi'
@.8='zeta'    ;     @.14='mu'    ;     @.20='sigma'   ;     @.26='omega'

          do #=1  while @.#\==''; end  /*find how many entries in list. */
#=#-1                                  /*adjust   highItem   slightly.  */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:               do j=1  for #    /* [↓]  display elements in array.*/
                     say '      element'  right(j,length(#)) arg(1)':' @.j
                     end   /*j*/
say copies('■', 70)                    /*show a separator line.         */
return
