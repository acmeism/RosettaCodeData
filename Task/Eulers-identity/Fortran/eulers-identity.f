program euler
    use iso_fortran_env, only: output_unit, REAL64
    implicit none

    integer, parameter              :: d=REAL64
    real(kind=d), parameter         :: e=exp(1._d), pi=4._d*atan(1._d)
    complex(kind=d), parameter      :: i=(0._d,1._d)

    write(output_unit,*) e**(pi*i) + 1
end program euler
