/*REXX program sorts an array (using E─sort), in this case, the array contains integers.*/
numeric digits 30                                /*enables handling larger Euler numbers*/
                          @.  =              0;            @.1 =               1
                          @.3 =             -1;            @.5 =               5
                          @.7 =            -61;            @.9 =            1385
                          @.11=         -50521;            @.13=         2702765
                          @.15=     -199360981;            @.17=     19391512145
                          @.19= -2404879675441;            @.21= 370371188237525
#= 21                                            /*indicate there're  21 Euler  numbers.*/
call tell  'unsorted'                            /*display the array before the  eSort. */
call eSort     #                                 /*sort the array of some Euler numbers.*/
call tell  '  sorted'                            /*display the array  after  the eSort. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort: procedure expose @.;   parse arg N;     h=N                   /*an eXchange sort.*/
              do  while h>1;                   h= h%2                /*define a segment.*/
                 do i=1  for N-h;              j=i;     k= h+i       /*sort top segment.*/
                    do  while  @.k<@.j                               /*see if need swap.*/
                        parse value  @.j @.k   with   @.k @.j        /*swap two elements*/
                        if h>=j  then leave;   j= j-h;   k= k-h      /*this part sorted?*/
                        end   /*while @.k<@.j*/
                    end       /*i*/
              end             /*while h>1*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:  say copies('─', 65);       _= left('',9);                       w= length(#)
              do j=1  for #;  say _ arg(1)  'array element'   right(j, w)"="right(@.j, 20)
              end   /*j*/
       return
