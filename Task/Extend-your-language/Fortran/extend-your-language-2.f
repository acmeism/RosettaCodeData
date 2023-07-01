      INTEGER FUNCTION IF2(A,B)	!Combine two LOGICAL variables.
       LOGICAL A,B		!These.
        IF2 = 0			!Wasted effort if A is true.
        IF (A) IF2 = 2		!But it avoids IF ... THEN ... ELSE ... END IF blather.
        IF (B) IF2 = IF2 + 1	!This relies on IF2 being a variable. (Standard in F90+)
      END FUNCTION IF2		!Thus produce a four-way result.
