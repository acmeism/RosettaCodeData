my @subfactorial = 1,0,{++$ × ($^a + $^b)}…*;

say "!$_: ",@subfactorial[$_] for |^10, 20, 200;
