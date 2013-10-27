/*REXX program finds months with 5 weekends in them (given a date range)*/
month. =31                             /*month days; Feb. is done later.*/
month.4=30;   month.6=30;   month.9=30;   month.11=30    /*30-day months*/
parse arg yStart yStop .               /*get the "start" & "stop" years.*/
if yStart==''  then yStart=1900        /*if not specified, use default. */
if yStop ==''  then yStop =2100        /* "  "      "       "     "     */
years=yStop-yStart+1                   /*calculate the # of yrs in range*/
haps=0                                 /*num of five weekends happenings*/
!.=0                                   /*if a year has any five-weekends*/
       do y=yStart to yStop            /*process the years specified.   */
           do m=1  for 12;    wd.=0    /*process each month, each year. */
           if m==2  then month.2=28+leapyear(y)    /*handle #days in Feb*/
                 do d=1  for month.m; dat_=y"-"right(m,2,0)'-'right(d,2,0)
                 parse  upper  value   date('W', dat_, "I")    with    ? 3
                 wd.?=wd.?+1           /*? is the 1st 2 chars of weekday*/
                 end   /*d*/           /*WD.su = # of Sundays in a month*/
           if wd.su\==5 | wd.fr\==5 | wd.sa\==5 then iterate  /*5 W.E.s?*/
           say 'There are five weekends in'   y   date('M', dat_, "I")
           haps=haps+1;   !.y=1        /*bump ctr; indicate yr has 5 WEs*/
           end         /*m*/
       end             /*y*/
say
say 'There were ' haps " occurrence"s(haps) 'of five-weekend months in year's(years) yStart'──►'yStop
say; #=0
          do y=yStart  to yStop;   if !.y  then iterate     /*skip if OK*/
          #=#+1
          say  'Year '    y    " doesn't have any five-weekend months."
          end   /*y*/
say
say  "There are " # ' year's(#) "that haven't any five─weekend months in year"s(years) yStart'──►'yStop
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LEAPYEAR subroutine─────────────────*/
leapyear:  procedure;  parse arg y     /*year could be: Y, YY, YYY, YYYY*/
if length(y)==2 then y=left(right(date(),4),2)y    /*adjust for YY year.*/
if y//4\==0 then return 0              /* not ÷ by 4?   Not a leap year.*/
return y//100\==0 | y//400==0          /*apply 100 and 400 year rule.   */
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1 then return arg(3); return word(arg(2) 's',1)   /*plural*/
