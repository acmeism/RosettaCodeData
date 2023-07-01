module optim_mod
    implicit none
contains
    subroutine optim(a)
        implicit none
        integer :: a(:), n, i, j, k
        integer, allocatable :: u(:, :)
        integer(8) :: c
        integer(8), allocatable :: v(:, :)

        n = ubound(a, 1) - 1
        allocate (u(n, n), v(n, n))
        v = huge(v)
        u(:, 1) = -1
        v(:, 1) = 0
        do j = 2, n
            do i = 1, n - j + 1
                do k = 1, j - 1
                    c = v(i, k) + v(i + k, j - k) + int(a(i), 8) * int(a(i + k), 8) * int(a(i + j), 8)
                    if (c < v(i, j)) then
                        u(i, j) = k
                        v(i, j) = c
                    end if
                end do
            end do
        end do
        write (*, "(I0,' ')", advance="no") v(1, n)
        call aux(1, n)
        print *
        deallocate (u, v)
    contains
        recursive subroutine aux(i, j)
            integer :: i, j, k

            k = u(i, j)
            if (k < 0) then
                write (*, "(I0)", advance="no") i
            else
                write (*, "('(')", advance="no")
                call aux(i, k)
                write (*, "('*')", advance="no")
                call aux(i + k, j - k)
                write (*, "(')')", advance="no")
            end if
        end subroutine
    end subroutine
end module

program matmulchain
    use optim_mod
    implicit none

    call optim([5, 6, 3, 1])
    call optim([1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2])
    call optim([1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10])
end program
