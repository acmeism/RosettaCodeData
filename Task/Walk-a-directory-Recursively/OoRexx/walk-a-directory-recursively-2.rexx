/* REXX ---------------------------------------------------------------
* List all file names on my disk D: that contain the string TTTT
*--------------------------------------------------------------------*/
call SysFileTree "*TTTT*.*", "file", "FS" -- F get all Files
                                        -- S search subdirectories
Say file.0 'files found'
do i=1 to file.0
  If pos('TTTT',translate(file.i))>0 Then
    say file.i
  end
