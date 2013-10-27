/*REXX program finds months with 5 weekends in them (given a date range)*/
month.=31;   yStart=1900;   yStop=2100 /*month days;  range of years.   */
month.2=0; month.4=0; month.6=0; month.9=0; month.11=0  /*¬31 day months*/
haps=0                                 /*num of five weekends happenings*/
!.=0                                   /*if a year has any five-weekends*/
     do y=yStart  to yStop             /*process the years specified.   */
        do m=1  for 12;  if month.m==0  then iterate  /*test 31-day mons*/
        dat_=y"-"right(m,2,0)'-01'     /*get date in the proper format. */
        if left(date('W',dat_,"I"),2)\=='Fr'  then iterate     /*Friday?*/
        say 'There are five weekends in'   y   date('M', dat_, "I")
        haps=haps+1;   !.y=1           /*bump ctr; indicate yr has 5 WEs*/
        end   /*m*/
     end      /*y*/
say
say 'There were ' haps " occurrences of five-weekend months in years" yStart'──►'yStop; say
#=0
       do y=yStart  to yStop;   if !.y  then iterate        /*skip if OK*/
       #=#+1
       say  'Year '     y     " doesn't have any five-weekend months."
       end   /*y*/
say
say  "There are " # " years that haven't any five─weekend months in years" yStart'──►'yStop
                                       /*stick a fork in it, we're done.*/
