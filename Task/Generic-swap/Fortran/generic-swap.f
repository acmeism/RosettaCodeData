MODULE Genericswap
  IMPLICIT NONE

  INTERFACE Swap
    MODULE PROCEDURE Swapint, Swapreal, Swapstring
  END INTERFACE

CONTAINS

  SUBROUTINE Swapint(a, b)
    INTEGER, INTENT(IN OUT) :: a, b
    INTEGER :: temp
    temp = a ; a = b ; b = temp
  END SUBROUTINE Swapint

  SUBROUTINE Swapreal(a, b)
    REAL, INTENT(IN OUT) :: a, b
    REAL :: temp
    temp = a ; a = b ; b = temp
  END SUBROUTINE Swapreal

  SUBROUTINE Swapstring(a, b)
    CHARACTER(*), INTENT(IN OUT) :: a, b
    CHARACTER(len(a)) :: temp
    temp = a ; a = b ; b = temp
  END SUBROUTINE Swapstring
END MODULE Genericswap

PROGRAM EXAMPLE
  USE Genericswap
  IMPLICIT NONE
  INTEGER :: i1 = 1, i2 = 2
  REAL :: r1 = 1.0, r2 = 2.0
  CHARACTER(3) :: s1="abc", s2="xyz"

  CALL Swap(i1, i2)
  CALL Swap(r1, r2)
  CALL Swap(s1, s2)

  WRITE(*,*) i1, i2   ! Prints 2 and 1
  WRITE(*,*) r1, r2   ! Prints 2.0 and 1.0
  WRITE(*,*) s1, s2   ! Prints xyz and abc
END PROGRAM EXAMPLE
