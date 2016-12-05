/*REXX program  sorts  a  stemmed array  using the   selection-sort   algorithm.        */
@.=;                     @.1 = '---The seven hills of Rome:---'
                         @.2 = '=============================='
                         @.3 = 'Caelian'
                         @.4 = 'Palatine'
                         @.5 = 'Capitoline'
                         @.6 = 'Virminal'
                         @.7 = 'Esquiline'
                         @.8 = 'Quirinal'
                         @.9 = 'Aventine'
           do #=1  until @.#==''; end;   #=#-1   /*find the number of items in the array*/
                                                 /* [↑]  adjust  #  ('cause of DO index)*/
call show   'before sort'                        /*show the   before   array elements.  */
say  copies('▒', 65)                             /*show a nice separator line  (fence). */
call selectionSort   #                           /*invoke selection sort (and # items). */
call show   ' after sort'                        /*show the    after   array elements.  */
exit                                             /*stick a fork in it,  we're a;; done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
selectionSort:  procedure expose @.;  parse arg n
                       do j=1  for n-1
                       _=@.j;  p=j;                  do k=j+1  to n
                                                     if @.k<_  then do;  _=@.k;  p=k;  end
                                                     end   /*k*/
                       if p==j  then iterate     /*if the same,  the order of items OK. */
                       _=@.j;   @.j=@.p;  @.p=_  /*swap 2 items that're out-of-sequence.*/
                       end   /*j*/
                return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  do i=1  for #;  say '       element' right(i,length(#)) arg(1)":" @.i; end;  return
