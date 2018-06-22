subroutine sort(n, a)
    implicit none
    integer :: n, i, j
    real :: a(n), x

    do i = 2, n
        x = a(i)
        j = i - 1
        do while (j >= 1)
            if (a(j) <= x) exit
            a(j + 1) = a(j)
            j = j - 1
        end do
        a(j + 1) = x
    end do
end subroutine
