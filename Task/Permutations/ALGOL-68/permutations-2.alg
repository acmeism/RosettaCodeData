#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

CO REQUIRED BY "prelude_permutations.a68" CO
  MODE PERMDATA = INT;
#PROVIDES:#
# PERM*=INT* #
# perm *=int list *#
PR READ "prelude_permutations.a68" PR;

main:(
  FLEX[0]PERMDATA test case := (1, 22, 333, 44444);

  INT upb data list = UPB test case;
  FORMAT
    data fmt := $g(0)$,
    data list fmt := $"("n(upb data list-1)(f(data fmt)", ")f(data fmt)")"$;

# FOR DATALIST permutation IN # perm gen permutations(test case#) DO (#,
##   (PERMDATALIST permutation)VOID:(
    printf((data list fmt, permutation, $l$))
# OD #))

)
