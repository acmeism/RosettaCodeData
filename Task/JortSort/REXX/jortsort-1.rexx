/*REXX program  verifies  that  an array  is sorted  using  a   jortSort   algorithm.   */
parse arg $                                      /*obtain the list of numbers from C.L. */
if $=''  then $=1 2 4 3                          /*Not specified?  Then use the default.*/
say 'array items='  space($)                     /*display the list to the terminal.    */
if jortSort($)  then say  'The array is sorted.'
                else say  "The array isn't sorted."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort:    procedure expose @.;                    h=@.0       /*exchange sort.*/
                    do while h>1;                 h=h%2
                      do i=1  for @.0-h;          j=i;      k=h+i
                        do  while @.k<@.j;        t=@.j;    @.j=@.k;    @.k=t
                        if h>=j  then leave;      j=j-h;    k=k-h
                        end   /*while @.k<@.j*/
                      end     /*i*/
                    end       /*while h>1*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
jortSort: parse arg x;   @.0=words(x)                         /*assign # items in list. */
                      do j=1  for @.0; !.j=word(x,j); @.j=!.j /*save a copy of original.*/
                      end   /*j*/
          call eSort                                          /*sort with exchange sort.*/
                      do k=1  for @.0
                      if !.k\==@.k  then return 0             /*the array isn't sorted. */
                      end   /*k*/
          return 1                                            /*the array is    sorted. */
