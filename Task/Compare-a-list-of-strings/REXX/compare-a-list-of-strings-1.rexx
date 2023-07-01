/* REXX ---------------------------------------------------------------
* 28.06.2014 Walter Pachl
*--------------------------------------------------------------------*/
Call mklist 'ABC','AA','BB','CC'
Call test 'ABC'
Call mklist 'AAA','AA','AA','AA'
Call mklist 'ACB','AA','CC','BB'
Call test 'AAA'
Call test 'ACB'
Exit

mklist:
  list=arg(1)
  do i=1 by 1 To arg()-1
    call value list'.'i,arg(i+1)
    End
  Call value list'.0',i-1
  Return

test:
Parse Arg list
all_equal=1
increasing=1
Do i=1 To value(list'.0')-1 While all_equal | increasing
  i1=i+1
  Select
    When value(list'.i1')==value(list'.i') Then increasing=0
    When value(list'.i1')<<value(list'.i') Then Do
                                                all_equal=0
                                                increasing=0
                                                End
    When value(list'.i1')>>value(list'.i') Then all_equal=0
    End
  End
Select
  When all_equal Then
    Say 'List' value(list)': all elements are equal'
  When increasing Then
    Say 'List' value(list)': elements are in increasing order'
  Otherwise
    Say 'List' value(list)': neither equal nor in increasing order'
  End
Return
