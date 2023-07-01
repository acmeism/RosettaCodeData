                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Distinguishing built-in functions and user-defined functions.      ║
                  ║                                                                    ║
                  ║ One objective of the REXX language is to allow the user to use any ║
                  ║ function  (or subroutine)  name whether or not there is a built-in ║
                  ║ function with the same name  (there isn't a penality for this).    ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

                                                 /*date:  as in going out with someone. */
qqq= date()                                      /*number of real dates that Bob was on.*/
                                                 /*hopefully, it accurately counts dates*/
say "Bob's been out"  qqq  'times.'
www= 'DATE'("USA")                               /*returns date in format   mm/dd/yyyy  */
                                                 /*any function in quotes is external.  */
exit                                             /*stick a fork in it,  we're all done. */

date: return 4                                   /*Bob only "went out" 4 times, no need */
                                                 /* to actually count, he quit after 4. */
