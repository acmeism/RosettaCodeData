! Works with gfortran but needs the option
!   -assume realloc_lhs
! when compiled with Intel Fortran.

program gauss
  implicit none
  integer, parameter :: p = 16 ! quadruple precision
  integer            :: n = 10, k
  real(kind=p), allocatable :: r(:,:)
  real(kind=p)       :: z, a, b, exact
  do n = 1,20
    a = -3; b = 3
    r = gaussquad(n)
    z = (b-a)/2*dot_product(r(2,:),exp((a+b)/2+r(1,:)*(b-a)/2))
    exact = exp(3.0_p)-exp(-3.0_p)
    print "(i0,1x,g0,1x,g10.2)",n, z, z-exact
  end do

  contains

  function gaussquad(n) result(r)
  integer                 :: n
  real(kind=p), parameter :: pi = 4*atan(1._p)
  real(kind=p)            :: r(2, n), x, f, df, dx
  integer                 :: i,  iter
  real(kind = p), allocatable :: p0(:), p1(:), tmp(:)

  p0 = [1._p]
  p1 = [1._p, 0._p]

  do k = 2, n
     tmp = ((2*k-1)*[p1,0._p]-(k-1)*[0._p, 0._p,p0])/k
     p0 = p1; p1 = tmp
  end do
  do i = 1, n
    x = cos(pi*(i-0.25_p)/(n+0.5_p))
    iter = 0
    do iter = 1, 10
      f = p1(1); df = 0._p
      do k = 2, size(p1)
        df = f + x*df
        f  = p1(k) + x * f
      end do
      dx =  f / df
      x = x - dx
      if (abs(dx)<10*epsilon(dx)) exit
    end do
    r(1,i) = x
    r(2,i) = 2/((1-x**2)*df**2)
  end do
  end function
end program
