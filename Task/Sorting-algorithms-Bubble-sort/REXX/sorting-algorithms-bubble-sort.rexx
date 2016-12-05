/*REXX program sorts an array  (of any kind of items)  using the  bubble─sort algorithm.*/
call gen                                         /*generate the array elements  (items).*/
call show   'before sort'                        /*show the  before  array elements.    */
     say copies('─', 79)                         /*show a separator line (before/after).*/
call bubbleSort   #                              /*invoke the bubble sort  with # items.*/
call show   ' after sort'                        /*show the  after   array elements.    */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bubbleSort: procedure expose @.; parse arg n;    m=n-1  /*N:  number of array elements. */
               do m=m  for m  by -1  until ok;   ok=1   /*keep sorting array until done.*/
                   do j=1  for m;  k=j+1;  if @.j<=@.k  then iterate /*Not out─of─order?*/
                   _=@.j;  @.j=@.k;  @.k=_;      ok=0   /*swap 2 elements; flag as ¬done*/
                   end   /*j*/
               end       /*m*/
            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen: @.=;         @.1 = '---letters of the Hebrew alphabet---' ;   @.13= "kaph    [kaf]"
                  @.2 = '====================================' ;   @.14= "lamed"
                  @.3 = 'aleph   [alef]'                       ;   @.15= "mem"
                  @.4 = 'beth    [bet]'                        ;   @.16= "nun"
                  @.5 = 'gimel'                                ;   @.17= "samekh"
                  @.6 = 'daleth  [dalet]'                      ;   @.18= "ayin"
                  @.7 = 'he'                                   ;   @.19= "pe"
                  @.8 = 'waw     [vav]'                        ;   @.20= "sadhe   [tsadi]"
                  @.9 = 'zayin'                                ;   @.21= "qoph    [qof]"
                  @.10= 'heth    [het]'                        ;   @.22= "resh"
                  @.11= 'teth    [tet]'                        ;   @.23= "shin"
                  @.12= 'yod'                                  ;   @.24= "taw     [tav]"
        do #=1  while  @.#\=='';  end;    #=#-1  /*determine #elements in list; adjust #*/
     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: w=length(#);   do j=1  for #; say 'element' right(j,w) arg(1)":" @.j; end;    return
