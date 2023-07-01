/*REXX pgm displays a horizontal list of a  range of numbers  sorted  lexicographically.*/
parse arg LO HI INC .                            /*obtain optional arguments from the CL*/
if  LO=='' |  LO==","  then  LO=  1              /*Not specified?  Then use the default.*/
if  HI=='' |  HI==","  then  HI= 13              /* "      "         "   "   "     "    */
if INC=='' | INC==","  then INC=  1              /* "      "         "   "   "     "    */
#= 0                                             /*for actual sort, start array with  1.*/
                  do j=LO  to  HI  by  INC       /*construct an array from  LO   to  HI.*/
                  #= # + 1;        @.#= j / 1    /*bump counter;  define array element. */
                  end   /*j*/                    /* [↑]  Also, normalize the element #. */
call Lsort #                                     /*sort numeric array with a simple sort*/
$=                                               /*initialize a horizontal numeric list.*/
                  do k=1  for  #;    $= $','@.k  /*construct      "         "      "    */
                  end   /*k*/                    /* [↑]  prefix each number with a comma*/
                                                 /* [↓]  display a continued  SAY  text.*/
say 'for   '  LO"──►"HI     ' by '     INC     " (inclusive), "         # ,
                                               ' elements sorted lexicographically:'
say  '['strip($, "L", ',')"]"                    /*strip leading comma, bracket the list*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Lsort: procedure expose @.; parse arg n;  m= n-1 /*N: is the number of @ array elements.*/
       do m=m  by -1  until ok;          ok= 1   /*keep sorting the  @ array until done.*/
          do j=1  for m;  k= j+1;  if @.j>>@.k  then parse value @.j @.k 0 with @.k @.j ok
          end   /*j*/                            /* [↑]  swap 2 elements, flag as ¬done.*/
       end      /*m*/;    return
