   X : Image (1..16, 1..16);
begin
   Fill (X, White);
   Quadratic_Bezier (X, (8, 2), (13, 8), (2, 15), Black);
   Print (X);
