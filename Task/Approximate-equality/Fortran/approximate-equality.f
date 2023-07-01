program main
  implicit none

  integer                       :: i
  double precision, allocatable :: vals(:)

  vals = [ 100000000000000.01d0,          100000000000000.011d0,   &
    &      100.01d0,                      100.011d0,               &
    &      10000000000000.001d0/10000d0,  1000000000.0000001000d0, &
    &      0.001d0,                       0.0010000001d0,          &
    &      0.000000000000000000000101d0,  0d0,                     &
    &      sqrt(2d0)*sqrt(2d0),           2d0,                     &
    &     -sqrt(2d0)*sqrt(2d0),          -2d0,                     &
    &      3.14159265358979323846d0,      3.14159265358979324d0    ]

  do i = 1, size(vals)/2
    print '(ES30.18, A, ES30.18, A, L)', vals(2*i-1), ' == ', vals(2*i), ' ? ', eq_approx(vals(2*i-1), vals(2*i))
  end do

contains

  logical function eq_approx(a, b, reltol, abstol)
    !! is a approximately equal b?

    double precision, intent(in)           :: a, b
      !! values to compare
    double precision, intent(in), optional :: reltol, abstol
      !! relative and absolute error thresholds.
      !! defaults: epsilon, smallest non-denormal number

    double precision :: rt, at

    rt = epsilon(1d0)
    at = tiny(1d0)
    if (present(reltol)) rt = reltol
    if (present(abstol)) at = abstol

    eq_approx = abs(a - b) .le. max(rt * max(abs(a), abs(b)), at)
    return
  end function

end program
