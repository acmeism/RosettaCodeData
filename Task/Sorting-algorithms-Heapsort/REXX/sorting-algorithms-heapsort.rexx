/*REXX program sorts an array using the   heapsort   method.            */
call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show the  before array elements*/
call heapSort highItem                 /*invoke the heap  sort.         */
call show@ ' after sort'               /*show tge   after array elements*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HEAPSORT subroutine─────────────────*/
heapSort:  procedure expose @.;  parse arg n

                                       do j=n%2  by -1  to 1
                                       call shuffle j,n
                                       end   /*j*/
          do n=n  by -1  to 2
          _=@.1;  @.1=@.n;  @.n=_;  call shuffle 1,n
          end   /*n*/
return
/*──────────────────────────────────SHUFFLE subroutine──────────────────*/
shuffle:  procedure expose @.;  parse arg i,n;  _=@.i

                    do  while i+i<=n
                    j=i+i;    k=j+1
                    if k<=n & @.k>@.j  then j=k
                    if _>=@.j          then leave
                    @.i=@.j;  i=j
                    end   /*while i+i<=n*/
@.i=_
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.=                              /*assign default value for array.*/
@.1 ='---letters of the modern Greek Alphabet---'     ;    @.14='mu'
@.2 ='=========================================='     ;    @.15='nu'
@.3 ='alpha'                                          ;    @.16='xi'
@.4 ='beta'                                           ;    @.17='omicron'
@.5 ='gamma'                                          ;    @.18='pi'
@.6 ='delta'                                          ;    @.19='rho'
@.7 ='epsilon'                                        ;    @.20='sigma'
@.8 ='zeta'                                           ;    @.21='tau'
@.9 ='eta'                                            ;    @.22='upsilon'
@.10='theta'                                          ;    @.23='phi'
@.11='iota'                                           ;    @.24='chi'
@.12='kappa'                                          ;    @.25='psi'
@.13='lambda'                                         ;    @.26='omega'

  do highItem=1  while @.highItem\=='' /*find how many entries.         */
  end  /*highitem*/

highItem=highItem-1                    /*adjust highItem slightly.      */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(highItem)         /*maximum width of any line.     */

                         do j=1  for highItem
                         say 'element' right(j,widthH) arg(1)':' @.j
                         end   /*j*/
say copies('-', 79)                    /*show a separator line.         */
return
