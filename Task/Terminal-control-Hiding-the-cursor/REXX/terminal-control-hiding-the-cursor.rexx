/*REXX pgm calls a function in a shared library (regutil) to hide/show cursor.*/
z=rxfuncadd('sysloadfuncs', "regutil", 'sysloadfuncs')   /*add a function lib.*/
if z\==0  then do                                        /*test the return cod*/
               say 'return code'  z  "from rxfuncadd"    /*tell about bad RC. */
               exit z                                    /*exit this program. */
               end

call sysloadfuncs                                        /*load the functions.*/

                                       /* [↓]   call a particular function.   */
call syscurstate 'off'                 /*hide the displaying of the cursor.   */
say 'showing of the cursor is now off' /*inform that the cursor is now hidden.*/

                                       /* ··· and perform some stuff here ··· */
say 'sleeping for three seconds ...'   /*inform the user of what we're doing. */
call sleep 3                           /*might as well sleep for three seconds*/

call syscurstate 'on'                  /*(unhide) the displaying of the cursor*/
say 'showing of the cursor is now on'  /*inform that the cursor is now showing*/
                                       /*stick a fork in it,  we're all done. */
