/*REXX program to read and display (with count) a file, one line at a time.*/
parse arg fileID .
say 'Displaying file:' fileID

  do linenumber=1  while lines(fileID)\==0      /* loop construct */
  line=linein(fileID)                           /* read line */
  say 'Line' linenumber':' line                 /* show line number and line */
  end linenumber                                /* end loop and confirm which loop */

say
say 'File' fileID 'has' linenumber-1 'lines.'   /*summary.*/
