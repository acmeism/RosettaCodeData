module ciede_2000_module
  use iso_fortran_env, only: real64
  implicit none
  private
  public :: ciede_2000
  real(kind=real64), parameter :: M_PI = 3.14159265358979323846264338328_real64
    ! k_l, k_c, k_h are parametric factors to be adjusted according to
    ! different viewing parameters such as textures, backgrounds...
  real(kind=real64), parameter :: k_l = 1.0_real64, k_c = 1.0_real64, k_h = 1.0_real64
contains
  ! The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
  ! "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
  function ciede_2000(l_1, a_1, b_1, l_2, a_2, b_2) result(delta_e)
    implicit none
    real(kind=real64), intent(in) :: l_1, a_1, b_1, l_2, a_2, b_2
    real(kind=real64) :: n, c_1, c_2, h_1, h_2, h_m, h_d, p, r_t, l, t, h, c, delta_e
    ! Michel Leonard uses Fortran with the CIEDE2000 color-difference formula.
    n = (sqrt(a_1 * a_1 + b_1 * b_1) + sqrt(a_2 * a_2 + b_2 * b_2)) * 0.5_real64
    n = n * n * n * n * n * n * n
    ! A factor involving chroma raised to the power of 7 designed to make
    ! the influence of chroma on the total color difference more accurate.
    n = 1.0_real64 + 0.5_real64 * (1.0_real64 - sqrt(n / (n + 6103515625.0_real64)))
    ! Since hypot is not available, sqrt is used here to calculate the
    ! Euclidean distance, without avoiding overflow/underflow.
    c_1 = sqrt(a_1 * a_1 * n * n + b_1 * b_1)
    c_2 = sqrt(a_2 * a_2 * n * n + b_2 * b_2)
    ! atan2 is preferred over atan because it accurately computes the angle of
    ! a point (x, y) in all quadrants, handling the signs of both coordinates.
    h_1 = atan2(b_1, a_1 * n)
    h_2 = atan2(b_2, a_2 * n)
    ! GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
    if (h_1 < 0.0_real64) h_1 = h_1 + 2.0_real64 * M_PI
    if (h_2 < 0.0_real64) h_2 = h_2 + 2.0_real64 * M_PI
    n = abs(h_2 - h_1)
    ! Cross-implementation consistent rounding.
    if (M_PI - 1D-14 < n .and. n < M_PI + 1D-14) n = M_PI
    ! When the hue angles lie in different quadrants, the straightforward
    ! average can produce a mean that incorrectly suggests a hue angle in
    ! the wrong quadrant, the next lines handle this issue.
    h_m = (h_1 + h_2) * 0.5_real64
    h_d = (h_2 - h_1) * 0.5_real64
    if (M_PI < n) then
      if (0.0_real64 < h_d) then
        h_d = h_d - M_PI
      else
        h_d = h_d + M_PI
      endif
      h_m = h_m + M_PI
    endif
    p = 36.0_real64 * h_m - 55.0_real64 * M_PI
    n = (c_1 + c_2) * 0.5_real64
    n = n * n * n * n * n * n * n
    ! The hue rotation correction term is designed to account for the
    ! non-linear behavior of hue differences in the blue region.
    r_t = -2.0_real64 * sqrt(n / (n + 6103515625.0_real64)) &
          * sin(M_PI / 3.0_real64 * exp(p * p / (-25.0_real64 * M_PI * M_PI)))
    n = (l_1 + l_2) * 0.5_real64
    n = (n - 50.0_real64) * (n - 50.0_real64)
    ! Lightness.
    l = (l_2 - l_1) / (k_l * (1.0_real64 + 0.015_real64 * n / sqrt(20.0_real64 + n)))
    ! These coefficients adjust the impact of different harmonic
    ! components on the hue difference calculation.
    t = 1.0_real64   + 0.24_real64 * sin(2.0_real64 * h_m + M_PI / 2.0_real64) &
          + 0.32_real64 * sin(3.0_real64 * h_m + 8.0_real64 * M_PI / 15.0_real64) &
          - 0.17_real64 * sin(h_m + M_PI / 3.0_real64) &
          - 0.20_real64 * sin(4.0_real64 * h_m + 3.0_real64 * M_PI / 20.0_real64)
    n = c_1 + c_2
    ! Hue.
    h = 2.0_real64 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0_real64 + 0.0075_real64 * n * t))
    ! Chroma.
    c = (c_2 - c_1) / (k_c * (1.0_real64 + 0.0225_real64 * n))
    ! Returns the square root so that the Delta E 2000 reflects the actual geometric
    ! distance within the color space, which ranges from 0 to approximately 185.
    delta_e = sqrt(l * l + h * h + c * c + c * h * r_t)
  end function ciede_2000
