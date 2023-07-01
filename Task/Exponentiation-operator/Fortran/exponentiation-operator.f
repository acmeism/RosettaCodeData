MODULE Exp_Mod
IMPLICIT NONE

INTERFACE OPERATOR (.pow.)    ! Using ** instead would overload the standard exponentiation operator
  MODULE PROCEDURE Intexp, Realexp
END INTERFACE

CONTAINS

  FUNCTION Intexp (base, exponent)
    INTEGER :: Intexp
    INTEGER, INTENT(IN) :: base, exponent
    INTEGER :: i

    IF (exponent < 0) THEN
       IF (base == 1) THEN
          Intexp = 1
       ELSE
          Intexp = 0
       END IF
       RETURN
    END IF
    Intexp = 1
    DO i = 1, exponent
      Intexp = Intexp * base
    END DO
  END FUNCTION IntExp

  FUNCTION Realexp (base, exponent)
    REAL :: Realexp
    REAL, INTENT(IN) :: base
    INTEGER, INTENT(IN) :: exponent
    INTEGER :: i

    Realexp = 1.0
    IF (exponent < 0) THEN
       DO i = exponent, -1
          Realexp = Realexp / base
       END DO
    ELSE
       DO i = 1, exponent
          Realexp = Realexp * base
       END DO
    END IF
  END FUNCTION RealExp
END MODULE Exp_Mod

PROGRAM EXAMPLE
USE Exp_Mod
  WRITE(*,*) 2.pow.30, 2.0.pow.30
END PROGRAM EXAMPLE
