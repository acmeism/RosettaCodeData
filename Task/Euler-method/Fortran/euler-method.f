program euler_method
use iso_fortran_env, only: real64
implicit none

abstract interface
  ! a derivative dy/dt as function of y and t
  function derivative(y, t)
    use iso_fortran_env, only: real64
    real(real64) :: derivative
    real(real64), intent(in) :: t, y
  end function
end interface

real(real64), parameter :: T_0 = 100, T_room = 20, k = 0.07, a = 0, b = 100, &
    h(3) = [2.0, 5.0, 10.0]

integer :: i

! loop over all step sizes
do i = 1, 3
  call euler(newton_cooling, T_0, a, b, h(i))
end do

contains

! Approximates y(t) in y'(t) = f(y, t) with y(a) = y0 and t = a..b and the
! step size h.
subroutine euler(f, y0, a, b, h)
  procedure(derivative) :: f
  real(real64), intent(in) :: y0, a, b, h
  real(real64) :: t, y

  if (a > b) return
  if (h <= 0) stop "negative step size"

  print '("# h = ", F0.3)', h

  y = y0
  t = a

  do
    print *, t, y
    t = t + h
    if (t > b) return
    y = y + h * f(y, t)
  end do
end subroutine


! Example: Newton's cooling law, f(T, _) = -k*(T - T_room)
function newton_cooling(T, unused) result(dTdt)
  real(real64) :: dTdt
  real(real64), intent(in) :: T, unused
  dTdt = -k * (T - T_room)
end function

end program
