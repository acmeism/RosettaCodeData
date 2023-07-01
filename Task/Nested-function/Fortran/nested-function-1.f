      FUNCTION F(X)
       REAL X
       DIST(U,V,W) = X*SQRT(U**2 + V**2 + W**2)    !The contained function.
        T = EXP(X)
        F = T + DIST(T,SIN(X),ATAN(X) + 7)         !Invoked...
      END
