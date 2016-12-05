/*REXX program  converts  a   mm/dd/yyyy    Gregorian date   ───►   a  Discordian date. */
 @day.1= 'Sweetness'                             /*define the 1st day─of─Discordian─week*/
 @day.2= 'Boomtime'                              /*   "    "  2nd  "   "      "       " */
 @day.3= 'Pungenday'                             /*   "    "  3rd  "   "      "       " */
 @day.4= 'Prickle-Prickle'                       /*   "    "  4th  "   "      "       " */
 @day.5= 'Setting Orange'                        /*   "    "  5th  "   "      "       " */

@seas.0= "St. Tib's day,"                        /*define the leap─day of Discordian yr.*/
@seas.1= 'Chaos'                                 /*   "   1st season─of─Discordian─year.*/
@seas.2= 'Discord'                               /*   "   2nd    "    "      "       "  */
@seas.3= 'Confusion'                             /*   "   3rd    "    "      "       "  */
@seas.4= 'Bureaucracy'                           /*   "   4th    "    "      "       "  */
@seas.5= 'The Aftermath'                         /*   "   5th    "    "      "       "  */

parse arg  gM  '/'  gD  "/"  gY .                /*obtain the specified Gregorian date. */
if gM=='' | gM=='*'  then parse  value  date('U')   with   gM  '/'  gD  "/"  gY .

gY=left( right( date(), 4), 4 - length(Gy) )gY   /*adjust for two─digit year  or  none. */

                                                 /* [↓]  day─of─year,  leapyear adjust. */
doy=date('d', gY || right(gM, 2, 0)right(gD ,2, 0),  "s")   -   (leapyear(gY)   &   gM>2)

dW=doy//5;   if dW==0  then dW=5                 /*compute the Discordian weekday.      */
dS=(doy-1)%73+1                                  /*   "     "       "     season.       */
dD=doy//73;  if dD==0  then dD=73                /*   "     "       "     day─of─month. */
if leapyear(gY) & gM=2 & gD=29  then ds=0        /*is this St. Tib's day  (leapday) ?   */
if ds==0  then dD=                               /*adjust for the Discordian leap day.  */

say space(@day.dW','  @seas.dS dD","  gY +1166)  /*display Discordian date to terminal. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
leapyear: procedure;   parse arg y               /*obtain a four─digit Gregorian year.  */
          if y//4\==0  then return 0             /*Not  ÷  by 4?   Then not a leapyear. */
          return y//100\==0 | y//400==0          /*apply the  100  and  400  year rules.*/
