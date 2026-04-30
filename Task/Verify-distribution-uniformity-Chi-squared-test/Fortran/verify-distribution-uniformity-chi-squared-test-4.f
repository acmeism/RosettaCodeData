module chi_squared_m
  use iso_fortran_env, only: real64
  implicit none
  private
  public :: is_uniform, is_uniform_one_tail

contains

  ! Log gamma via Lanczos approximation (Numerical Recipes)
  pure function log_gamma_fn(x) result(lg)
    real(kind=real64), intent(in) :: x
    real(kind=real64) :: lg, xx, tmp, ser
    real(kind=real64), parameter :: cof(6) = [ &
      76.18009172947146_real64,    &
      -86.50532032941677_real64,   &
      24.01409824083091_real64,    &
      -1.231739572450155_real64,   &
       0.1208650973866179e-2_real64, &
      -0.5395239384953e-5_real64]
    integer :: j
    xx = x
    tmp = xx + 5.5_real64
    tmp = (xx + 0.5_real64) * log(tmp) - tmp
    ser = 1.000000000190015_real64
    do j = 1, 6
      xx = xx + 1.0_real64
      ser = ser + cof(j) / xx
    end do
    lg = tmp + log(2.5066282746310005_real64 * ser / x)
  end function log_gamma_fn

  ! Regularized incomplete gamma P(a,x) via series expansion
  function gamma_series(a, x) result(gamser)
    real(kind=real64), intent(in) :: a, x
    real(kind=real64) :: gamser, ap, del, summ
    integer :: n
    integer,          parameter :: ITMAX = 300
    real(kind=real64), parameter :: EPS   = 3.0e-15_real64

    ap   = a
    del  = 1.0_real64 / a
    summ = del
    do n = 1, ITMAX
      ap   = ap + 1.0_real64
      del  = del * x / ap
      summ = summ + del
      if (abs(del) < abs(summ) * EPS) exit
    end do
    gamser = summ * exp(-x + a * log(x) - log_gamma_fn(a))
  end function gamma_series

  ! Regularized incomplete gamma Q(a,x) via Lentz continued fraction
  function gamma_cf(a, x) result(gammcf)
    real(kind=real64), intent(in) :: a, x
    real(kind=real64) :: gammcf, an, b, c, d, del, h
    integer :: i
    integer,          parameter :: ITMAX = 300
    real(kind=real64), parameter :: EPS   = 3.0e-15_real64
    real(kind=real64), parameter :: FPMIN = 1.0e-300_real64

    b = x + 1.0_real64 - a
    c = 1.0_real64 / FPMIN
    d = 1.0_real64 / b
    h = d
    do i = 1, ITMAX
      an = -real(i, real64) * (real(i, real64) - a)
      b  = b + 2.0_real64
      d  = an * d + b
      if (abs(d) < FPMIN) d = FPMIN
      c  = b + an / c
      if (abs(c) < FPMIN) c = FPMIN
      d   = 1.0_real64 / d
      del = d * c
      h   = h * del
      if (abs(del - 1.0_real64) < EPS) exit
    end do
    gammcf = exp(-x + a * log(x) - log_gamma_fn(a)) * h
  end function gamma_cf

  ! Regularized incomplete gamma P(a,x)
  function gamma_inc_p(a, x) result(p)
    real(kind=real64), intent(in) :: a, x
    real(kind=real64) :: p
    if (x <= 0.0_real64 .or. a <= 0.0_real64) then
      p = 0.0_real64
    else if (x < a + 1.0_real64) then
      p = gamma_series(a, x)
    else
      p = 1.0_real64 - gamma_cf(a, x)
    end if
  end function gamma_inc_p

  ! Chi-squared CDF: P(chi2_rv <= x) for df degrees of freedom
  function chi2_cdf(x, df) result(p)
    real(kind=real64), intent(in) :: x
    integer,           intent(in) :: df
    real(kind=real64) :: p
    if (x <= 0.0_real64) then
      p = 0.0_real64
    else
      p = gamma_inc_p(0.5_real64 * real(df, real64), 0.5_real64 * x)
    end if
  end function chi2_cdf

  ! Compute chi-squared statistic for uniformity (shared helper)
  function chi2_stat(counts) result(chi2)
    integer, intent(in) :: counts(:)
    real(kind=real64) :: chi2, expected
    integer :: k, n, i
    k        = size(counts)
    n        = sum(counts)
    expected = real(n, real64) / real(k, real64)
    chi2     = 0.0_real64
    do i = 1, k
      chi2 = chi2 + (real(counts(i), real64) - expected)**2 / expected
    end do
  end function chi2_stat

  ! Two-tailed test at 5%: reject if CDF < 0.025 or CDF > 0.975.
  function is_uniform(counts) result(uniform)
    integer, intent(in) :: counts(:)
    logical :: uniform
    real(kind=real64) :: cdf_val
    if (size(counts) < 2) then
      uniform = .true.
      return
    end if
    cdf_val = chi2_cdf(chi2_stat(counts), size(counts) - 1)
    uniform = (cdf_val >= 0.025_real64) .and. (cdf_val <= 0.975_real64)
  end function is_uniform

  ! One-tailed test at 5%: reject only if CDF > 0.95 (chi2 too large).
  function is_uniform_one_tail(counts) result(uniform)
    integer, intent(in) :: counts(:)
    logical :: uniform
    real(kind=real64) :: cdf_val
    if (size(counts) < 2) then
      uniform = .true.
      return
    end if
    cdf_val = chi2_cdf(chi2_stat(counts), size(counts) - 1)
    uniform = (cdf_val <= 0.95_real64)
  end function is_uniform_one_tail

