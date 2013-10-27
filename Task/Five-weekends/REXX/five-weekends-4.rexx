/*REXX program finds months with 5 weekends in them (given a date range)*/
month. =31                             /*month days;   Feb. is skipped. */
month.4=30;   month.6=30;   month.9=30;   month.11=30    /*30-day months*/
yStart=1900;  yStop=2100               /*define start and stop years.   */
haps=0                                 /*num of five weekends happenings*/
!.=0                                   /*if a year has any five-weekends*/
       do y=yStart to yStop            /*process the years specified.   */
           do m=1  for 12;    wd.=0    /*each month except Feb, each yr.*/
           if m==2  then iterate       /*if month is February, skip it. */
                 do d=1  for month.m; dat_=y"-"right(m,2,0)'-'right(d,2,0)
                 parse  upper  value   date('W', dat_, "I")    with    ? 3
                 wd.?=wd.?+1           /*? is 1st 2 chars of tge weekday*/
                 end   /*d*/           /*WD.su=# of Sundays in the month*/
           if wd.su\==5 | wd.fr\==5 | wd.sa\==5 then iterate  /*5 W.E.s?*/
           say 'There are five weekends in'   y   date('M', dat_, "I")
           haps=haps+1;   !.y=1        /*bump ctr; indicate yr has 5 WEs*/
           end         /*m*/
       end             /*y*/
say
say 'There were ' haps " occurrences of five-weekend months in years" yStart'──►'yStop; say
#=0
         do y=yStart  to yStop;   if !.y  then iterate      /*skip if OK*/
         #=#+1
         say  'Year '     y     " doesn't have any five-weekend months."
         end   /*y*/
say
say  "There are " # " years that haven't any five─weekend months in years" yStart'──►'yStop
                                       /*stick a fork in it, we're done.*/
