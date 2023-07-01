#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

CO REQUIRED BY "prelude_combinations.a68" CO
  MODE COMBDATA = INT;
#PROVIDES:#
# COMBDATA~=INT~ #
# comb ~=int list ~#
PR READ "prelude_combinations.a68" PR;

FORMAT data fmt = $g(0)$;

main:(
  INT m = 3;
  FORMAT list fmt = $"("n(m-1)(f(data fmt)",")f(data fmt)")"$;
  FLEX[0]COMBDATA test data list := (1,2,3,4,5);
# FOR COMBDATALIST recombination data IN # comb gen combinations(m, test data list #) DO (#,
##    (COMBDATALIST recombination)VOID:(
    printf ((list fmt, recombination, $l$))
# OD # ))
)
