/*REXX program sorts an array using the  gnome-sort  method.            */
call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show  "before"  array elements.*/
call gnomeSort highItem                /*invoke the infamous gnome sort.*/
call show@ ' after sort'               /*show  "after"   array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────gnomeSORT subroutine─────────────*/
gnomeSort: procedure expose @.;   parse arg n;   k=2

           do j=3  while k<=n;         km=k-1
           if @.km<=@.k  then k=j
                         else do
                              _=@.km   /*swap two entries in the array. */
                              @.km=@.k
                              @.k=_
                              k=k-1;   if k==1  then k=j
                              end
           end    /*j*/
return
/*─────────────────────────────────────GEN@ subroutine──────────────────*/
gen@: @.=                              /*assign a default value (null). */
@.1='---the seven virtues---'
@.2='======================='
@.3='Faith'
@.4='Hope'
@.5='Charity  [Love]'
@.6='Fortitude'
@.7='Justice'
@.8='Prudence'
@.9='Temperance'
   do highItem=1 while @.highItem\=='' /*find how many entries in array.*/
   end                                 /*not much of a DO loop, eh?     */
highItem=highItem-1                    /*because of DO, adjust highItem.*/
return
/*─────────────────────────────────────SHOW@ subroutine─────────────────*/
show@: widthH=length(highItem)         /*the maximum width of any line. */
   do j=1 for highItem                 /*show and tell time for array.  */
   say  'element'  right(j,widthH)  arg(1)":"  @.j     /*make it pretty.*/
   end   /*j*/
say copies('─',60)                     /*show a separator line that fits*/
return
