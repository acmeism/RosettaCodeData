/*REXX program computes the number of days between two dates in the form of  YYYY-MM-DD */
parse arg $.1 $.2 _ . 1 . . xtra                 /*obtain two arguments from the  C.L.  */
seps= '/-\';        yr.= .;   mon.= .;   dd.= .  /*define the defaults for both dates.  */
            do a=1  for 2                        /*process both of the specified dates. */
            if $.a=='' | $.a=="*" | $.a==','  then $.a= date("I")
               do s=1  for length(seps)          /*process a specified date by separator*/
               sep= substr(seps, s, 1)           /*obtain one of the supported sep char.*/
               if pos(sep, $.a)\==0  then call conv $.a         /*parse the date string.*/
               end   /*s*/
            end      /*a*/
?.1= '1st'
?.2= '2nd'
if _ \== ''              then call err "too many arguments specified: "   xtra
dy.= 31                                          /*default number of days for all months*/
parse value 30 with dy.4 1 dy.6 1 dy.9 1 dy.11   /*define 30─day months, Feb. is special*/
@notCorr= "isn't in a support date format: "     /*used for a literal for an error msg. */

  do j=1  for 2                                  /*examine both dates for correct format*/
  if $.j           ==''  then call err ?.j "date was not specified."
  if length(yr.j)==0     then call err ?.j "year"  @notCorr '(missing)'
  if isDec(yr.j)         then call err ?.j "year"  @notCorr '(has a non─decimal digit)'
  if yr.j<1 | yr.j>9999  then call err ?.j "year"  @notCorr '(not in the range 1──►9999)'
  if length(mon.j)==0    then call err ?.j "month" @notCorr '(missing)'
  if isDec(mon.j)        then call err ?.j "month" @notCorr '(has a non─decimal digit)'
  if mon.j<1 | mon.j>12  then call err ?.j "month" @notCorr '(not in the range 1──►12)'
  if length(dd.j)==0     then call err ?.j "day"   @notCorr '(missing)'
  if isDec(dd.j)         then call err ?.j "day"   @notCorr '(has a non─decimal digit)'
  mo= mon.j
  if leapYr(yr.j)  then dy.2= 29                 /*Is it a leapyear? Use 29 days for Feb*/
                   else dy.2= 28                 /*Isn't "     "      "  28   "   "   " */
  if dd.j<1 | dd.j>dy.mo then call err ?.j "day"   @notCorr '(day in month is invalid)'

    yr.j= right( yr.j  +0, 4, 0)                 /*force YYYY to be four decimal digits.*/
   mon.j= right(mon.j  +0, 2, 0)                 /*  "    MON  "  "  two    "       "   */
    dd.j= right( dd.j  +0, 2, 0)                 /*  "     DD  "  "   "     "       "   */
     $.j= yr.j'-'mon.j"-"dd.j                    /*reconstitute a date from above parts.*/
  end       /*j*/

between= abs( date('B', $.1, "I")  -  date('B', $.2, "I") )     /* # days between dates.*/
parse source . how .                                            /*determine how invoked.*/
if how='COMMAND'  then say commas(between)    ' days between '     $.1     " and "     $.2
exit between                                     /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _; do c_=length(_)-3  to 1  by -3; _=insert(',', _, c_);  end;  return _
err:    say; say '***error*** ' arg(1);  exit 13 /*issue an error message (with text)   */
isDec:  return verify( arg(1), 1234567890) \== 0 /*insure argument is just decimal digs.*/
leapYr: arg _; ly=_//4==0; if ly==0  then return 0; ly=((_//100\==0)|_//400==0); return ly
serDAT: call err 'illegal date format with a separator= ['sep"],   date= "       @dat
/*──────────────────────────────────────────────────────────────────────────────────────*/
conv:   parse arg @dat                           /*obtain date that the user specified. */
        if sep=='-'  then parse var  @dat    yr.a  "-"  mon.a  '-'  dd.a    /* yy-mm-dd */
        if sep=='/'  then parse var  @dat   mon.a  "/"   dd.a  '/'  yr.a    /* mm/dd/yy */
        if sep=='\'  then parse var  @dat    dd.a  "\"  mon.a  '\'  yr.a    /* dd\mm\yy */
        if yr.a==''  then yr.a= right( date(), 4)                           /*omitted yy*/
        if length(yr.a)==2  then yr.a= left( date('S'), 2)yr.a              /*2 dig yy ?*/
        if yr.a==.  |  mon.a==.  |  dd.a==.  then call serDAT               /*validate. */
        return
