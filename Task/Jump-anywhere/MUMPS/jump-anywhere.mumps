 ;Go to a label within the program file
 Goto Label
 ;Go to a line below a label
 Goto Label+lines
 ;Go to a different file
 Goto ^Routine
 ;Go to a label within a different file
 Goto Label^Routine
 ;and with offset
 Goto Label+2^Routine
 ;
 ;The next two goto commands will both return error M45 in ANSI MUMPS.
NoNo
 For
 . Goto Out
Out Quit
 Goto NoNo+2
