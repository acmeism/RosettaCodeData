   X : Image (1..16, 1..16);
begin
   Fill (X, White);
   Cubic_Bezier (X, (16, 1), (1, 4), (3, 16), (15, 11), Black);
   Print (X);
