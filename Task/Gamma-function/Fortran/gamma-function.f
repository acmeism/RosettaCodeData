program ComputeGammaInt

  implicit none

  integer :: i

  write(*, "(3A15)") "Simpson", "Lanczos", "Builtin"
  do i=1, 10
     write(*, "(3F15.8)") my_gamma(i/3.0), lacz_gamma(i/3.0), gamma(i/3.0)
  end do

contains

  pure function intfuncgamma(x, y) result(z)
    real :: z
    real, intent(in) :: x, y

    z = x**(y-1.0) * exp(-x)
  end function intfuncgamma


  function my_gamma(a) result(g)
    real :: g
    real, intent(in) :: a

    real, parameter :: small = 1.0e-4
    integer, parameter :: points = 100000

    real :: infty, dx, p, sp(2, points), x
    integer :: i
    logical :: correction

    x = a

    correction = .false.
    ! value with x<1 gives \infty, so we use
    ! \Gamma(x+1) = x\Gamma(x)
    ! to avoid the problem
    if ( x < 1.0 ) then
       correction = .true.
       x = x + 1
    end if

    ! find a "reasonable" infinity...
    ! we compute this integral indeed
    ! \int_0^M dt t^{x-1} e^{-t}
    ! where M is such that M^{x-1} e^{-M} ≤ \epsilon
    infty = 1.0e4
    do while ( intfuncgamma(infty, x) > small )
       infty = infty * 10.0
    end do

    ! using simpson
    dx = infty/real(points)
    sp = 0.0
    forall(i=1:points/2-1) sp(1, 2*i) = intfuncgamma(2.0*(i)*dx, x)
    forall(i=1:points/2) sp(2, 2*i - 1) = intfuncgamma((2.0*(i)-1.0)*dx, x)
    g = (intfuncgamma(0.0, x) + 2.0*sum(sp(1,:)) + 4.0*sum(sp(2,:)) + &
         intfuncgamma(infty, x))*dx/3.0

    if ( correction ) g = g/a

  end function my_gamma


  recursive function lacz_gamma(a) result(g)
    real, intent(in) :: a
    real :: g

    real, parameter :: pi = 3.14159265358979324
    integer, parameter :: cg = 7

    ! these precomputed values are taken by the sample code in Wikipedia,
    ! and the sample itself takes them from the GNU Scientific Library
    real, dimension(0:8), parameter :: p = &
         (/ 0.99999999999980993, 676.5203681218851, -1259.1392167224028, &
         771.32342877765313, -176.61502916214059, 12.507343278686905, &
         -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7 /)

    real :: t, w, x
    integer :: i

    x = a

    if ( x < 0.5 ) then
       g = pi / ( sin(pi*x) * lacz_gamma(1.0-x) )
    else
       x = x - 1.0
       t = p(0)
       do i=1, cg+2
          t = t + p(i)/(x+real(i))
       end do
       w = x + real(cg) + 0.5
       g = sqrt(2.0*pi) * w**(x+0.5) * exp(-w) * t
    end if
  end function lacz_gamma

end program ComputeGammaInt
