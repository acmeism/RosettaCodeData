   X : Image (1..16, 1..16);
begin
   Fill (X, White);
   Line (X, ( 1, 8), ( 8,16), Black);
   Line (X, ( 8,16), (16, 8), Black);
   Line (X, (16, 8), ( 8, 1), Black);
   Line (X, ( 8, 1), ( 1, 8), Black);
   Print (X);
