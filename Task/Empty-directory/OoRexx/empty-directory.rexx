Call test 'D:\nodir'        /* no such directory      */
Call test 'D:\edir'         /* an empty directory     */
Call test 'D:\somedir'      /* directory with 2 files */
Call test 'D:\somedir','S'  /* directory with 3 files */
Exit
test: Parse Arg fd,nest
If SysIsFileDirectory(fd)=0 Then
  Say 'Directory' fd 'not found'
Else Do
  ret=SysFileTree(fd'\*.*','X', 'F'nest)
  If x.0=0 Then
    say 'Directory' fd 'is empty'
  Else Do
    If nest='' Then
      say 'Directory' fd 'contains' x.0 'files'
    Else
      say 'Directory' fd 'contains' x.0 'files (some nested)'
    End
  End
Return
