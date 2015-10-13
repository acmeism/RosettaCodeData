/*REXX pgm calls a function (systextscreensize) in a shared library (regutil).*/
z=rxfuncadd('sysloadfuncs', "regutil", 'sysloadfuncs')   /*add a function lib.*/
if z\==0  then do                                        /*test the return cod*/
               say 'return code'  z  "from rxfuncadd"    /*tell about bad RC. */
               exit z                                    /*exit this program. */
               end

call sysloadfuncs                                        /*load the functions.*/

                                       /* [↓]   call a particular function.   */
y=systextscreensize()                  /*Y now contains 2 numbers:  rows cols */
parse var y rows cols .                /*obtain the two numeric words in  Y.  */
say 'rows='  rows                      /*display the number of (terminal) rows*/
say 'cols='  cols                      /*   "     "     "    "     "      cols*/
call SysDropFuncs                      /*clean up: make functions inaccessible*/
                                       /*stick a fork in it,  we're all done. */
