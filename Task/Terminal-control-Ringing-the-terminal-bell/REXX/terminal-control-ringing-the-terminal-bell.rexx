/*REXX program illustrates methods to  ring the terminal bell  or  use the PC speaker.  */
                     /*╔═══════════════════════════════════════════════════════════════╗
                       ║                                                               ║
                       ║  Note that the  hexadecimal code  to ring the  terminal bell  ║
                       ║  is different on an ASCII machine than an EBCDIC machine.     ║
                       ║                                                               ║
                       ║  On an  ASCII machine,  it is  (hexadecimal)  '07'x.          ║
                       ║   "  " EBCDIC    "       "  "        "        '2F'x.          ║
                       ║                                                               ║
                       ╚═══════════════════════════════════════════════════════════════╝*/

if 3=='F3'  then bell= '2f'x                     /*we are running on an EBCDIC machine. */
            else bell= '07'x                     /* "  "     "     "  "  ASCII    "     */

say bell                                         /*sound the  bell  on the terminal.    */
say copies(bell, 20)                             /*as above,  but much more annoying.   */

                     /*╔═══════════════════════════════════════════════════════════════╗
                       ║                                                               ║
                       ║  Some REXX interpreters have a  built-in function  (BIF)  to  ║
                       ║  to produce a sound on the PC speaker, the sound is specified ║
                       ║  by frequency  and  an optional  duration.                    ║
                       ║                                                               ║
                       ╚═══════════════════════════════════════════════════════════════╝*/

                                         /* [↓]  supported by Regina REXX:              */
freq= 1200                               /*frequency in  (nearest)  cycles per second.  */
call  beep freq                          /*sounds the PC speaker, duration=  1   second.*/
ms=   500                                /*duration in milliseconds.                    */
call  beep freq, ms                      /*  "     "   "    "         "     1/2     "   */


                                         /* [↓]  supported by PC/REXX  &  Personal REXX:*/
freq= 2000                               /*frequency in  (nearest)  cycles per second.  */
call  sound freq                         /*sounds PC speaker, duration=   .2   second.  */
secs= .333                               /*duration in seconds (round to nearest tenth).*/
call  sound freq, secs                   /*  "     "    "         "      3/10     "     */

                                         /*stick a fork in it, we're done making noises.*/
