module GSLMiniBind
  implicit none

  interface
     real(c_double) function gsl_sf_gamma_inc(a, x) bind(C)
       use iso_c_binding
       real(c_double), value, intent(in) :: a, x
     end function gsl_sf_gamma_inc
  end interface
end module GSLMiniBind
