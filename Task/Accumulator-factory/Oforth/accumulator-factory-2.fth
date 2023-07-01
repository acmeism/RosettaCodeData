: testfoo
| x y z |
   1 foo ->x
   5 x perform .
   3 foo ->y
   2.3 x perform dup . ", x accumulator value is a" . class .cr
   10  y perform dup . ", y accumulator value is a" . class .cr
   "aaa" foo ->z
   "bbb" z perform dup . ", z accumulator value is a" . class .cr
;
