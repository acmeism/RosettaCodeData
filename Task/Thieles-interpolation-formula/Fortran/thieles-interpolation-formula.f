program thiele_trig_demo
  use, intrinsic :: ieee_arithmetic
  implicit none
  integer, parameter :: n1 = 48
  integer, parameter :: n2 = n1 * (n1 - 1) / 2
  real(16), parameter :: pi = 4q0 * atan(1q0)
  real(16), parameter :: paso = pi / (n1-1)
  real(16) :: xVal(n1), tSin(n1), tCos(n1), tTan(n1)
  real(16) :: res_sin, res_cos, res_tan, res_acos_neg1
  real(16) :: nan
  integer :: i, n_half
  real(16), allocatable :: rhot(:,:)
  integer, parameter :: rSin=0, rCos=1, rTan=2, rTrig=2

  nan = ieee_value(0.0q0, ieee_quiet_nan)
  allocate(rhot(0:rTrig, 0:n2))
  rhot = nan

  ! Build the trig table
  do i = 1, n1
    xVal(i) = (i-1) * paso
    tSin(i) = sin(xVal(i))
    tCos(i) = cos(xVal(i))
    tTan(i) = tan(xVal(i))
  end do

  n_half = n1 / 2 + 1  ! covers [0, p/2] for arcsin and arctan

  print '(A,F16.12)', "                            PI : ", pi
  print '(A,F16.12)', "                 6*arcsin(0.5) : ", 6q0 * asin(0.5q0)
  print '(A,F16.12)', "                 3*arccos(0.5) : ", 3q0 * acos(0.5q0)
  print '(A,F16.12)', "                 4*arctan(1.0) : ", 4q0 * atan(1.0q0)
  print '(A,F16.12)', "                 1*arccos(-1.0): ", acos(-1.0q0)

  rhot = nan
  res_sin = 6q0 * thieleInterpolator(tSin(1:n_half), xVal(1:n_half), rSin, 0.5q0, 0, n_half-1, rhot)
  rhot = nan
  res_cos = 3q0 * thieleInterpolator(tCos, xVal, rCos, 0.5q0, 0, n1-1, rhot)
  rhot = nan
  res_tan = 4q0 * thieleInterpolator(tTan(1:n_half), xVal(1:n_half), rTan, 1.0q0, 0, n_half-1, rhot)
  rhot = nan
  res_acos_neg1 = thieleInterpolator(tCos, xVal, rCos, -1.0q0, 0, n1-1, rhot)
  print '(A,F16.12)', "6*thiele(tSin,xVal,rSin,0.5,0) : ", res_sin
  print '(A,F16.12)', "3*thiele(tCos,xVal,rCos,0.5,0) : ", res_cos
  print '(A,F16.12)', "4*thiele(tTan,xVal,rTan,1.0,0) : ", res_tan
  print '(A,F16.12)', "1*thiele(tCos,xVal,rCos,-1.0,0): ", res_acos_neg1

contains

  recursive function rho(x, y, rdx, i, n, rhot) result(val)
    real(16), intent(in) :: x(:), y(:)
    integer, intent(in) :: rdx, i, n
    real(16), intent(inout) :: rhot(0:,0:)
    real(16) :: val
    integer :: idx

    if (n < 0) then
      val = 0q0
      return
    end if
    if (n == 0) then
      val = y(i+1)
      return
    end if

    idx = (size(x)-1 - n) * (size(x) - n) / 2 + i
    if (ieee_is_nan(rhot(rdx, idx))) then
      rhot(rdx, idx) = (x(i+1) - x(i+1 + n)) / (rho(x, y, rdx, i, n-1, rhot) - rho(x, y, rdx, i+1, n-1, rhot)) &
                       + rho(x, y, rdx, i+1, n-2, rhot)
    end if
    val = rhot(rdx, idx)
  end function rho

  recursive function thieleInterpolator(x, y, rdx, xin, n, nmax, rhot) result(val)
    real(16), intent(in) :: x(:), y(:), xin
    integer, intent(in) :: rdx, n, nmax
    real(16), intent(inout) :: rhot(0:,0:)
    real(16) :: val

    if (n > nmax) then
      val = 1.0q0
      return
    end if
    val = rho(x, y, rdx, 0, n, rhot) - rho(x, y, rdx, 0, n-2, rhot) + (xin - x(n+1)) / thieleInterpolator(x, y, rdx, xin, n+1, nmax, rhot)
  end function thieleInterpolator

end program thiele_trig_demo
