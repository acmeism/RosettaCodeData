/*REXX program  sorts  a (stemmed)  array  using a  (stable)   bubble─sort   algorithm. */
call gen@                                        /*generate the array elements (strings)*/
call show  'before sort'                         /*show the  before array  elements.    */
     say copies('▒', 50)                         /*show a separator line between shows. */
call bubbleSort   #                              /*invoke the bubble sort.              */
call show  ' after sort'                         /*show the   after array  elements.    */
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
gen@: @.=;                 @.1 = 'UK  London'
                           @.2 = 'US  New York'
                           @.3 = 'US  Birmingham'
                           @.4 = 'UK  Birmingham'
             do #=1  while @.#\==''; end;  #=#-1 /*determine how many entries in list.  */
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: do j=1  for #;  say '      element' right(j,length(#)) arg(1)":"  @.j;  end;  return
