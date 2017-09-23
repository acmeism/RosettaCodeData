/**********************************************************************
* exists(filespec)
* returns 1   if filespec identifies a file with size>0
*                (a file of size 0 is deemed not to exist.)
*             or a directory
*         0   otherwise
* 09.06.2013 Walter Pachl (retrieved from my toolset)
**********************************************************************/
exists:
  parse arg spec
  call sysfiletree spec, 'LIST', 'BL'
  if list.0\=1 then return 0        -- does not exist
  parse var list.1 . . size flags .
  if size>0 then return 1           -- real file
  If substr(flags,2,1)='D' Then Do
    Say spec 'is a directory'
    Return 1
    End
  If size=0 Then Say spec 'is a zero-size file'
  Return 0
