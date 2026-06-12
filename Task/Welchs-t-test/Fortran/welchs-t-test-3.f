module t_test_m

    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: wp => real64
    implicit none
    private

    public :: t_test, wp

    interface
        function gsl_cdf_tdist_p(x, nu) bind(c, name='gsl_cdf_tdist_P')
            import
            real(c_double), value :: x
            real(c_double), value :: nu
            real(c_double) :: gsl_cdf_tdist_p
        end function gsl_cdf_tdist_p
    end interface

contains

    !> Welch T test
    impure subroutine t_test(x, y, p, t, df)
        real(wp), intent(in) :: x(:), y(:)
        real(wp), intent(out) :: p       !! p-value
        real(wp), intent(out) :: t       !! T value
        real(wp), intent(out) :: df      !! degrees of freedom
        integer :: n1, n2
        real(wp) :: m1, m2, v1, v2

        n1 = size(x)
        n2 = size(y)
        m1 = sum(x)/n1
        m2 = sum(y)/n2
        v1 = sum((x - m1)**2)/(n1 - 1)
        v2 = sum((y - m2)**2)/(n2 - 1)

        t = (m1 - m2)/sqrt(v1/n1 + v2/n2)
        df = (v1/n1 + v2/n2)**2/(v1**2/(n1**2*(n1 - 1)) + v2**2/(n2**2*(n2 - 1)))
        p = 2*gsl_cdf_tdist_p(-abs(t), df)

    end subroutine t_test

end module t_test_m

program main
    use t_test_m, only: t_test, wp
    implicit none
    real(wp) :: x(4) = [3.0_wp, 4.0_wp, 1.0_wp, 2.1_wp]
    real(wp) :: y(3) = [490.2_wp, 340.0_wp, 433.9_wp]
    real(wp) :: t, df, p

    call t_test(x, y, p, t, df)
    print *, t, df, p

end program main
