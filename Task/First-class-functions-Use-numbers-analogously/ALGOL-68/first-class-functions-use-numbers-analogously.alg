REAL
  x  := 2,
  xi := 0.5,
  y  := 4,
  yi := 0.25,
  z  := x + y,
  zi := 1 / ( x + y );

MODE F = PROC(REAL)REAL;

PROC multiplier = (REAL n1, n2)F: ((REAL m)REAL: n1 * n2 * m);

# Numbers as members of collections #
[]REAL num list = (x, y, z),
       inv num list = (xi, yi, zi);

# Apply numbers from list #
FOR key TO UPB num list DO
  REAL n = num list[key],
       inv n = inv num list[key];
  print ((multiplier(inv n, n)(.5), new line))
OD
