/*REXX program sorts  (using E─sort)  and displays a list of some interesting integers. */
  Bell=  1 1 2 5 15 52 203 877 4140 21147 115975           /*a few  Bell          "     */
  Bern= '1 -1 1 0 -1 0 1 0 -1 0 5 0 -691 0 7 0 -3617'      /*"  "   Bernoulli     "     */
Perrin=  3 0 2 3 2 5 5 7 10 12 17 22 29 39 51 68 90        /*"  "   Perrin        "     */
  list= Bell  Bern  Perrin                                 /*throw them all ───► a pot. */
say 'unsorted =' list                                      /*display what's being shown.*/
#= words(list)                                             /*nice to have # of elements.*/
                              do j=1  for #                /*build an array, a single   */
                              @.j=word(list, j)            /*     ··· element at a time.*/
                              end    /*j*/
call eSort #                                               /*sort the collection of #s. */
$=;                           do k=1  for #;   $= $ @.k    /*build a list from the array*/
                              end    /*k*/
say '  sorted =' space($)                                  /*display the sorted list.   */
exit                                              /*stick a fork in it,  we're all done.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort: procedure expose @.;   parse arg N;       h= N                /*an eXchange sort.*/
              do  while h>1;                     h= h % 2            /*define a segment.*/
                do i=1  for N-h;                 j= i;      k= h + i /*sort top segment.*/
                  do  while  @.k<@.j                                 /*see if need swap.*/
                  parse value  @.j  @.k   with   @.k  @.j            /*swap two elements*/
                  if h>=j  then leave;           j= j - h;  k= k - h /*this part sorted?*/
                  end   /*while @.k<@.j*/
                end     /*i*/
              end       /*while h>1*/
       return
