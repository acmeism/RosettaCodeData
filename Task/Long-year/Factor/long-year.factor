USING: calendar formatting io kernel math.ranges sequences ;

: long-year? ( n -- ? ) 12 28 <date> week-number 53 = ;

"Year  Long?\n-----------" print 1990 2021 [a,b]
[ dup long-year? "yes" "no" ? "%d  %s\n" printf ] each
