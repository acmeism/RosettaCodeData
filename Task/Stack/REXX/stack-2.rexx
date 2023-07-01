/* REXX ***************************************************************
* supports push, pull, and peek
* 11.08.2013 Walter Pachl
**********************************************************************/
stk.=0
Call push 123
Say empty()
say peek()
say pull()
Say empty()
say peek()
say push(456)
say peek()
Exit

push: Procedure Expose stk.
  Parse Arg v
  z=stk.0+1
  stk.z=v
  stk.0=z
  Return v

peek: Procedure Expose stk.
  If stk.0=0 Then
    Return 'stack is empty'
  Else Do
    z=stk.0
    Return stk.z
    End

pull: Procedure Expose stk.
  If stk.0=0 Then
    Return 'stack is empty'
  Else Do
    z=stk.0
    res=stk.z
    stk.0=stk.0-1
    Return res
    End

empty: Procedure Expose stk.
  Return stk.0=0
