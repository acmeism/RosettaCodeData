program mersenne
    use iso_fortran_env, only: output_unit, INT64
    implicit none

    integer, parameter  :: l=INT64
    integer(kind=l)     :: base
    integer             :: pow

    base = 2

    do pow = 1, 32
        if (is_prime(base-1)) then
            write(output_unit,'(A2,x,I0,x,A3)') "2^", pow, "- 1"
        end if
        base = base * 2
    end do
contains
    pure function is_prime(n)
        integer(kind=l), intent(in) :: n
        logical                     :: is_prime
        integer(kind=l)             :: test

        is_prime = .false.
        if (n < 2) return
        if (modulo(n, 2) == 0) then
            is_prime = n==2
            return
        end if
        if (modulo(n, 3) == 0) then
            is_prime = n==3
            return
        end if

        test = 5
        do
            if (test**2 >= n) then
                is_prime = .true.
                return
            end if

            if (modulo(n, test) == 0) return
            test = test + 2
            if (modulo(n, test) == 0) return
            test = test + 4
        end do
    end function is_prime
end program mersenne
