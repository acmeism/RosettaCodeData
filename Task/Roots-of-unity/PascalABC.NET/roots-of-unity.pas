function RootsOfUnity(n: integer)
  := (0..n-1).Select(x -> Complex.FromPolarCoordinates(1, 2 * PI * x / n));

begin
  RootsOfUnity(3).PrintLines
end.
