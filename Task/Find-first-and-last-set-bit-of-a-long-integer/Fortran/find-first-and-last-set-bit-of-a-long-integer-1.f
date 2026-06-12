program bits
    implicit none
    integer :: n = 1, i

    do i = 1, 6
        print "(B32,2(' ',I2))", n, trailz(n), 31 - leadz(n)
        n = 42 * n
    end do
end program
