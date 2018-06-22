/*REXX program displays the number of days since the epoch for the DATE function (BIF). */

say '     today is: '  date()                    /*today's is format:     mm MON YYYY   */

days=date('Basedate')                            /*only the first char of option is used*/
say right(days, 40)         " days since the REXX base date of January 1st, year 1"

say ' and today is: '  date(, days, "B")         /*it should still be today (µSec later)*/
                    /*   ↑                ┌───◄─── This BIF (Built-In Function) is only */
                    /*   └─────────◄──────┘        for  newer  versions of  REXX  that  */
                    /*                             support the  2nd and 3rd  arguments. */
