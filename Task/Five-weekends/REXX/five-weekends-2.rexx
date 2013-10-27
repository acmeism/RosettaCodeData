/*REXX program finds months with 5 weekends in them (given a date range)*/
month. =31                             /*month days; Feb. is done later.*/
month.4=30;   month.6=30;   month.9=30;   month.11=30    /*30-day months*/
@months='January February March April May June July August September October November December'
parse arg yStart yStop .               /*get the "start" & "stop" years.*/
if yStart==''  then yStart=1900        /*if not specified, use default. */
if yStop ==''  then yStop =2100        /* "  "      "       "     "     */
years=yStop-yStart+1                   /*calculate the # of yrs in range*/
haps=0                                 /*num of five weekends happenings*/
!.=0                                   /*if a year has any five-weekends*/
      do y=yStart  to yStop            /*process the years specified.   */
          do m=1  for 12;  wd.=0       /*process each month in each year*/
          if m==2  then month.2=28+leapyear(y)   /*handle # days in Feb.*/
                 do d=1  for month.m
                 ?=dow(m,d,y)          /*get day-of-week for mm/dd/yyyy.*/
                 wd.?=wd.?+1           /*?:   1=Sun,  2=Mon, ∙∙∙  7=Sat */
                 end   /*d*/
          if wd.1\==5 | wd.6\==5 | wd.7\==5  then iterate     /*5 WEs ? */
          say 'There are five weekends in'  y  word(@months,m)
          haps=haps+1;   !.y=1         /*bump ctr; indicate yr has 5 WEs*/
          end          /*m*/
      end              /*y*/
say
say  'There were ' haps " occurrence"s(haps) 'of five-weekend months in year's(years)   yStart'──►'yStop
#=0; say
           do y=yStart  to yStop;  if !.y  then iterate     /*skip if OK*/
           #=#+1
           say  'Year '    y    " doesn't have any five-weekend months."
           end   /*y*/
say
say "There are " # ' year's(#) "that haven't any five─weekend months in year"s(years) yStart'──►'yStop
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DOW─────────────────────────────────*/
dow: procedure;  parse arg m,d,y;   if m<3 then  do;  m=m+12;  y=y-1;  end
yL=left(y,2);    yr=right(y,2);   w=(d+(m+1)*26%10+yr+yr%4+yL%4+5*yL) // 7
if w==0 then w=7;  return w       /*Sunday=1,  Monday=2, ...  Saturday=7*/
/*──────────────────────────────────LEAPYEAR subroutine─────────────────*/
leapyear:  procedure;  parse arg y     /*year could be: Y, YY, YYY, YYYY*/
if length(y)==2 then y=left(right(date(),4),2)y    /*adjust for YY year.*/
if y//4\==0 then return 0              /* not ÷ by 4?   Not a leap year.*/
return y//100\==0 | y//400==0          /*apply 100 and 400 year rule.   */
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1 then return arg(3); return word(arg(2) 's',1)   /*plural*/
