/*REXX program converts mm/dd/yyyy Gregorian date ───> Discordian date. */
/*Gregorian date may be  m/d/yy    ──or──    m/d     format.            */

day.1='Sweetness'                   /*define 1st day-of-Discordian-week.*/
day.2='Boomtime'                    /*define 2nd day-of-Discordian-week.*/
day.3='Pungenday'                   /*define 3rd day-of-Discordian-week.*/
day.4='Prickle-Prickle'             /*define 4th day-of-Discordian-week.*/
day.5='Setting Orange'              /*define 5th day-of-Discordian-week.*/

seas.0="St. Tib's day,"          /*define the leap-day of Discordian yr.*/
seas.1='Chaos'                   /*define 1st season-of-Discordian-year.*/
seas.2='Discord'                 /*define 2nd season-of-Discordian-year.*/
seas.3='Confusion'               /*define 3rd season-of-Discordian-year.*/
seas.4='Bureaucracy'             /*define 4th season-of-Discordian-year.*/
seas.5='The Aftermath'           /*define 5th season-of-Discordian-year.*/

parse arg gM '/' gD "/" gY .           /*get the date specified.        */
gY=left(right(date(),4),4-length(Gy))gY  /*adjust for a 2-dig yr or none*/
                                       /*below:get day-of-year,adj LeapY*/
doy=date('d',gY||right(gM,2,0)right(gD,2,0),"s")-(leapyear(gY) & gM>2)
dW=doy//5;if dW==0 then dW=5           /*compute the Discordian weekday.*/
dS=(doy-1)%73+1                        /*compute the Discordian season. */
dD=doy//73;if dD==0 then dD=73; dD=dD','      /*Discordian day-of-month.*/
if leapyear(gY) & gM==02 & gD==29 then do; dD=''; ds=0; end /*St. Tib's?*/
say space(day.dW',' seas.dS dD gY+1166)  /*show and tell Discordian date*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────LEAPYEAR subroutine──────────────*/
leapyear: procedure; arg y
if y//4\==0 then return 0              /* not ≈ by 4?    Not a leapyear.*/
return y//100\==0 | y//400==0          /*apply 100 and 400 year rule.   */
