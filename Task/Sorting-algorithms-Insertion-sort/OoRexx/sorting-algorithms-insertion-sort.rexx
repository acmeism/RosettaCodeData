/* REXX program sorts a stemmed array (has characters)                */
/* using the insertion sort algorithm                                 */
  Call gen                          /* fill the array with test data  */
  Call show 'before sort'           /* display the elements           */
  Say copies('-',79)                /* display a separator line       */
  Call insertionSort x.0            /* invoke the insertion sort.     */
  Call show ' after sort'           /* display the elements after sort*/
  Exit
/*--------------------------------------------------------------------*/
gen: Procedure Expose x.
  x.1="---Monday's Child Is Fair of Face  (by Mother Goose)---"
  x.2="======================================================="
  x.3="Monday's child is fair of face;"
  x.4="Tuesday's child is full of grace;"
  x.5="Wednesday's child is full of woe;"
  x.6="Thursday's child has far to go;"
  x.7="Friday's child is loving and giving;"
  x.8="Saturday's child works hard for a living;"
  x.9="But the child that is born on the Sabbath day"
  x.10="Is blithe and bonny, good and gay."
  x.0=10                            /* number of elements             */
  Return
/*--------------------------------------------------------------------*/
insertionsort: Procedure Expose x.
  Parse Arg n
  Do i=2 To n
    y=x.i
    Do j=i-1 By -1 To 1 While x.j>y
      z=j+1
      x.z=x.j
      /* Say 'set x.'z 'to x.'j '('||x.j||')' */
      End
    z=j+1
    x.z=y
    /* Say 'set x.'z 'to' y                   */
    End
  Return
/*--------------------------------------------------------------------*/
show:
  Do j=1 To x.0
    Say 'Element' right(j,length(x.0)) arg(1)":" x.j
    End
  Return
