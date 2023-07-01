      REAL FUNCTION INTG8(F,A,B,DX)	!Integrate function F.
       EXTERNAL F	!Some function of one parameter.
       REAL A,B		!Bounds.
       REAL DX		!Step.
       INTEGER N	!A counter.
        INTG8 = F(A) + F(B)	!Get the ends exactly.
        N = (B - A)/DX		!Truncates. Ignore A + N*DX = B chances.
        DO I = 1,N		!Step along the interior.
          INTG8 = INTG8 + F(A + I*DX)	!Evaluate the function.
        END DO			!On to the next.
        INTG8 = INTG8/(N + 2)*(B - A)	!Average value times interval width.
      END FUNCTION INTG8	!This is not a good calculation!

      FUNCTION TRIAL(X)		!Some user-written function.
       REAL X
        TRIAL = 1 + X		!This will do.
      END FUNCTION TRIAL	!Not the name of a library function.

      PROGRAM POKE
      INTRINSIC SIN	!Thus, not an (undeclared) ordinary variable.
      EXTERNAL TRIAL	!Likewise, but also, not an intrinsic function.
      REAL INTG8	!Don't look for the result in an integer place.
       WRITE (6,*) "Result=",INTG8(SIN,  0.0,8*ATAN(1.0),0.01)
       WRITE (6,*) "Linear=",INTG8(TRIAL,0.0,1.0,        0.01)
      END
