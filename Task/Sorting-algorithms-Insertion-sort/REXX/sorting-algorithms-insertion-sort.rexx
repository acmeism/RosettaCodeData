/*REXX program sorts a stemmed array using the  insertion-sort algoritm.*/
call gen@                              /*generate the array's elements. */
call show@  'before sort'              /*show the before array elements.*/
call insertionSort  #                  /*invoke the  insertion  sort.   */
call show@  ' after sort'              /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@:   @.  =                          /*assign default value to array. */
        @.1 = "---Monday's Child Is Fair of Face (by Mother Goose)---"
        @.2 = "Monday's child is fair of face;"
        @.3 = "Tuesday's child is full of grace;"
        @.4 = "Wednesday's child is full of woe;"
        @.5 = "Thursday's child has far to go;"
        @.6 = "Friday's child is loving and giving;"
        @.7 = "Saturday's child works hard for a living;"
        @.8 = "But the child that is born on the Sabbath day"
        @.9 = "Is blithe and bonny, good and gay."

            do #=1  while  @.#\==''    /*find how many entries in array.*/
            end   /*#*/                /*short and sweet  DO  loop, eh? */
#=#-1                                  /*because of DO, adjust # entries*/
return
/*──────────────────────────────────INSERTIONSORT subroutine────────────*/
insertionSort: procedure expose @. #
            do i=2  to #
            value=@.i;        do j=i-1  by -1   while  j\==0  &  @.j>value
                              jp=j+1;           @.jp=@.j
                              end    /*j*/
            jp=j+1
            @.jp=value
            end   /*i*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:              do j=1  for #
                    say  'element'  right(j,length(#))   arg(1)': '    @.j
                    end   /*j*/
say copies('─',79)                     /*show a separator line that fits*/
return
