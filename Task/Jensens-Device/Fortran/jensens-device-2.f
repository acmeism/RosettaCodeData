      FUNCTION SUMJ(I,LO,HI,TERM)	!Attempt to follow Jensen's Device...
       INTEGER I	!Being by reference is workable.
       INTEGER LO,HI	!Just as any other parameters.
       EXTERNAL TERM	!Thus, not a variable, but a function.
        SUMJ = 0
        DO I = LO,HI	!The specified span.
          SUMJ = SUMJ + TERM(I)	!Number and type of parameters now apparent.
        END DO		!TERM will be evaluated afresh, each time.
      END FUNCTION SUMJ	!So, almost there.

      FUNCTION THIS(I)	!A function of an integer.
       INTEGER I
        THIS = 1.0/I	!Convert to floating-point.
      END		!Since 1/i will mostly give zero.

      PROGRAM JENSEN	!Aspiration.
      EXTERNAL THIS	!Thus, not a variable, but a function.
      INTEGER I		!But this is a variable, not a function.

      WRITE (6,*) SUMJ(I,1,100,THIS)	!No statement as to the parameters of THIS.
      END
