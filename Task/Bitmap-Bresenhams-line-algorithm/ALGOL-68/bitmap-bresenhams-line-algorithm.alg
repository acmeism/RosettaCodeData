PRAGMAT READ "Basic_bitmap_storage.a68" PRAGMAT;

line OF class image := (REF IMAGE picture, POINT start, stop, PIXEL color)VOID:
BEGIN
   REAL dx = ABS (x OF stop - x OF start),
        dy = ABS (y OF stop - y OF start);
   REAL err;
   POINT here := start,
         step := (1, 1);
   IF x OF start > x OF stop THEN
      x OF step := -1
   FI;
   IF y OF start > y OF stop THEN
      y OF step := -1
   FI;
   IF dx > dy THEN
      err := dx / 2;
      WHILE x OF here /= x OF stop DO
         picture[x OF here, y OF here] := color;
         err -:= dy;
         IF err < 0 THEN
            y OF here +:= y OF step;
            err +:= dx
         FI;
         x OF here +:= x OF step
      OD
   ELSE
      err := dy / 2;
      WHILE y OF here /= y OF stop DO
         picture[x OF here, y OF here] := color;
         err -:= dx;
         IF err < 0 THEN
            x OF here +:= x OF step;
            err +:= dy
         FI;
         y OF here +:= y OF step
      OD
   FI;
   picture[x OF here, y OF here] := color # ensure dots to be drawn #
END # line #;

###
The test program:
###
IF test THEN
   REF IMAGE x = INIT LOC[1:16, 1:16]PIXEL;
   (fill OF class image)(x, white OF class image);
   (line OF class image)(x, ( 1, 8), ( 8,16), black OF class image);
   (line OF class image)(x, ( 8,16), (16, 8), black OF class image);
   (line OF class image)(x, (16, 8), ( 8, 1), black OF class image);
   (line OF class image)(x, ( 8, 1), ( 1, 8), black OF class image);
   (print OF class image)(x)
FI
