      REAL this,that
      DIST(X,Y,Z) = SQRT(X**2 + Y**2 + Z**2) + this/that !One arithmetic statement, possibly lengthy.
      ...
      D = 3 + DIST(X1 - X2,YDIFF,SQRT(ZD2))              !Invoke local function DIST.
