/*REXX program implements the "NOTES" command (append text to a file from the C.L.). */
notes = 'notes.txt'                           /*the  fileID  of the  'notes'  file.  */
Select
  When arg(1)='?' Then Do
    Say "'rexx notes text' appends text to file" notes
    Say "'rexx notes' displays file" notes
    End
  When arg()==0  Then Do                      /*No arguments?  Then display the file.*/
    Do while lines(notes)>0
      Say linein(notes)                       /* display a line of file --> screen.  */
      End
    End
  Otherwise Do
    timestamp=right(date(),11,0) time() date('W') /*create current date & time stamp */
    If 'f2'x==2  Then tab='05'x               /* this is an EBCDIC system.           */
                 Else tab='09'x               /*  "   "  "  ASCII    "               */
    Call lineout notes,timestamp              /*append the timestamp to "notes" file.*/
    Call lineout notes,tab||arg(1)            /*   "    "     text    "    "      "  */
    End
  End                                         /*stick a fork in it,  we're all Done. */
