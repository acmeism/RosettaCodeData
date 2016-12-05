/*REXX program  finds  months  that contain  five weekends   (given a date range).      */
month. =31                                       /*days in "all" the months.            */
month.2=0; month.4=0; month.6=0; month.9=0; month.11=0              /*not 31 day months.*/
month.4=30;  month.6=30; month.9=30; month.11=30 /*all the  months with  thirty-days.   */
parse arg yStart yStop .                         /*get the  "start"  and  "stop"  years.*/
if yStart=='' | yStart==","  then yStart= 1900   /*Not specified?  Then use the default.*/
if yStop =='' | yStop ==","  then yStop = 2100   /* "      "         "   "   "     "    */
years=yStop - yStart + 1                         /*calculate the number of yrs in range.*/
haps=0                                           /*number of five weekends happenings.  */
!.=0;                 @5w= 'five-weekend months' /*flag if a year has any five-weekends.*/
       do y=yStart  to yStop                     /*process the years specified.         */
           do m=1  for 12;  if month.m==0  then iterate       /*only test 31-day months.*/
           dat_= y"-"right(m,2,0)'-01'           /*get the date in the desired format.  */
           if left(date('W',dat_,"I"),2)\=='Fr'  then iterate     /*isn't not a Friday? */
           say 'There are five weekends in'    y     date('M', dat_, "I")
           haps=haps+1;   !.y=1                  /*bump counter; indicate yr has 5 WE's.*/
           end   /*m*/
       end      /*y*/
say
say  'There were ' haps " occurrence"s(haps) 'of'  @5w "in year"s(years)  yStart'──►'yStop
#=0; say
           do y=yStart  to yStop;  if !.y  then iterate                    /*skip if OK.*/
           #=#+1
           say  'Year '    y    " doesn't have any five-weekend months."
           end   /*y*/
say
say  "There are " # ' year's(#) "that haven't any"  @5w 'in year's(years) yStart'──►'yStop
