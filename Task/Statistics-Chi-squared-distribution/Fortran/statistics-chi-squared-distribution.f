program chi_squared_gsl
  use, intrinsic :: iso_c_binding
  implicit none
  integer :: k, x_int
  real(8) :: x, pdf_val, cdf_val
  integer, parameter :: n_airports = 4, n_categories = 2
  real(8) :: observed(n_airports, n_categories), expected(n_airports, n_categories)
  real(8) :: chi2_stat
  integer :: i, j
!
!  ! GSL interface for incomplete gamma function
  interface
    function gsl_sf_gamma_inc_P(s, z) bind(c, name='gsl_sf_gamma_inc_P')
      import :: c_double
      real(c_double), value :: s, z
      real(c_double) :: gsl_sf_gamma_inc_P
    end function gsl_sf_gamma_inc_P
  end interface

  ! Part 1: Chi-squared PDF for k=1 to 5, x=0 to 10
  write(*, '(A)') 'Values of the Chi-squared probability distribution function'
  write(*, '(A4, 5F10.6)') 'x/k', (real(k, 8), k=1, 5)
  do x_int = 0, 10
    x = real(x_int, 8)
    write(*, '(I2)', advance='no') x_int
    do k = 1, 5
      pdf_val = chi2_pdf(x, k)
      write(*, '(F10.6)', advance='no') pdf_val
    end do
    write(*, *)  ! New line
  end do

  ! Part 2: Chi-squared CDF and p-values for k=3, x=1,2,4,8,16,32
  write(*, '(/, A)') 'Values for the Chi-squared distribution with 3 degrees of freedom'
  write(*, '(A13, A15, A10)') 'Chi-squared', 'cumulative pdf', 'p-value'
  do x_int = 1, 32
    if (x_int == 1 .or. x_int == 2 .or. x_int == 4 .or. x_int == 8 .or. x_int == 16 .or. x_int == 32) then
      x = real(x_int, 8)
      cdf_val = chi2_cdf(x, 3)
      write(*, '(F13.6, F15.6, F10.6)') x, cdf_val, 1.0d0 - cdf_val
    end if
  end do

  ! Part 3: Airport data chi-squared analysis
  ! Initialize observed frequencies
  data observed / 77.0d0, 88.0d0, 79.0d0, 81.0d0, &  ! On Time
                  23.0d0, 12.0d0, 21.0d0, 19.0d0 /  ! Delayed

  ! Initialize expected frequencies
  data expected / 81.25d0, 81.25d0, 81.25d0, 81.25d0, &  ! On Time
                  18.75d0, 18.75d0, 18.75d0, 18.75d0 /  ! Delayed

  ! Calculate chi-squared statistic
  chi2_stat = 0.0d0
  do i = 1, n_airports
    do j = 1, n_categories
      chi2_stat = chi2_stat + (observed(i,j) - expected(i,j))**2 / expected(i,j)
    end do
  end do

  ! Output airport results
  write(*, '(/, A)') 'For the airport data:'
  write(*, '(A20, F10.6)') 'test statistic     :', chi2_stat
  write(*, '(A20, I10)') 'degrees of freedom :', 3
  write(*, '(A20, F10.6)') 'Chi-squared        :', chi2_pdf(chi2_stat, 3)
  write(*, '(A20, F10.6)') 'p-value            :', chi2_cdf(chi2_stat, 3)

contains

  ! Chi-squared PDF: f(x; k) = x^((k/2)-1) * exp(-x/2) / (2^(k/2) * Gamma(k/2))
  function chi2_pdf(x, k) result(pdf)
    real(8), intent(in) :: x
    integer, intent(in) :: k
    real(8) :: pdf, k_half
    k_half = real(k, 8) / 2.0d0
    if (x <= 0.0d0) then
      pdf = 0.0d0
    else
      pdf = (x ** (k_half - 1.0d0)) * exp(-x / 2.0d0) / &
            ((2.0d0 ** k_half) * gamma(k_half))
    end if
  end function chi2_pdf

  ! Chi-squared CDF: F(x; k) = gamma(k/2, x/2) / Gamma(k/2)
  function chi2_cdf(x, k) result(cdf)
    real(8), intent(in) :: x
    integer, intent(in) :: k
    real(8) :: cdf, k_half, z
    k_half = real(k, 8) / 2.0d0
    z = x / 2.0d0
    if (x <= 0.0d0) then
      cdf = 0.0d0
    else
      cdf = gsl_sf_gamma_inc_P(k_half, z)
    end if
  end function chi2_cdf

end program chi_squared_gsl
