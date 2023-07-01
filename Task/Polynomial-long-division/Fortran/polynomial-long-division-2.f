program PolyDivTest
  use Polynom
  implicit none

  real, dimension(:), allocatable :: q
  real, dimension(:), allocatable :: r

  !! three tests from Wikipedia, plus an extra
  !call poly_long_div( (/ -3., 1. /), (/ -42., 0.0, -12., 1. /), q, r)
  call poly_long_div( (/ -42., 0.0, -12., 1. /), (/ -3., 1. /), q, r)
  !call poly_long_div( (/ -42., 0.0, -12., 1. /), (/ -3., 1., 1. /), q, r)
  !call poly_long_div( (/ 2., 3., 1. /), (/ 1., 1. /), q, r)

  call poly_print(q)
  call poly_print(r)
  deallocate(q, r)

end program PolyDivTest
