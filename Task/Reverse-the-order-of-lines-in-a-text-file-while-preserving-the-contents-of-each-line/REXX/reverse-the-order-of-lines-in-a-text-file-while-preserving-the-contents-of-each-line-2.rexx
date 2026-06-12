/*REXX pgm reads a file, and displays the lines (records) of the file in reverse order. */
parse arg iFID .                                 /*obtain optional argument from the CL.*/
if iFID=='' | iFID=="," then iFID='REVERSEF.TXT' /*Not specified?  Then use the default.*/
call lineout iFID                                /*close file, good programming practice*/
options  nofast_lines_BIF_default                /*an option just for  Regina REXX.     */
#= lines(iFID)                                   /*#:  the number of lines in the file. */
                   do j=#  by -1  for #          /*read file (backwards), from bot──►top*/
                   say linein(iFID, j)           /*display record contents ──► terminal.*/
                   end   /*j*/
call lineout iFID                                /*close file, good programming practice*/
