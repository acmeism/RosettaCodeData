[[3,1,4],[1,5,9]] as $m1 | [[2,7,1],[8,2,2]] as $m2
| ( ($m1|elementwise(.[0] + .[1]; $m2) ),
    ($m1|elementwise(.[0] + 2 * .[1]; $m2) ),
    ($m1|elementwise(.[0] < .[1]; $m2) ) )
