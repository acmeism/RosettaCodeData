PRAGMAT READ "Basic_bitmap_storage.a68" PRAGMAT;

circle OF class image :=
          (  REF IMAGE picture,
             POINT center,
             INT radius,
             PIXEL color
          )VOID:
BEGIN
   INT f     := 1 - radius,
   POINT ddf := (0, -2 * radius),
         df := (0, radius);
   picture [x OF center, y OF center + radius] :=
   picture [x OF center, y OF center - radius] :=
   picture [x OF center + radius, y OF center] :=
   picture [x OF center - radius, y OF center] := color;
   WHILE x OF df < y OF df DO
      IF f >= 0 THEN
         y OF df -:= 1;
         y OF ddf +:= 2;
         f +:= y OF ddf
      FI;
      x OF df +:= 1;
      x OF ddf +:= 2;
      f +:= x OF ddf + 1;
      picture [x OF center + x OF df, y OF center + y OF df] :=
      picture [x OF center - x OF df, y OF center + y OF df] :=
      picture [x OF center + x OF df, y OF center - y OF df] :=
      picture [x OF center - x OF df, y OF center - y OF df] :=
      picture [x OF center + y OF df, y OF center + x OF df] :=
      picture [x OF center - y OF df, y OF center + x OF df] :=
      picture [x OF center + y OF df, y OF center - x OF df] :=
      picture [x OF center - y OF df, y OF center - x OF df] := color
   OD
END # circle #;

#
The following illustrates use:
#

IF test THEN
   REF IMAGE x = INIT LOC [1:16, 1:16] PIXEL;
   (fill OF class image)(x, (white OF class image));
   (circle OF class image)(x, (8, 8), 5, (black OF class image));
   (print OF class image)(x)
FI
