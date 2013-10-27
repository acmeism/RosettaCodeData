/*REXX program sorts an array using the   heapsort   method.            */
call gen@                              /*generate the array elements.   */
call show@  'before sort'              /*show the  before array elements*/
call heapSort  highItem                /*invoke the heap  sort.         */
call show@  ' after sort'              /*show tge   after array elements*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HEAPSORT subroutine─────────────────*/
heapSort:  procedure expose @.;  parse arg n;        do j=n%2  by -1  to 1
                                                     call shuffle j,n
                                                     end   /*j*/
       do n=n  by -1  to 2
       _=@.1;  @.1=@.n;  @.n=_;  call shuffle 1,n-1  /*swap and shuffle.*/
       end   /*n*/
return
/*──────────────────────────────────SHUFFLE subroutine──────────────────*/
shuffle:  procedure expose @.;  parse arg i,n;  _=@.i
                                      do  while i+i<=n;    j=i+i;    k=j+1
                                      if k<=n  then  if  @.k>@.j  then j=k
                                      if _>=@.j          then leave
                                      @.i=@.j;  i=j
                                      end   /*while i+i≤n*/
@.i=_
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.=                              /*assign default value for array.*/
@.1  = '---modern Greek alphabet letters---'
@.2  =  copies('=', length(@.1))
@.3  = 'alpha'         ;   @.11 = 'iota'              ;   @.19 = 'rho'
@.4  = 'beta'          ;   @.12 = 'kappa'             ;   @.20 = 'sigma'
@.5  = 'gamma'         ;   @.13 = 'lambda'            ;   @.21 = 'tau'
@.6  = 'delta'         ;   @.14 = 'mu'                ;   @.22 = 'upsilon'
@.7  = 'epsilon'       ;   @.15 = 'nu'                ;   @.23 = 'phi'
@.8  = 'zeta'          ;   @.16 = 'xi'                ;   @.24 = 'chi'
@.9  = 'eta'           ;   @.17 = 'omicron'           ;   @.25 = 'psi'
@.10 = 'theta'         ;   @.18 = 'pi'                ;   @.26 = 'omega'
   do highItem=1  while @.highItem\==''; end   /*find how many entries. */
highItem=highItem-1                    /*adjust   highItem   slightly.  */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:               do j=1  for highItem
                     say 'element' right(j,length(highItem)) arg(1)':' @.j
                     end   /*j*/
say copies('─', 79)                    /*show a separator line.         */
return
