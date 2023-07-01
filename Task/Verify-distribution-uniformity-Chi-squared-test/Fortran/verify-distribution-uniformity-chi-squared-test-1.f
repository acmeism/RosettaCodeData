module gsl_mini_bind_m

    use iso_c_binding
    implicit none
    private

    public :: p_value

    interface
        function gsl_cdf_chisq_q(x, nu) bind(c, name='gsl_cdf_chisq_Q')
            import
            real(c_double), value :: x
            real(c_double), value :: nu
            real(c_double) :: gsl_cdf_chisq_q
        end function gsl_cdf_chisq_q
    end interface

contains

    !> Get p-value from chi-square distribution
    real function p_value(x, df)
        real, intent(in) :: x
        integer, intent(in) :: df

        p_value = real(gsl_cdf_chisq_q(real(x, c_double), real(df, c_double)))

    end function p_value

end module gsl_mini_bind_m
