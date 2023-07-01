/*REXX program displays (draws) a pixel at a specified screen location in the color red.*/
parse upper version !ver .
!pcrexx= 'REXX/PERSONAL'==!ver | 'REXX/PC'==!ver /*obtain the REXX interpreter version. */
parse arg x y txt CC .                           /*obtain optional arguments from the CL*/
if   x=='' |  x==","  then   x= 100              /*Not specified?  Then use the default.*/
if   y=='' |  y==","  then   y= 100              /* "       "        "   "   "     "    */
if  CC=='' |  CC=","  then  CC=   4              /* "       "        "   "   "     "    */
if txt=='' | txt=","  then tzt= '·'              /* "       "        "   "   "     "    */

if ¬!pcrexx  then do; say; say "***error***  PC/REXX[interpreter] isn't being used.";  say
                      exit 23
                  end

call scrWrite x,y,txt,,,CC                       /*stick a fork in it,  we're all done. */
