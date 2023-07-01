\ format 'n' digits of the double word 'd'
: #n ( d n -- d )  0 ?do # loop ;

\ ud.0 prints an unsigned double
: ud.0 ( d n -- )  <# 1- #n #s #> type ;

\ d.0 prints a signed double
: d.0 ( d n -- )  >r tuck dabs <# r> 1- #n #s rot sign #> type ;
