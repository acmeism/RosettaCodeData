/*REXX pgm reads text from the terminal screen from a certain  row,  column, and length.*/
parse arg row col len .                          /*obtain optional arguments from the CL*/
if row=='' | row==","  then row= 3               /*Not specified?  Then use the default.*/
if col=='' | col==","  then col= 5               /* "      "         "   "   "     "    */
if len=='' | len==","  then len= 8               /* "      "         "   "   "     "    */
parse upper version v .                          /*obtain the version of REXX being used*/

if v\=='REXX/PERSONAL'  then do;  say            /*Not correct version?   Tell err msg. */
                                  say '***error***:'
                                  say 'This REXX program requires Personal REXX version.'
                                  say
                                  exit 13
                             end
$= scrread(row, col, len)
say 'data read from terminal row '  row  "    col "  col  '    length '  len  "   is:"
say $
exit 0                                           /*stick a fork in it,  we're all done. */
