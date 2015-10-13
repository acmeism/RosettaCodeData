/*REXX program sorts a stemmed array using the  insertion sort  algorithm.    */
call gen                               /*generate the array's elements.       */
call show           'before sort'      /*display the  before  array elements. */
say copies('▒',79)                     /*display a separator line  (a fence). */
call insertionSort  #                  /*invoke the  insertion  sort.         */
call show           ' after sort'      /*display the   after  array elements. */
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────GEN subroutine────────────────────────────*/
gen:  @.=;        @.1 = "---Monday's Child Is Fair of Face (by Mother Goose)---"
                  @.2 = "Monday's child is fair of face;"
                  @.3 = "Tuesday's child is full of grace;"
                  @.4 = "Wednesday's child is full of woe;"
                  @.5 = "Thursday's child has far to go;"
                  @.6 = "Friday's child is loving and giving;"
                  @.7 = "Saturday's child works hard for a living;"
                  @.8 = "But the child that is born on the Sabbath day"
                  @.9 = "Is blithe and bonny, good and gay."
  do #=1  while @.#\==''; end;  #=#-1  /*determine how many entries in @ array*/
return
/*──────────────────────────────────INSERTIONSORT subroutine──────────────────*/
insertionSort: procedure expose @.;   parse arg #
        do i=2  to #;    $=@.i
                                      do j=i-1  by -1  while  j\==0  &  @.j>$
                                      _=j+1;           @._=@.j
                                      end   /*j*/
        _=j+1;       @._=$
        end   /*i*/
return
/*──────────────────────────────────SHOW subroutine───────────────────────────*/
show: do j=1 for #; say 'element' right(j,length(#)) arg(1)': ' @.j; end; return
