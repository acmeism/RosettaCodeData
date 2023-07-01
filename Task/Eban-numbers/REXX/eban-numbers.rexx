/*REXX program to display eban numbers (those that don't have an "e" their English name)*/
numeric digits 20                                /*support some gihugic numbers for pgm.*/
parse arg $                                      /*obtain optional arguments from the cL*/
if $=''  then $= '1 1000   1000 4000   1 -10000   1 -100000   1 -1000000   1 -10000000'

      do k=1  by 2  to words($)                  /*step through the list of numbers.    */
      call banE  word($, k),  word($, k+1)       /*process the numbers, from low──►high.*/
      end   /*k*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
banE: procedure; parse arg x,y,_;  z= reverse(x) /*obtain the number to be examined.    */
      tell= y>=0                                 /*Is HI non-negative?  Display eban #s.*/
      #= 0                                       /*the count of  eban  numbers (so far).*/
           do j=x  to abs(y)                     /*probably process a range of numbers. */
           if hasE(j)  then iterate              /*determine if the number has an  "e". */
           #= # + 1                              /*bump the counter of  eban  numbers.  */
           if tell  then _= _  j                 /*maybe add to a list of eban numbers. */
           end   /*j*/
      if _\==''  then say strip(_)               /*display the list  (if there is one). */
      say;     say #   ' eban numbers found for: '   x   " "   y;     say copies('═', 105)
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
hasE: procedure; parse arg x;  z= reverse(x)     /*obtain the number to be examined.    */
        do k=1  by 3                             /*while there're dec. digit to examine.*/
        @= reverse( substr(z, k, 3) )            /*obtain 3 dec. digs (a period) from Z.*/
        if @=='   '           then return 0      /*we have reached the "end" of the num.*/
        uni= right(@, 1)                         /*get units dec. digit of this period. */
        if uni//2==1          then return 1      /*if an odd digit, then not an eban #. */
        if uni==8             then return 1      /*if an  eight,      "   "   "   "  "  */
        tens=substr(@, 2, 1)                     /*get tens  dec. digit of this period. */
        if tens==1            then return 1      /*if teens,        then not an eban #. */
        if tens==2            then return 1      /*if twenties,       "   "   "   "  "  */
        if tens>6             then return 1      /*if 70s, 80s, 90s,  "   "   "   "  "  */
        hun= left(@, 1)                          /*get hundreds dec. dig of this period.*/
        if hun==0             then iterate       /*if zero, then there is more of number*/
        if hun\==' '          then return 1      /*any hundrEd (not zero) has an  "e".  */
        end   /*k*/                              /*A "period" is a group of 3 dec. digs */
     return 0                                    /*in the number, grouped from the right*/
