program qrtask
    implicit none
    integer, parameter :: n = 4
    real(8) :: durer(n, n) = reshape(dble([ &
        16,  5,  9,  4, &
         3, 10,  6, 15, &
         2, 11,  7, 14, &
        13,  8, 12,  1  &
    ]), [n, n])
    real(8) :: q(n, n), r(n, n), qr(n, n), id(n, n), tau(n)
    integer, parameter :: lwork = 1024
    real(8) :: work(lwork)
    integer :: info, i, j

    q = durer
    call dgeqrf(n, n, q, n, tau, work, lwork, info)

    r = 0d0
    forall (i = 1:n, j = 1:n, j >= i) r(i, j) = q(i, j)

    call dorgqr(n, n, n, q, n, tau, work, lwork, info)

    qr = matmul(q, r)
    id = matmul(q, transpose(q))

    call show(4, durer, "A")
    call show(4, q, "Q")
    call show(4, r, "R")
    call show(4, qr, "Q*R")
    call show(4, id, "Q*Q'")
contains
    subroutine show(n, a, s)
        character(*) :: s
        integer :: n, i
        real(8) :: a(n, n)

        print *, s
        do i = 1, n
            print 1, a(i, :)
          1 format (*(f12.6,:,' '))
        end do
    end subroutine
end program
