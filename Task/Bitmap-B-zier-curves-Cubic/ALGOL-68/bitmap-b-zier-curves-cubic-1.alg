# -*- coding: utf-8 -*- #

cubic bezier OF class image :=
          (  REF IMAGE picture,
             POINT p1, p2, p3, p4,
             PIXEL color,
             UNION(INT, VOID) in n
          )VOID:
BEGIN
   INT n = (in n|(INT n):n|20); # default 20 #
   [0:n]POINT points;
   FOR i FROM LWB points TO UPB points DO
         REAL t = i / n,
              a = (1 - t)**3,
              b = 3 * t * (1 - t)**2,
              c = 3 * t**2 * (1 - t),
              d = t**3;
         x OF points [i] := ENTIER (0.5 + a * x OF p1 + b * x OF p2 + c * x OF p3 + d * x OF p4);
         y OF points [i] := ENTIER (0.5 + a * y OF p1 + b * y OF p2 + c * y OF p3 + d * y OF p4)
   OD;
   FOR i FROM LWB points TO UPB points - 1 DO
      (line OF class image)(picture, points (i), points (i + 1), color)
   OD
END # cubic bezier #;

SKIP
