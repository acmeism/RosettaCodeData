/*REXX program calls a function  (sysTextScreenSize)  in a shared library  (regUtil).   */

                        /*Note:  the  REGUTIL.DLL  (REGina UTILity Dynamic Link Library */
                        /*       should be in the  PATH  or the current directory.      */

rca= rxFuncAdd('sysLoadFuncs', "regUtil", 'sysLoadFuncs')  /*add a function library.    */
if rca\==0  then do                                        /*examine the    return code.*/
                 say 'return code' rca "from rxFuncAdd"    /*tell about bad    "     "  */
                 exit rca                                  /*exit this program with RC. */
                 end

rcl= sysLoadFuncs()                                        /*we can load the functions. */
if rcl\==0  then do                                        /*examine the    return code.*/
                 say 'return code' rcl "from sysLoadFuncs" /*tell about bad    "     "  */
                 exit rcl                                  /*exit this program with RC. */
                 end
                                                           /* [↓]   call a function.    */
$= sysTextScreenSize()                                     /*$  has 2 words:  rows cols */
parse var  $     rows  cols  .                             /*get two numeric words in $.*/
say '    rows='  rows                                      /*show number of screen rows.*/
say '    cols='  cols                                      /*  "     "    "     "  cols.*/

rcd= SysDropFuncs()                                        /*make functions inaccessible*/
if rcd\==0  then do                                        /*examine the    return code.*/
                 say 'return code' rcd "from sysDropFuncs" /*tell about bad    "     "  */
                 exit rcd                                  /*exit this program with RC. */
                 end
exit 0                                           /*stick a fork in it,  we're all done. */
