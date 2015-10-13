/*REXX program calls (invoke) a "foreign" (non-REXX) language routine/program.*/

cmd = "MODE"                           /*define the command that is to be used*/
opts= 'CON:  CP  /status'              /*define the options to be used for cmd*/

address  'SYSTEM'  cmd  opts           /*invoke a cmd via the SYSTEM interface*/

                                       /*stick a fork in it,  we're all done. */
