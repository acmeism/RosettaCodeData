/*REXX program to compute a sampling of  combinations and permutations. */
numeric digits 100                     /*use hundred digits of precision*/

    do j=1  to  12                     /*show permutations from 1──► 12 */
    _=;  do k=1  to  j                 /*step through all J permutations*/
         _=_ 'P('j","k')='perm(j,k)" " /*add an extra blank between #s. */
         end   /*k*/
    say strip(_)                       /*show a horizontal line of PERMs*/
    end           /*j*/
say
    do j=10  to  60  by 10             /*show some combinations 10──► 60*/
    _=;  do k=1  to  j  by j%5         /*step through some combinations.*/
         _=_ 'C('j","k')='comb(j,k)" " /*add an extra blank between #s. */
         end   /*k*/
    say strip(_)                       /*show a horizontal line of COMBs*/
    end           /*j*/
say
numeric digits 20                      /*force floating point for big #s*/

    do j=5  to 15000  by 1000          /*show a few permutations, big #s*/
    _=;  do k=1  to  j  by j%10  for 5 /*go through some J permutations.*/
         _=_ 'P('j","k')='perm(j,k)" " /*add an extra blank between #s. */
         end   /*k*/
    say strip(_)                       /*show a horizontal line of PERMs*/
    end           /*j*/
say
    do j=100  to 1000  by 100          /*show a few combinations, big #s*/
    _=;  do k=1  to  j  by j%5         /*step through some combinations.*/
         _=_ 'C('j","k')='comb(j,k)" " /*add an extra blank between #s. */
         end   /*k*/
    say strip(_)                       /*show a horizontal line of COMBs*/
    end           /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────COMB subroutine─────────────────────*/
comb: procedure;   parse arg x,y       /*args:  X  things,  Y at-a-time.*/
if y>x    then return 0                /*oops-say, to big a chunk.      */
if x=y    then return 1                /* X things same as chunk size.  */
if x-y<y  then y=x-y                   /*switch things around for speed.*/
call .cmbPrm                           /*call sub to do heavy lifting.  */
return _/!(y)                          /*perform one last division.     */
/*──────────────────────────────────PERM subroutine─────────────────────*/
perm: procedure;   parse arg x,y;      call .cmbPrm;              return _
/*──────────────────────────────────.CMBPRM sugroutine──────────────────*/
.cmbPrm:   _=1;    do j=x-y+1  to x;   _=_*j;   end;              return _
/*──────────────────────────────────! subroutine────────────────────────*/
!: procedure; parse arg x; !=1;   do j=2  to x;  !=!*j;  end;     return !
