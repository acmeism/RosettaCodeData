/* REXX ---------------------------------------------------------------
* 28.06.2014 Walter Pachl
*--------------------------------------------------------------------*/
Call test 'ABC',.list~of('AA','BB','CC')
Call test 'AAA',.list~of('AA','AA','AA')
Call test 'ACB',.list~of('AA','CC','BB')
Exit

test: Procedure
Use Arg name,list
all_equal=1
increasing=1
Do i=0 To list~items-2
  i1=i+1
  Select
    When list[i1]==list[i] Then increasing=0
    When list[i1]<<list[i] Then Do
                                all_equal=0
                                increasing=0
                                End
    When list[i1]>>list[i] Then all_equal=0
    End
  End
Select
  When all_equal Then
    Say 'List' name': all elements are equal'
  When increasing Then
    Say 'List' name': elements are in increasing order'
  Otherwise
    Say 'List' name': neither equal nor in increasing order'
  End
Return
