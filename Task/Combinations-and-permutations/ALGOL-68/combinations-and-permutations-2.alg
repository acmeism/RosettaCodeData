#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

CO REQUIRED by "prelude_combinations_and_permutations.a68" CO
  MODE CPINT = #LONG# INT;
  MODE CPOUT = #LONG# INT; # the answer, can be REAL #
  MODE CPREAL = REAL; # the answer, can be REAL #
  PROC cp fix value error = (#REF# CPARGS args)BOOL: (
    putf(stand error, ($"Value error: "g(0)gg(0)"arg out of range"l$,
                         n OF args, name OF args, k OF args));
    FALSE # unfixable #
  );
#PROVIDES:#
# OP C = (CP~,CP~)CP~: ~ #
# OP P = (CP~,CP~)CP~: ~ #
PR READ "prelude_combinations_and_permutations.a68" PR;

printf($"A sample of Permutations from 1 to 12:"l$);
FOR i FROM 4 BY 1 TO 12 DO
  INT first = i - 2,
      second = i - ENTIER sqrt(i);
  printf(($g(0)" P "g(0)" = "g(0)$, i, first, i P first, $", "$));
  printf(($g(0)" P "g(0)" = "g(0)$, i, second, i P second, $l$))
OD;

printf($l"A sample of Combinations from 10 to 60:"l$);
FOR i FROM 10 BY 10 TO 60 DO
  INT first = i - 2,
      second = i - ENTIER sqrt(i);
  printf(($"("g(0)" C "g(0)") = "g(0)$, i, first, i C first, $", "$));
  printf(($"("g(0)" C "g(0)") = "g(0)$, i, second, i C second, $l$))
OD;

printf($l"A sample of Permutations from 5 to 15000:"l$);
FOR i FROM 5 BY 10 TO 150 DO
  REAL r = i,
       first = r - 2,
       second = r - ENTIER sqrt(r);
  printf(($g(0)" P "g(0)" = "g(-real width,real width-5,-1)$, r, first, r P first, $", "$));
  printf(($g(0)" P "g(0)" = "g(-real width,real width-5,-1)$, r, second, r P second, $l$))
OD;

printf($l"A sample of Combinations from 10 to 190:"l$);
FOR i FROM 100 BY 100 TO 1000 DO
  REAL r = i,
       first = r - 2,
       second = r - ENTIER sqrt(r);
  printf(($"("g(0)" C "g(0)") = "g(0,1)$, r, first, r C first, $", "$));
  printf(($"("g(0)" C "g(0)") = "g(0,1)$, r, second, r C second, $l$))
OD
