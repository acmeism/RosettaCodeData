!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Mon May 20 23:05:46
!
!a=./f && make $a && $a < unixdict.txt
!gfortran -std=f2003 -Wall -ffree-form f.f03 -o f
!
!ternary not
! 1.0 0.5 0.0
!
!
!ternary and
! 0.0 0.0 0.0
! 0.0 0.5 0.5
! 0.0 0.5 1.0
!
!
!ternary or
! 0.0 0.5 1.0
! 0.5 0.5 1.0
! 1.0 1.0 1.0
!
!
!ternary if
! 1.0 1.0 1.0
! 0.5 0.5 1.0
! 0.0 0.5 1.0
!
!
!ternary eq
! 1.0 0.5 0.0
! 0.5 0.5 0.5
! 0.0 0.5 1.0
!
!
!Compilation finished at Mon May 20 23:05:46


!This program is based on the j implementation
!not=: -.
!and=: <.
!or =: >.
!if =: (>. -.)"0~
!eq =: (<.&-. >. <.)"0

module trit

  real, parameter :: true = 1,  false = 0, maybe = 0.5

contains

  real function tnot(y)
    real, intent(in) :: y
    tnot = 1 - y
  end function tnot

  real function tand(x, y)
    real, intent(in) :: x, y
    tand = min(x, y)
  end function tand

  real function tor(x, y)
    real, intent(in) :: x, y
    tor = max(x, y)
  end function tor

  real function tif(x, y)
    real, intent(in) :: x, y
    tif = tor(y, tnot(x))
  end function tif

  real function teq(x, y)
    real, intent(in) :: x, y
    teq = tor(tand(tnot(x), tnot(y)), tand(x, y))
  end function teq

end module trit

program ternaryLogic
  use trit
  integer :: i
  real, dimension(3) :: a = [false, maybe, true] ! (/ ... /)
  write(6,'(/a)')'ternary not' ; write(6, '(3f4.1/)') (tnot(a(i)), i = 1 , 3)
  write(6,'(/a)')'ternary and' ; call table(tand, a, a)
  write(6,'(/a)')'ternary or' ; call table(tor, a, a)
  write(6,'(/a)')'ternary if' ; call table(tif, a, a)
  write(6,'(/a)')'ternary eq' ; call table(teq, a, a)

contains

  subroutine table(u, x, y) ! for now, show the table.
    real, external :: u
    real, dimension(3), intent(in) :: x, y
    integer :: i, j
    write(6, '(3(3f4.1/))') ((u(x(i), y(j)), j=1,3), i=1,3)
  end subroutine table

end program ternaryLogic
