program anti_primes
    use iso_fortran_env, only: output_unit
    implicit none

    integer :: n, d, maxDiv, pCount

    write(output_unit,*) "The first 20 anti-primes are:"
    n = 1
    maxDiv = 0
    pCount = 0
    do
        if (pCount >= 20) exit

        d = countDivisors(n)
        if (d > maxDiv) then
            write(output_unit,'(I0,x)', advance="no") n
            maxDiv = d
            pCount = pCount + 1
        end if
        n = n + 1
    end do
    write(output_unit,*)
contains
    pure function countDivisors(n)
        integer, intent(in) :: n
        integer             :: countDivisors
        integer             :: i

        countDivisors = 1
        if (n < 2) return
        countDivisors = 2
        do i = 2, n/2
            if (modulo(n, i) == 0) countDivisors = countDivisors + 1
        end do
    end function countDivisors
end program anti_primes
