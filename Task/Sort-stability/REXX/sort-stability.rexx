/*REXX program sorts an array using a  (stable)  bubble-sort  algorithm.*/
call gen@                              /*generate the array elements.   */
call show@  'before sort'              /*show the before array elements.*/
call bubbleSort   #                    /*invoke the bubble sort.        */
call show@  ' after sort'              /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BUBBLESORT subroutine───────────────*/
bubbleSort: procedure expose @.; parse arg n      /*N:  number of items.*/
                                       /*diminish # items each time.    */
       do  until done                  /*sort until it's done.          */
       done=1                          /*assume it's done   (1 ≡ true). */
             do j=1  for n-1           /*sort M items this time around. */
              k=j+1                    /*point to the next item.        */
              if @.j>@.k  then do      /*is it out of order?            */
                               _=@.j   /*assign to a temp variable.     */
                               @.j=@.k /*swap current item with next ···*/
                               @.k=_   /*      ··· and the next with  _ */
                               done=0  /*indicate it's not done, whereas*/
                               end     /*  [↑]      1≡true      0≡false */
              end   /*j*/
       end          /*until*/
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.  =                            /*assign default value to all @. */
      @.1 = 'UK  London'
      @.2 = 'US  New York'
      @.3 = 'US  Birmingham'
      @.4 = 'UK  Birmingham'

             do #=1  while  @.# \==''  /*find how many entries in list. */
             end   /*#*/
#=#-1                                  /*adjust because of DO increment.*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:              do j=1  for #      /* [↓]  display all list elements*/
                    say '      element'  right(j,length(#)) arg(1)':'  @.j
                    end   /*j*/
say copies('■',50)                     /*show a separator line.         */
return
