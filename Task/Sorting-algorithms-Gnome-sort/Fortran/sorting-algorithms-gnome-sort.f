program example

  implicit none

  integer :: array(8) = (/ 2, 8, 6, 1, 3, 5, 4, 7 /)

  call Gnomesort(array)
  write(*,*) array

contains

subroutine Gnomesort(a)

  integer, intent(in out) :: a(:)
  integer :: i, j, temp

  i = 2
  j = 3
  do while (i <= size(a))
    if (a(i-1) <= a(i)) then
      i = j
      j = j + 1
    else
      temp = a(i-1)
      a(i-1) = a(i)
      a(i) = temp
      i = i -  1
      if (i == 1) then
        i = j
        j = j + 1
      end if
    end if
  end do

end subroutine Gnomesort

Optimized Version

      SUBROUTINE OPTIMIZEDGNOMESORT(A)     ! Nice
      IMPLICIT NONE
!
! Dummy arguments
!
      REAL , DIMENSION(0:)  ::  A
      INTENT (INOUT) A
!
! Local variables
!
      INTEGER  ::  posy
!
      DO posy = 1 , UBOUND(A , 1)       !size(a)-1
         CALL GNOMESORT(A , posy)
      END DO
      RETURN
      CONTAINS

      SUBROUTINE GNOMESORT(A , Upperbound)
      IMPLICIT NONE
!
! Dummy arguments
!
      INTEGER  ::  Upperbound
      REAL , DIMENSION(0:)  ::  A
      INTENT (IN) Upperbound
      INTENT (INOUT) A
!
! Local variables
!
      LOGICAL  ::  eval
      INTEGER  ::  posy
      REAL  ::  t
!
      eval = .FALSE.
      posy = Upperbound
      eval = (posy>0) .AND. (A(posy - 1)>A(posy))
!     do while ((posy > 0) .and. (a(posy-1) > a(posy)))
      DO WHILE ( eval )
         t = A(posy)
         A(posy) = A(posy - 1)
         A(posy - 1) = t
!
         posy = posy - 1
         eval = (posy>0)
         IF( eval )THEN     ! Have to use as a guard condition
            eval = (A(posy - 1)>A(posy))
         ELSE
            eval = .FALSE.
         END IF
      END DO
      RETURN
      END SUBROUTINE GNOMESORT

      END SUBROUTINE OPTIMIZEDGNOMESORT
!

end program example
