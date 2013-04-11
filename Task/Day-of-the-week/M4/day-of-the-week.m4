divert(-1)

define(`for',
   `ifelse($#,0,``$0'',
   `ifelse(eval($2<=$3),1,
   `pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')

dnl  julian day number corresponding to December 25th of given year
define(`julianxmas',
   `define(`yrssince0',eval($1+4712))`'define(`noOfLpYrs',
      eval((yrssince0+3)/4))`'define(`jd',
      eval(365*yrssince0+noOfLpYrs-10-($1-1501)/100+($1-1201)/400+334+25-1))`'
      ifelse(eval($1%4==0 && ($1%100!=0 || $1%400==0)),1,
         `define(`jd',incr(jd))')`'jd')

divert

for(`yr',2008,2121,
   `ifelse(eval(julianxmas(yr)%7==6),1,`yr ')')
