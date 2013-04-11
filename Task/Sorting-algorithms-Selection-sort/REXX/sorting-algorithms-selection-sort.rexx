/*REXX program sorts an  array  using  the  selection-sort  method.     */
@.=''                                  /*assign a default value to stem.*/
@.1='---The seven hills of Rome:---'
@.2='=============================='
@.3='Caelian'
@.4='Palatine'
@.5='Capitoline'
@.6='Virminal'
@.7='Esquiline'
@.8='Quirinal'
@.9='Aventine'
                      do items=1  until @.items==''      /*find # items.*/
                      end
items=items-1                          /*adjust the # of items slightly.*/
call show@ 'before sort'               /*show the before array elements,*/
call selectionSort items               /*invoke the selection sort.     */
call show@ ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SELECTIONSORT subroutine────────────*/
selectionSort:  procedure expose @.;  parse arg n

              do j=1  for n-1
              _=@.j;  p=j;            do k=j+1  to n
                                      if @.k<_  then do;  _=@.k;  p=k; end
                                      end    /*k*/
              if p==j  then iterate
              _=@.j;   @.j=@.p;   @.p=_
              end   /*j*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: w=length(items);          do i=1  for items
                                 say 'element'  right(i,w)  arg(1)":"  @.i
                                 end   /*i*/
say copies('─',79)                     /*show a nice separator line.    */
return
