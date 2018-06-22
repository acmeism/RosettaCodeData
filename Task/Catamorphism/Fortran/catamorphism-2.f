      INTEGER FUNCTION IFOLD(F,A,N)	!"Catamorphism"...
       INTEGER F	!We're working only with integers.
       EXTERNAL F	!This is a function, not an array.
       INTEGER A(*)	!An 1-D array, of unspecified size.
       INTEGER N	!The number of elements.
       INTEGER I	!A stepper.
        IFOLD = 0		!A default value.
        IF (N.LE.0) RETURN	!Dodge silly invocations.
        IFOLD = A(1)		!The function is to have two arguments.
        IF (N.EQ.1) RETURN	!So, if there is only one element, silly.
        DO I = 2,N		!Otherwise, stutter along the array.
          IFOLD = F(IFOLD,A(I))		!Applying the function.
        END DO			!On to the next element.
      END FUNCTION IFOLD!Thus, F(A(1),A(2)), or F(F(A(1),A(2)),A(3)), or F(F(F(A(1),A(2)),A(3)),A(4)), etc.

      INTEGER FUNCTION IADD(I,J)
       INTEGER I,J
        IADD = I + J
      END FUNCTION IADD

      INTEGER FUNCTION IMUL(I,J)
       INTEGER I,J
        IMUL = I*J
      END FUNCTION IMUL

      INTEGER FUNCTION IDIV(I,J)
       INTEGER I,J
        IDIV = I/J
      END FUNCTION IDIV

      INTEGER FUNCTION IVID(I,J)
       INTEGER I,J
        IVID = J/I
      END FUNCTION IVID

      PROGRAM POKE
      INTEGER ENUFF
      PARAMETER (ENUFF = 6)
      INTEGER A(ENUFF)
      PARAMETER (A = (/1,2,3,4,5,6/))
      INTEGER MSG
      EXTERNAL IADD,IMUL,IDIV,IVID	!Warn that these are the names of functions.

      MSG = 6	!Standard output.
      WRITE (MSG,1) ENUFF,A
    1 FORMAT ('To apply a function in the "catamorphic" style ',
     1 "to the ",I0," values ",/,(20I3))

      WRITE (MSG,*) "Iadd",IFOLD(IADD,A,ENUFF)
      WRITE (MSG,*) "Imul",IFOLD(IMUL,A,ENUFF)
      WRITE (MSG,*) "Idiv",IFOLD(IDIV,A,ENUFF)
      WRITE (MSG,*) "Ivid",IFOLD(IVID,A,ENUFF)
      END PROGRAM POKE
