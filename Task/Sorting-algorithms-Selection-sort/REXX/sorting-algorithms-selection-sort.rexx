/*REXX program  sorts  a  stemmed array  using the   selection─sort   algorithm.        */
call init                                        /*assign some values to an array:   @. */
call show   'before sort'                        /*show the   before   array elements.  */
     say  copies('▒', 65)                        /*show a nice separator line  (fence). */
call selectionSort   #                           /*invoke selection sort (and # items). */
call show   ' after sort'                        /*show the    after   array elements.  */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
init: @.=;                  @.1 = '---The seven hills of Rome:---'
                            @.2 = '==============================';      @.6 = 'Virminal'
                            @.3 = 'Caelian'                       ;      @.7 = 'Esquiline'
                            @.4 = 'Palatine'                      ;      @.8 = 'Quirinal'
                            @.5 = 'Capitoline'                    ;      @.9 = 'Aventine'
              do #=1  until @.#=='';   end       /*find the number of items in the array*/
      #= #-1;         return                     /*adjust  #  (because of  DO  index).  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
selectionSort: procedure expose @.;  parse arg n
                      do j=1  for n-1;                 _= @.j;             p= j
                          do k=j+1  to n;      if @.k>=_  then iterate
                          _= @.k;      p= k      /*this item is out─of─order, swap later*/
                          end   /*k*/
                      if p==j  then iterate      /*if the same, the order of items is OK*/
                      _= @.j;  @.j= @.p;  @.p= _ /*swap 2 items that're out─of─sequence.*/
                      end       /*j*/
               return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  do i=1  for #;  say '       element' right(i,length(#)) arg(1)":" @.i; end;  return
