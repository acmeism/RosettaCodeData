/*REXX program sorts (using E-sort) a list of some interesting integers.*/
/* [↓]  quotes aren't needed if all elements in a list are non-negative.*/
bell=  1 1 2 5 15 52 203 877 4140 21147 115975      /*some Bell numbers.*/
bern= '1 -1 1 0 -1 0 1 0 -1 0 5 0 -691 0 7 0 -3617' /*some Bernoulli num*/
perrin= 3 0 2 3 2 5 5 7 10 12 17 22 29 39 51 68 90  /*some Perrin nums. */
list=bell bern perrin                               /*throw 'em───►a pot*/
say 'unsorted =' list                               /*an announcement···*/
size=words(list)                                    /*nice to have SIZE.*/
                        do j=1  for size            /*build an array, 1 */
                        @.j=word(list,j)            /*element at a time.*/
                        end    /*j*/
call esort size                                     /*sort the stuff.   */
bList=                                              /*list: null so far.*/
                        do k=1  for size            /*build a list.     */
                        bList=strip(bList @.k)      /*append it to list.*/
                        end    /*k*/
say '  sorted =' bList                              /*show & tell time. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ESORT subroutine────────────────────*/
esort: procedure expose @.;   parse arg N;   h=N    /*get the item count*/
        do  while  h>1;       h=h%2                 /*partition array.  */
          do i=1  for N-h;   j=i;   k=h+i
              do  while  @.k<@.j
              parse value  @.j @.k  with  @.k @.j   /*swap two elements.*/
              if h>=j  then leave;  j=j-h;  k=k-h
              end   /*while @.k<@.j*/
          end       /*i*/
        end         /*while h>1*/
return
