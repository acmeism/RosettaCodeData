#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

MODE YIELDREAL = PROC(REAL)VOID;
MODE GENREAL = PROC(YIELDREAL)VOID;

PROC gen real of vector = ([]REAL data, YIELDREAL yield)VOID:
  FOR i FROM LWB data TO UPB data DO yield(data[i]) OD;

PROC real sum sq of gen = (GENREAL gen real)REAL: (
  REAL sum:=0;
# FOR REAL value IN # gen real(#) DO (#
     (REAL value)VOID:(
       sum+:=value**2
# OD #));
  sum
);

PROC real sum map of gen = (PROC(REAL)REAL func, GENREAL gen real)REAL: (
  REAL sum:=0;
# FOR REAL value IN # gen real(#) DO (#
     (REAL value)VOID:(
       sum+:=func(value)
# OD #));
  sum
);

OP GEN = ([]REAL array)GENREAL:gen real of vector(array,);

OP (GENREAL #gen real#)REAL SUMSQ = real sum sq of gen;

PRIO SUMMAP = 5;
OP (PROC(REAL)REAL #func#, GENREAL #gen real#)REAL SUMMAP = real sum map of gen;

test:(
  []REAL data = (3, 1, 4, 1, 5, 9);
# Permutations of the above routines #
  printf(($"real sum sq GEN: "g(0)l$, real sum sq of gen(GEN data)));
  printf(($"real sum sq real gen: "g(0)l$, real sum sq of gen(gen real of vector(data,))));
  printf(($"real sum map real gen: "g(0)l$, real sum map of gen(((REAL x)REAL: x*x),gen real of vector(data,))));
  printf(($"SUMSQ real gen: "g(0)l$, SUMSQ gen real of vector(data,)));
  printf(($"SUMSQ GEN: "g(0)l$, SUMSQ GEN data));
  printf(($"sq SUMMAP GEN: "g(0)l$, ((REAL x)REAL: x*x)SUMMAP GEN data))
)
