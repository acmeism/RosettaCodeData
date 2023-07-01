/*REXX pgm to do a "bad" assignment  (with an unassigned REXX variable).*/

signal on noValue                      /*usually, placed at pgm start.  */

xxx=aaaaa                              /*tries to assign aaaaa ───► xxx */

say xxx 'or somesuch'
exit

noValue:                               /*this can be dressed up better. */
badLine  =sigl                         /*REXX line number that failed.  */
badSource=sourceline(badLine)          /*REXX source line ···           */
badVar   =condition('D')               /*REXX var name that's ¬ defined.*/
say
say '*** error! ***'
say 'undefined variable' badvar "at REXX line number" badLine
say
say badSource
say
exit 13
