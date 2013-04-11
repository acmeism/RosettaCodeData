/*REXX program shows the # of days since the epoch for the DATE function*/

say '     today is' date()             /*today's is format: mm MON YYYY */

days=date('Basedate')                  /*only 1st char of option is used*/
say right(days,35) "days since the REXX base date of January 1st, year 1"

say 'and today is:' date(,days,'B')    /*this should be today (still).  */

      /*──────── The above statement is only valid for the newer REXXes,*/
      /*──────── older versions don't support the 2nd and 3rd arguments.*/
