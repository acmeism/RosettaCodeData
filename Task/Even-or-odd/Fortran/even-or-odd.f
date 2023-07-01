!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Tue May 21 20:22:56
!
!a=./f && make $a && OMP_NUM_THREADS=2 $a < unixdict.txt
!gfortran -std=f2008 -Wall -ffree-form -fall-intrinsics f.f08 -o f
! n     odd    even
!-6    F    T
!-5    T    F
!-4    F    T
!-3    T    F
!-2    F    T
!-1    T    F
! 0    F    T
! 1    T    F
! 2    F    T
! 3    T    F
! 4    F    T
! 5    T    F
! 6    F    T
! -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6       n
!  F  T  F  T  F  T  F  T  F  T  F  T  F     odd
!  T  F  T  F  T  F  T  F  T  F  T  F  T    even
!
!Compilation finished at Tue May 21 20:22:56


module bit0parity

  interface odd
    module procedure odd_scalar, odd_list
  end interface

  interface even
    module procedure even_scalar, even_list
  end interface

contains

  logical function odd_scalar(a)
    implicit none
    integer, intent(in) :: a
    odd_scalar = btest(a, 0)
  end function odd_scalar

  logical function even_scalar(a)
    implicit none
    integer, intent(in) :: a
    even_scalar = .not. odd_scalar(a)
  end function even_scalar

  function odd_list(a) result(rv)
    implicit none
    integer, dimension(:), intent(in) :: a
    logical, dimension(size(a)) :: rv
    rv = btest(a, 0)
  end function odd_list

  function even_list(a) result(rv)
    implicit none
    integer, dimension(:), intent(in) :: a
    logical, dimension(size(a)) :: rv
    rv = .not. odd_list(a)
  end function even_list

end module bit0parity

program oe
  use bit0parity
  implicit none
  integer :: i
  integer, dimension(13) :: j
  write(6,'(a2,2a8)') 'n', 'odd', 'even'
  write(6, '(i2,2l5)') (i, odd_scalar(i), even_scalar(i), i=-6,6)
  do i=-6, 6
    j(i+7) = i
  end do
  write(6, '((13i3),a8/(13l3),a8/(13l3),a8)') j, 'n', odd(j), 'odd', even(j), 'even'
end program oe
