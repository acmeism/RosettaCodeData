program attractive_numbers
    use iso_fortran_env, only: output_unit
    implicit none

    integer, parameter  :: maximum=120, line_break=20
    integer             :: i, counter

    write(output_unit,'(A,x,I0,x,A)') "The attractive numbers up to and including", maximum, "are:"

    counter = 0
    do i = 1, maximum
        if (is_prime(count_prime_factors(i))) then
            write(output_unit,'(I0,x)',advance="no") i
            counter = counter + 1
            if (modulo(counter, line_break) == 0) write(output_unit,*)
        end if
    end do
    write(output_unit,*)
contains
    pure function is_prime(n)
        integer, intent(in) :: n
        logical             :: is_prime
        integer             :: d

        is_prime = .false.

        d = 5
        if (n < 2) return
        if (modulo(n, 2) == 0) then
            is_prime = n==2
            return
        end if
        if (modulo(n, 3) == 0) then
            is_prime = n==3
            return
        end if

        do
            if (d**2 > n) then
                is_prime = .true.
                return
            end if
            if (modulo(n, d) == 0) then
                is_prime = .false.
                return
            end if
            d = d + 2
            if (modulo(n, d) == 0) then
                is_prime = .false.
                return
            end if
            d = d + 4
        end do

        is_prime = .true.
    end function is_prime

    pure function count_prime_factors(n)
        integer, intent(in)     :: n
        integer                 :: count_prime_factors
        integer                 :: i, f

        count_prime_factors = 0
        if (n == 1) return
        if (is_prime(n)) then
            count_prime_factors = 1
            return
        end if
        count_prime_factors = 0
        f = 2
        i = n

        do
            if (modulo(i, f) == 0) then
                count_prime_factors = count_prime_factors + 1
                i = i/f
                if (i == 1) exit
                if (is_prime(i)) f = i
            else if (f >= 3) then
                f = f + 2
            else
                f = 3
            end if
        end do
    end function count_prime_factors
end program attractive_numbers
