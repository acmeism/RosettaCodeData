program PolynomalFitting
  use fitting
  implicit none

  ! let us test it
  integer, parameter      :: degree = 2
  integer, parameter      :: dp = selected_real_kind(15, 307)
  integer                 :: i
  real(dp), dimension(11) :: x = (/ (i,i=0,10) /)
  real(dp), dimension(11) :: y = (/ 1,   6,  17,  34, &
                                   57,  86, 121, 162, &
                                   209, 262, 321 /)
  real(dp), dimension(degree+1) :: a

  a = polyfit(x, y, degree)

  write (*, '(F9.4)') a

end program
