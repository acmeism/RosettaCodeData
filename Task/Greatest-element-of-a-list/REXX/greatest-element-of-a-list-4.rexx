/* REXX ***************************************************************
* If the list contains any character strings, the following will work
* Note the use of >> (instead of >) to avoid numeric comparison
* Note that max() overrides the builtin function MAX
* 30.07.2013 Walter Pachl
**********************************************************************/
list='Walter Pachl living in Vienna'
Say max(list)
list='8 33 -12'
Say max(list)
Exit
max: Procedure
Parse Arg l
max=word(l,1)
Do i=2 To words(l)
  If word(l,i)>>max Then
    max=word(l,i)
  End
Return max
