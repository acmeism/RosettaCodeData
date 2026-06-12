(de diffDates (A B)
   (abs (- ($dat A "-") ($dat B "-"))) )
(println (diffDates "2019-1-1" "2019-9-30"))
(println (diffDates "2015-12-31" "2016-09-30"))
