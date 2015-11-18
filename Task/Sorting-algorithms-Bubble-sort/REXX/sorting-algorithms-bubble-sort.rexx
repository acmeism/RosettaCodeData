/*REXX program sorts an array (of any items) using the  bubble-sort algorithm.*/
call gen                               /*generate the array elements  (items).*/
call show   'before sort'              /*show the  before  array elements.    */
     say copies('─',79)                /*show a separator line (before/after).*/
call bubbleSort   #                    /*invoke the bubble sort  with # items.*/
call show   ' after sort'              /*show the  after   array elements.    */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
bubbleSort: procedure expose @.; parse arg n   /*N:  number of array elements.*/
m=n-1                                  /*use this as a handy variable for sort*/
       do  until done;     done=1      /*keep sorting the array until done.   */
          do j=1  for m;   k=j+1       /*search for an element  out─of─order. */
          if @.j>@.k  then do; _=@.j   /*Out of order?  Then swap two elements*/
                               @.j=@.k /*swap current element with the next···*/
                               @.k=_   /*            ··· and the next with  _ */
                               done=0  /*indicate that the sorting isn't done,*/
                           end         /*               (1≡true,  0≡false).   */
          end   /*j*/
       end       /*until ··· */
return
/*────────────────────────────────────────────────────────────────────────────*/
gen: @.   =                            /*assign a default value to all of  @. */
     @.1  = '---letters of the Hebrew alphabet---'  ;   @.13 = 'kaph    [kaf]'
     @.2  = '===================================='  ;   @.14 = 'lamed'
     @.3  = 'aleph   [alef]'                        ;   @.15 = 'mem'
     @.4  = 'beth    [bet]'                         ;   @.16 = 'nun'
     @.5  = 'gimel'                                 ;   @.17 = 'samekh'
     @.6  = 'daleth  [dalet]'                       ;   @.18 = 'ayin'
     @.7  = 'he'                                    ;   @.19 = 'pe'
     @.8  = 'waw     [vav]'                         ;   @.20 = 'sadhe   [tsadi]'
     @.9  = 'zayin'                                 ;   @.21 = 'qoph    [qof]'
     @.10 = 'heth    [het]'                         ;   @.22 = 'resh'
     @.11 = 'teth    [tet]'                         ;   @.23 = 'shin'
     @.12 = 'yod'                                   ;   @.24 = 'taw     [tav]'
        do #=1  while  @.#\==''; end;  #=#-1 /*find how many elements in list.*/
     w=length(#)                             /*the maximum width of any index.*/
     return
/*────────────────────────────────────────────────────────────────────────────*/
show:  do j=1  for #;  say 'element'  right(j,w)  arg(1)":"  @.j;  end;   return
