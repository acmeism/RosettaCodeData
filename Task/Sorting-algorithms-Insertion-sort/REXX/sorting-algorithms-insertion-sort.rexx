/*REXX program sorts a stemmed  array using the  insertion-sort  method.*/
call gen@                              /*generate the array's elements. */
call show@ 'before sort'               /*show the before array elements.*/
call insertionSort highItem            /*invoke the  insertion  sort.   */
call show@ ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@:   @.=                            /*assign default value to array. */
@.1 = "---Monday's Child Is Fair of Face  (by Mother Goose)---"
@.2 = "Monday's child is fair of face;"
@.3 = "Tuesday's child is full of grace;"
@.4 = "Wednesday's child is full of woe;"
@.5 = "Thursday's child has far to go;"
@.6 = "Friday's child is loving and giving;"
@.7 = "Saturday's child works hard for a living;"
@.8 = "But the child that is born on the Sabbath day"
@.9 = "Is blithe and bonny, good and gay."
   do highItem=1 while @.highItem\=='' /*find how many entries in array.*/
   end                                 /*short and sweet  DO  loop, eh? */
highItem=highItem-1                    /*because of DO, adjust highItem.*/
return
/*──────────────────────────────────INSERTIONSORT subroutine────────────*/
insertionSort: procedure expose @.;    parse arg highItem
            do i=2 to highItem;      value=@.i
                          do j=i-1  by -1   while  j\==0  &  @.j>value
                          jp=j+1;    @.jp=@.j
                          end    /*j*/
            jp=j+1
            @.jp=value
            end   /*i*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(highItem)         /*the maximum width of any line. */
                     do j=1  for highItem
                     say  'element'  right(j,widthH)  arg(1)': '    @.j
                     end   /*j*/
say copies('─',79)                     /*show a separator line that fits*/
return
