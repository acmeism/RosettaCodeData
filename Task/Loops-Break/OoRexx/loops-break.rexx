/*REXX ****************************************************************
* Three Ways to leave a Loop
* ooRexx added the possibility to leave an outer loop
* without using a control variable
* 12.05.2013 Walter Pachl
**********************************************************************/
do i1=1 To 2                           /* an outer loop              */
  Say 'i1='i1                          /* tell where we are          */
  Call random ,,123                    /* seed to be reproducable    */
  do forever                           /* inner loop                 */
    a=random(19)
    Say a
    if a=6  then leave                 /* leaces the innermost loop  */
    end
  end

do i2=1 To 2
  Say 'i2='i2
  Call random ,,123
  do forever
    a=random(19)
    Say a
    if a=6  then leave i2    /* leaves loop with control variable i2 */
    end
  end

Parse Version v
Select
  When pos('ooRexx',v)>0 Then supported=1
  Otherwise                   supported=0
  End
If supported Then Do
  Say 'Leave label-name is supported in' v
do Label i3 Forever
  Say 'outer loop'
  Call random ,,123
  do forever
    a=random(19)
    Say a
    if a=6  then leave i3          /* leaves loop with label name i3 */
    end
  end
End
Else
  Say 'Leave label-name is probably not supported in' v
