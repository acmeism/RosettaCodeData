/* REXX ---------------------------------------------------------------
* 28.06.2014 Walter Pachl
* 30.06.2014 corrected in sync with REXX version 2
*--------------------------------------------------------------------*/
  Call gen                         /* generate the array elements.   */
  Call show 'before sort'          /* show  "before"  array elements.*/
  Call gnomeSort x                 /* invoke the infamous gnome sort.*/
  Call show ' after sort'          /* show  "after"   array elements.*/
  Exit                             /* done.                          */

gnomesort: Procedure
  Use Arg x
  n=x~items
  k=2
  Do j=3 While k<=n
    km=k-1
    If x[km]<=x[k] Then
      k=j
    Else Do
      t=x[km]; x[km]=x[k]; x[k]=t  /* swap two entries in the array. */
      k=k-1
      If k==1 Then
        k=j
      Else
        j=j-1
      End
    End
  Return

gen:
  x=.array~of('---the seven virtues---','=======================',,
              'Faith','Hope','Charity  [Love]','Fortitude','  Justice',,
              'Prudence','Temperance')
  Return
show:
  Say arg(1)
  Do i=1 To x~items
    Say 'element' right(i,2) x[i]
    End
  Return