end module chi_squared_m

program chi_squared_test
  use iso_fortran_env, only: real64
  use chi_squared_m
  implicit none

  ! Test cases
  integer :: counts1(6) = [5, 8,  9,  8, 10, 20]   ! skewed -- not uniform
  integer :: counts2(6) = [10, 9, 11,  8,  9, 13]   ! nearly flat -- uniform
  integer :: counts3(5) = [4, 3,  5,  4,  4]         ! flat -- uniform
  integer :: counts4(4) = [1, 20, 1,  1]              ! very skewed -- not uniform
  integer :: counts5(1) = [42]                         ! trivial single bin
  integer :: counts6(5) = [199809, 200665, 199607, 200270, 199649]  ! near-uniform large counts
  integer :: counts7(5) = [522573, 244456, 139979,  71531,  21461]  ! strongly skewed large counts

  write(*, '(a)') 'Chi-squared uniformity test (5% significance)'
  write(*, '(a)') repeat('-', 72)
  write(*, '(a36, 2(2x, a13))') 'Counts', 'One-tailed', 'Two-tailed'
  write(*, '(a)') repeat('-', 72)

  call report('[  5,  8,  9,  8, 10, 20]', counts1)
  call report('[ 10,  9, 11,  8,  9, 13]', counts2)
  call report('[  4,  3,  5,  4,  4]',     counts3)
  call report('[  1, 20,  1,  1]',          counts4)
  call report('[ 42]',                      counts5)
  call report('[199809,200665,199607,200270,199649]', counts6)
  call report('[522573,244456,139979, 71531, 21461]', counts7)

contains

  subroutine report(label, counts)
    character(len=*), intent(in) :: label
    integer,          intent(in) :: counts(:)
    character(len=13) :: col1, col2
    col1 = merge('UNIFORM      ', 'NOT UNIFORM  ', is_uniform_one_tail(counts))
    col2 = merge('UNIFORM      ', 'NOT UNIFORM  ', is_uniform(counts))
    write(*, '(a36, 2(2x, a13))') label, col1, col2
  end subroutine report

end program chi_squared_test
