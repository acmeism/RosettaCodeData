#!/usr/bin/algol68g-full --script #
# -*- coding: utf-8 -*- #

PR READ "prelude/errata.a68" PR;
PR READ "prelude/exception.a68" PR;
PR READ "prelude/math_lib.a68" PR;

CO REQUIRED BY "prelude/graph_2d.a68" CO
  MODE GREAL= REAL; # single precision #
  FORMAT greal repr = $g(-3,0)$;
PR READ "prelude/graph_2d.a68" PR;

[]REAL x = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
[]REAL y = (2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0);

test:(
  REF GRAPHDD test graph = INIT LOC GRAPHDD;
  type OF window OF test graph := "gif"; # or gif, ps, X, pnm etc #

  title OF test graph := "Plot coordinate pairs";
  sub title OF test graph := "Algol68";

  interval OF (axis OF test graph)[x axis] := (0, 8);
  label OF    (axis OF test graph)[x axis] := "X axis";

  interval OF (axis OF test graph)[y axis] := (0, 200);
  label OF    (axis OF test graph)[y axis] := "Y axis";

  PROC curve = (POINTYIELD yield)VOID:
    FOR i TO UPB x DO yield((x[i],y[i])) OD;

  (begin curve OF (METHODOF test graph))(~);
  (add curve OF   (METHODOF test graph))(curve, (red,solid));
  (end curve OF   (METHODOF test graph))(~)
);

PR READ "postlude/exception.a68" PR
