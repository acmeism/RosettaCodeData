/*REXX program sorts an array (using E-sort), in this case, the array contains integers.*/
numeric digits 30                                /*enables handling larger Euler numbers*/
                        @.  =               0    /*the default for all Euler numbers.   */
                        @.1 =               1
                        @.3 =              -1
                        @.5 =               5
                        @.7 =             -61
                        @.9 =            1385
                        @.11=          -50521
                        @.13=         2702765
                        @.15=      -199360981
                        @.17=     19391512145
                        @.19=  -2404879675441
                        @.21= 370371188237525
size=21                                          /*indicate that there're  21 Euler  #s.*/
call tell  'un-sorted'                           /*display the array before the eSsort. */
call eSort  size                                 /*sort the array of some Euler numbers.*/
call tell  '   sorted'                           /*display the array  after  the sort.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort: procedure expose @.;   parse arg N;  h=N
                 do  while h>1;             h=h%2
                    do i=1  for N-h;        j=i;     k=h+i
                        do  while  @.k<@.j
                        parse value @.j @.k   with   @.k @.j  /*swap two array elements.*/
                        if h>=j  then leave;  j=j-h; k=k-h
                        end   /*while @.k<@.j*/
                    end       /*i*/
                 end          /*while h>1*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:  say center(arg(1), 50, '─')
                     do j=1  for size
                     say  arg(1) 'array element'   right(j, length(size))'='right(@.j, 20)
                     end   /*j*/
       say
       return
