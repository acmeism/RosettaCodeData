INT pix = 300, max iter = 256, REAL zoom = 0.33 / pix;
[-pix : pix, -pix : pix] INT plane;
COMPL ctr = 0.05 I 0.75 # center of set #;

# Compute the length of an orbit. #
PROC iterate = (COMPL z0) INT:
  BEGIN COMPL z := 0, INT iter := 1;
        WHILE (iter +:= 1) < max iter # not converged # AND ABS z < 2 # not diverged #
        DO z := z * z + z0
        OD;
        iter
  END;

# Compute set and find maximum orbit length. #
INT max col := 0;
FOR x FROM -pix TO pix
DO FOR y FROM -pix TO pix
   DO COMPL z0 = ctr + (x * zoom) I (y * zoom);
      IF (plane [x, y] := iterate (z0)) < max iter
      THEN (plane [x, y] > max col | max col := plane [x, y])
      FI
   OD
OD;

# Make a plot. #
FILE plot;
INT num pix = 2 * pix + 1;
make device (plot, "gif", whole (num pix, 0) + "x" + whole (num pix, 0));
open (plot, "mandelbrot.gif", stand draw channel);
FOR x FROM -pix TO pix
DO FOR y FROM -pix TO pix
   DO INT col = (plane [x, y] > max col | max col | plane [x, y]);
      REAL c = sqrt (1- col / max col); # sqrt to enhance contrast #
      draw colour (plot, c, c, c);
      draw point (plot, (x + pix) / (num pix - 1), (y + pix) / (num pix  - 1))
   OD
OD;
close (plot)
