program almost_prime
    use iso_fortran_env, only: output_unit
    implicit none

    integer :: i, c, k

    do k = 1, 5
        write(output_unit,'(A3,x,I0,x,A1,x)', advance="no") "k =", k, ":"
        i = 2
        c = 0
        do
            if (c >= 10) exit

            if (kprime(i, k)) then
                write(output_unit,'(I0,x)', advance="no") i
                c = c + 1
            end if
            i = i + 1
        end do
        write(output_unit,*)
    end do
contains
    pure function kprime(n, k)
        integer, intent(in) :: n, k
        logical             :: kprime
        integer             :: p, f, i

        kprime = .false.

        f = 0
        i = n

        do p = 2, n
            do
                if (modulo(i, p) /= 0) exit

                if (f == k) return
                f = f + 1
                i = i / p
            end do
        end do

        kprime = f==k
    end function kprime
end program almost_prime
