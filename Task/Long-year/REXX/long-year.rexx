/*REXX program determines If a (calendar) year is a short or long  year */
/*                                                    (52 or 53 weeks). */
Parse Arg lo hi .                              /* obtain optional args. */
current=left(date('S'),4)
If lo=='' | lo=="," | lo=='*' Then lo=current  /*Not given? Use default.*/
If hi=='' | hi==","           Then hi=lo       /* "    "     "     "    */
If                    hi=='*' Then hi=current  /*an asterisk: current yr*/

Do yr=lo To hi                        /* process single yr  or range of */
  Say '     year ' yr ' is a ',
      right(word('short long',is_long(yr)+1),5) ' year'
  End
Exit
/*----------------------------------------------------------------------*/
wd_1231:
/*************************************************************************
* returns the day of the week of 31 December year
*************************************************************************/
  Parse Arg year
  Return (year+year%4-year%100+year%400)//7

is_long:
  Parse Arg year
  Return wd_1231(year)==4 |,    /* year ends in a Thursday              */
         wd_1231(year-1)==3     /* or previous year ends in a Wednesday */
