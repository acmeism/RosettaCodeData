! Welch's two-sample t-test with two-tailed p-value
!
! Replicates R's: t.test(x, y, alternative="two.sided", var.equal=FALSE)
!
! Method:
!   1. Compute sample means and unbiased sample variances for each group.
!   2. Form the Welch t-statistic, which does not assume equal variances.
!   3. Approximate the degrees of freedom via the Welch-Satterthwaite equation.
!   4. Evaluate the two-tailed p-value as the regularized incomplete beta
!      function I_x(nu/2, 1/2) where x = nu / (t^2 + nu).
!   5. The incomplete beta integral is evaluated numerically with Simpson's
!      composite rule; log_gamma is used throughout to avoid overflow.

program welch_ttest
    use iso_fortran_env, only: real64
    implicit none

    ! --- Input data ---
    ! x and y are the two independent samples to be compared.
    real(kind=real64) :: x(4) = [3.0_real64, 4.0_real64, 1.0_real64, 2.1_real64]
    real(kind=real64) :: y(3) = [490.2_real64, 340.0_real64, 433.9_real64]

    ! --- Sample sizes ---
    integer :: n1, n2

    ! --- Descriptive statistics ---
    ! mean1, mean2 : arithmetic means of x and y
    ! var1,  var2  : unbiased sample variances (divided by n-1)
    real(kind=real64) :: mean1, mean2, var1, var2

    ! s1sq_n1 = var1/n1  and  s2sq_n2 = var2/n2
    ! These are the per-group squared-standard-error terms that appear in both
    ! the Welch t-statistic denominator and the Satterthwaite df formula.
    real(kind=real64) :: s1sq_n1, s2sq_n2

    ! t_stat  : Welch t-statistic
    ! df      : Welch-Satterthwaite effective degrees of freedom
    ! x_upper : upper integration limit for the incomplete beta = nu/(t^2+nu)
    ! p_value : two-tailed p-value
    real(kind=real64) :: t_stat, df, x_upper, p_value

    ! ---------------------------------------------------------------
    ! Step 1 -- sample sizes
    ! ---------------------------------------------------------------
    n1 = size(x)
    n2 = size(y)

    ! ---------------------------------------------------------------
    ! Step 2 -- arithmetic means
    !   X_bar = (1/N) * sum(X_i)
    ! ---------------------------------------------------------------
    mean1 = sum(x) / real(n1, real64)
    mean2 = sum(y) / real(n2, real64)

    ! ---------------------------------------------------------------
    ! Step 3 -- unbiased sample variances
    !   s^2 = (1/(N-1)) * sum( (X_i - X_bar)^2 )
    ! Dividing by N-1 (Bessel's correction) gives an unbiased estimator
    ! of the population variance.
    ! ---------------------------------------------------------------
    var1 = sum((x - mean1)**2) / real(n1 - 1, real64)
    var2 = sum((y - mean2)**2) / real(n2 - 1, real64)

    ! ---------------------------------------------------------------
    ! Step 4 -- squared standard errors for each group
    !   s_n^2 / N_n
    ! These appear repeatedly in both the t-statistic and df formula,
    ! so they are computed once and reused.
    ! ---------------------------------------------------------------
    s1sq_n1 = var1 / real(n1, real64)
    s2sq_n2 = var2 / real(n2, real64)

    ! ---------------------------------------------------------------
    ! Step 5 -- Welch t-statistic
    !
    !         X_bar1 - X_bar2
    !   t = ---------------------
    !        sqrt(s1^2/N1 + s2^2/N2)
    !
    ! Unlike Student's t-test, Welch's version does NOT pool the
    ! variances, making it valid when the two groups have different
    ! population variances.
    ! ---------------------------------------------------------------
    t_stat = (mean1 - mean2) / sqrt(s1sq_n1 + s2sq_n2)

    ! ---------------------------------------------------------------
    ! Step 6 -- Welch-Satterthwaite effective degrees of freedom
    !
    !         ( s1^2/N1 + s2^2/N2 )^2
    !   nu = --------------------------
    !         (s1^2/N1)^2     (s2^2/N2)^2
    !         ----------- + -----------
    !           N1 - 1          N2 - 1
    !
    ! This approximates the distribution of the Welch statistic with
    ! a t-distribution having fractional degrees of freedom.
    ! ---------------------------------------------------------------
    df = (s1sq_n1 + s2sq_n2)**2 / &
         (s1sq_n1**2 / real(n1 - 1, real64) + s2sq_n2**2 / real(n2 - 1, real64))

    ! ---------------------------------------------------------------
    ! Step 7 -- upper integration limit for the incomplete beta
    !
    !         nu
    !   x = -------
    !        t^2 + nu
    !
    ! The two-tailed p-value equals I_x(nu/2, 1/2), the regularized
    ! incomplete beta function evaluated at this x with parameters
    ! a = nu/2 and b = 1/2.  When |t| is large x is close to 0,
    ! yielding a small p-value as expected.
    ! ---------------------------------------------------------------
    x_upper = df / (t_stat**2 + df)

    ! ---------------------------------------------------------------
    ! Step 8 -- p-value via the regularized incomplete beta
    !
    !   p = I_x(nu/2, 1/2)
    !     = B(x; nu/2, 1/2) / B(nu/2, 1/2)
    !
    ! where B(x; a, b) is the incomplete beta integral from 0 to x,
    ! and B(a, b) = Gamma(a)*Gamma(b)/Gamma(a+b) is the beta function.
    ! ---------------------------------------------------------------
    p_value = reg_incomplete_beta(x_upper, df / 2.0_real64, 0.5_real64)

    ! --- Output ---
    write(*,'(A,F14.6)')  'Mean of x:          ', mean1
    write(*,'(A,F14.6)')  'Mean of y:          ', mean2
    write(*,'(A,F14.6)')  'Variance of x:      ', var1
    write(*,'(A,F14.6)')  'Variance of y:      ', var2
    write(*,'(A,F14.6)')  't-statistic:        ', t_stat
    write(*,'(A,F14.6)')  'Degrees of freedom: ', df
    write(*,'(A,F14.10)') 'p-value:            ', p_value

    ! Conventional significance thresholds.
    ! A p-value below alpha does NOT prove an effect; it only signals
    ! that the result warrants further investigation.
    if (p_value < 0.01_real64) then
        write(*,'(A)') 'Significant at alpha=0.01: yes'
    else
        write(*,'(A)') 'Significant at alpha=0.01: no'
    end if

    if (p_value < 0.05_real64) then
        write(*,'(A)') 'Significant at alpha=0.05: yes'
    else
        write(*,'(A)') 'Significant at alpha=0.05: no'
    end if

contains

    ! -----------------------------------------------------------------
    ! reg_incomplete_beta -- regularized incomplete beta I_x(a, b)
    !
    ! Computes:
    !
    !          B(x; a, b)     integral_0^x  r^(a-1) * (1-r)^(b-1) dr
    !   I_x = ----------- = -----------------------------------------
    !           B(a, b)       exp( lgamma(a) + lgamma(b) - lgamma(a+b) )
    !
    ! The numerator integral is evaluated with Simpson's composite rule
    ! using n subintervals (n must be even).
    !
    ! log_gamma (lgamma) is used instead of raw Gamma to avoid overflow;
    ! Gamma grows super-exponentially and overflows double precision for
    ! arguments above roughly 170.
    !
    ! Arguments:
    !   x_up : upper integration limit, in (0, 1)
    !   a    : first beta parameter  (= nu/2 for Welch's test)
    !   b    : second beta parameter (= 0.5  for Welch's test)
    ! -----------------------------------------------------------------
    function reg_incomplete_beta(x_up, a, b) result(ibeta)
        real(kind=real64), intent(in) :: x_up, a, b
        real(kind=real64) :: ibeta

        ! log of the complete beta function B(a, b) = Gamma(a)*Gamma(b)/Gamma(a+b)
        real(kind=real64) :: log_beta_ab

        ! h      : width of each Simpson subinterval
        ! r      : current quadrature point
        ! integral : running weighted sum before the final h/3 scaling
        real(kind=real64) :: h, integral, r

        ! Number of subintervals for Simpson's rule; must be even.
        ! 100 000 gives more than adequate accuracy for the smoothly
        ! varying integrand encountered in this test.
        integer, parameter :: n = 300000
        integer :: i

        ! Compute ln B(a,b) in log space to prevent overflow.
        ! Fortran 2008 provides log_gamma as an intrinsic.
        log_beta_ab = log_gamma(a) + log_gamma(b) - log_gamma(a + b)

        ! --- Simpson's composite rule ---
        ! Integral = (h/3) * [ f(x_0) + 4*f(x_1) + 2*f(x_2) + 4*f(x_3) + ... + f(x_n) ]
        ! Endpoints get weight 1, odd-indexed interior points weight 4,
        ! even-indexed interior points weight 2.
        h = x_up / real(n, real64)
        integral = beta_integrand(0.0_real64, a, b) + beta_integrand(x_up, a, b)

        do i = 1, n - 1
            r = real(i, real64) * h
            if (mod(i, 2) == 0) then
                integral = integral + 2.0_real64 * beta_integrand(r, a, b)
            else
                integral = integral + 4.0_real64 * beta_integrand(r, a, b)
            end if
        end do

        integral = integral * h / 3.0_real64

        ! Divide the incomplete beta integral by the complete beta function
        ! to obtain the regularized value in [0, 1].
        ibeta = integral / exp(log_beta_ab)
    end function reg_incomplete_beta

    ! -----------------------------------------------------------------
    ! beta_integrand -- evaluates r^(a-1) * (1-r)^(b-1)
    !
    ! For Welch's test, a = nu/2 and b = 0.5, so the integrand is:
    !   r^(nu/2 - 1) / sqrt(1 - r)
    !
    ! The function is defined to return 0.0 at the endpoints r=0 and
    ! r=1 to avoid 0^negative or division-by-zero.  In practice the
    ! upper limit x_upper is always strictly less than 1, so r=1 is
    ! never a live quadrature point; the guard is purely defensive.
    ! For r=0 with a >= 1 the true limit of r^(a-1) is also 0, so
    ! the override is mathematically consistent.
    ! -----------------------------------------------------------------
    function beta_integrand(r, a, b) result(f)
        real(kind=real64), intent(in) :: r, a, b
        real(kind=real64) :: f

        if (r <= 0.0_real64 .or. r >= 1.0_real64) then
            f = 0.0_real64
        else
            f = r**(a - 1.0_real64) * (1.0_real64 - r)**(b - 1.0_real64)
        end if
    end function beta_integrand

end program welch_ttest