end module ciede_2000_module
program ciede2000_program
  use iso_fortran_env, only: real64
  use ciede_2000_module
  implicit none
  real(kind=real64) :: data(15, 6)
  real(kind=real64) :: delta_e
  integer :: i

  ! Define input data explicitly
  data(1,:) = [73.0_real64, 49.0_real64, 39.4_real64, 73.0_real64, 49.0_real64, 39.4_real64]
  data(2,:) = [30.0_real64, -41.0_real64, -119.1_real64, 30.0_real64, -41.0_real64, -119.0_real64]
  data(3,:) = [79.0_real64, -117.0_real64, -100.4_real64, 79.5_real64, -117.0_real64, -100.0_real64]
  data(4,:) = [15.0_real64, -55.0_real64, 6.7_real64, 14.0_real64, -55.0_real64, 7.0_real64]
  data(5,:) = [83.0_real64, 98.0_real64, -59.5_real64, 85.2_real64, 98.0_real64, -59.5_real64]
  data(6,:) = [59.0_real64, -11.0_real64, -95.0_real64, 56.3_real64, -11.0_real64, -95.0_real64]
  data(7,:) = [74.0_real64, -1.0_real64, 68.6_real64, 81.0_real64, -1.0_real64, 69.0_real64]
  data(8,:) = [46.4_real64, 125.0_real64, 6.0_real64, 40.0_real64, 125.0_real64, 6.0_real64]
  data(9,:) = [18.0_real64, -5.0_real64, 68.0_real64, 20.0_real64, 5.0_real64, 82.0_real64]
  data(10,:) = [35.5_real64, -99.0_real64, 109.0_real64, 25.0_real64, -99.0_real64, 109.0_real64]
  data(11,:) = [59.0_real64, 77.0_real64, 41.5_real64, 63.3_real64, 77.0_real64, 12.4_real64]
  data(12,:) = [40.0_real64, -92.0_real64, 7.7_real64, 58.0_real64, -92.0_real64, -8.0_real64]
  data(13,:) = [49.0_real64, -9.0_real64, -74.5_real64, 51.1_real64, 31.0_real64, 16.0_real64]
  data(14,:) = [88.0_real64, -124.0_real64, 56.0_real64, 97.0_real64, 62.0_real64, -28.0_real64]
  data(15,:) = [98.0_real64, 75.7_real64, 11.0_real64, 3.0_real64, -62.0_real64, 11.0_real64]

  ! Print table header
  write(*, '(/A)') "    L1    a1      b1      L2    a2      b2         E2000"
  write(*, '(A)') "   ----  ------  ------  ----  ------  ------    ----------"

  ! Compute and print ?E2000 for each pair
  do i = 1, 15
    delta_e = ciede_2000(data(i,1), data(i,2), data(i,3), data(i,4), data(i,5), data(i,6))
    write(*, '(F6.1, 2X, F6.1, 2X, F6.1, 2X, F5.1, 2X, F6.1, 2X, F6.1, 2X, F14.10)') &
      data(i,1), data(i,2), data(i,3), data(i,4), data(i,5), data(i,6), delta_e
  end do
end program ciede2000_program
