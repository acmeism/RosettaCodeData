define(`female',`ifelse(0,$1,1,`eval($1 - male(female(decr($1))))')')dnl
define(`male',`ifelse(0,$1,0,`eval($1 - female(male(decr($1))))')')dnl
define(`loop',`ifelse($1,$2,,`$3($1) loop(incr($1),$2,`$3')')')dnl
loop(0,20,`female')
loop(0,20,`male')
