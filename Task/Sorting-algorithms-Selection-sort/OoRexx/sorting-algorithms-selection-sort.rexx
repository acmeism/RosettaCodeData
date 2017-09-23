/*REXX ****************************************************************
* program sorts an  array  using  the  selection-sort  method.
* derived from REXX solution
* Note that ooRexx can process Elements of the stem argument (Use Arg)
* 06.10.2010 Walter Pachl
**********************************************************************/
call generate                       /*generate the array elements.   */
call show 'before sort'             /*show the before array elements,*/
call selectionSort x.               /*invoke the selection sort.     */
call show 'after sort'              /*show the  after array elements.*/
exit                                /*stick a fork in it, we're done.*/

selectionSort: Procedure
  Use Arg s.                        /* gain access to the argument   */
  do j=1 To s.0-1
    t=s.j;
    p=j;
    do k=j+1 to s.0
      if s.k<t then do;
        t=s.k;
        p=k;
        end
      end
    if p=j then
      iterate
    t=s.j;
    s.j=s.p;
    s.p=t
    end
  return

show:
  Parse Arg heading
  Say heading
  Do i=1 To x.0
    Say i'  'x.i
    End
  say copies('-',79)
  Return
return

generate:
  x.1='---The seven hills of Rome:---'
  x.2='=============================='
  x.3='Caelian'
  x.4='Palatine'
  x.5='Capitoline'
  x.6='Virminal'
  x.7='Esquiline'
  x.8='Quirinal'
  x.9='Aventine'
  x.0=9
  return
