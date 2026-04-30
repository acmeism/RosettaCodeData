! Ramanujan's constant  e^(pi * sqrt(163))
!
! Background (from the j-function q-expansion):
!   j(tau) = 1/q + 744 + 196884*q + ...  where q = e^(2*pi*i*tau)
!   At tau = (1 + i*sqrt(d))/2,  q = -e^(-pi*sqrt(d))
!   For Heegner numbers d the class number of Q(sqrt(-d)) = 1, so j is
!   a perfect cube integer. Rearranging gives
!
!     e^(pi*sqrt(d))  =  n^3 + 744 - 196884*e^(-pi*sqrt(d)) + ...
!
!   where n^3 = |j| = 96^3, 960^3, 5280^3, 640320^3 for d = 19,43,67,163.
!   The residual term shrinks exponentially, making e^(pi*sqrt(d)) nearly
!   an integer that improves dramatically with the four largest Heegner numbers.
!
! real128 (quad precision, 113-bit mantissa) gives ~33.4 significant decimal
! digits, satisfying the 32-digit requirement.

program ramujan
  use iso_fortran_env, only: real128
  implicit none

  integer, parameter :: heegner4(4) = [19, 43, 67, 163]

  ! Exact nearest integers: n^3 + 744 for each Heegner d
  integer(kind=8), parameter :: nearest4(4) = &
    [ 885480_8, 884736744_8, 147197952744_8, 262537412640768744_8 ]

  real(kind=real128) :: pi, val, frac
  integer :: i

  pi = acos(-1.0_real128)

  ! ----------------------------------------------------------------
  ! Ramanujan's constant
  ! ----------------------------------------------------------------
  write(*,'(A)') "Ramanujan's constant  =  e^(pi * sqrt(163))"
  write(*,'(A)') repeat('=', 58)
  val = exp(pi * sqrt(163.0_real128))
  write(*,'(2X,F55.32)') val
  write(*,'(A)') '  Precision: real128 quad (~33 sig. figs.); last ~17 decimal digits beyond type limit'
  write(*,*)

  ! ----------------------------------------------------------------
  ! Near-integer demonstration for the last four Heegner numbers
  !
  !   Residual  =  e^(pi*sqrt(d))  -  nearest integer
  !
  ! d=19:  residual ~ -0.222   (n = 96,    n^3+744 = 885480)
  ! d=43:  residual ~ -2.3e-4  (n = 960,   n^3+744 = 884736744)
  ! d=67:  residual ~ -2.1e-6  (n = 5280,  n^3+744 = 147197952744)
  ! d=163: residual ~ -7.5e-13 (n = 640320, n^3+744 = 262537412640768744)
  ! ----------------------------------------------------------------
  write(*,'(A)') 'Near-integer test: last four Heegner numbers d = 19, 43, 67, 163'
  write(*,'(A)') repeat('-', 84)
  write(*,'(A4,3X,A55,3X,A18)') 'd', 'e^(pi*sqrt(d))  [32 decimal places]', 'residual'
  write(*,'(A)') repeat('-', 84)

  do i = 1, 4
    val  = exp(pi * sqrt(real(heegner4(i), real128)))
    frac = val - real(nearest4(i), real128)
    write(*,'(I4,3X,F55.32,3X,ES18.6)') heegner4(i), val, frac
  end do

  write(*,*)
  write(*,'(A)') 'The residual shrinks by ~10^3 for each step up the Heegner ladder.'

end program ramujan
