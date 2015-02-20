program queens
    use omp_lib
    implicit none
    integer, parameter :: long = selected_int_kind(17)
    integer, parameter :: l = 18
    integer :: n, i, j, a(l*l, 2), k, p, q
    integer(long) :: s, b(l*l)
    real(kind(1d0)) :: t1, t2

    do n = 6, l
        k = 0
        p = n/2
        q = mod(n, 2)*(p + 1)
        do i = 1, n
            do j = 1, n
                if ((abs(i - j) > 1) .and. ((i <= p) .or. ((i == q) .and. (j < i)))) then
                    k = k + 1
                    a(k, 1) = i
                    a(k, 2) = j
                end if
            end do
        end do
        s = 0
        t1 = omp_get_wtime()
        !$omp parallel do schedule(dynamic)
        do i = 1, k
            b(i) = pqueens(n, a(i, 1), a(i, 2))
        end do
        !$omp end parallel do
        t2 = omp_get_wtime()
        print "(I4, I12, F12.3)", n, 2*sum(b(1:k)), t2 - t1
    end do

contains
    function pqueens(n, k1, k2) result(m)
        implicit none
        integer(long) :: m
        integer, intent(in) :: n, k1, k2
        integer, parameter :: l = 20
        integer :: a(l), s(l), u(4*l - 2)
        integer :: i, j, y, z, p, q, r

        do i = 1, n
            a(i) = i
        end do

        do i = 1, 4*n - 2
            u(i) = 0
        end do

        m = 0
        r = 2*n - 1
        if (k1 == k2) return

        p = 1 - k1 + n
        q = 1 + k1 - 1
        if ((u(p) /= 0) .or. (u(q + r) /= 0)) return

        u(p) = 1
        u(q + r) = 1
        z = a(1)
        a(1) = a(k1)
        a(k1) = z
        p = 2 - k2 + n
        q = 2 + k2 - 1
        if ((u(p) /= 0) .or. (u(q + r) /= 0)) return

        u(p) = 1
        u(q + r) = 1
        if (k2 /= 1) then
            z = a(2)
            a(2) = a(k2)
            a(k2) = z
        else
            z = a(2)
            a(2) = a(k1)
            a(k1) = z
        end if
        i = 3
        go to 40

     30 s(i) = j
        u(p) = 1
        u(q + r) = 1
        i = i + 1
     40 if (i > n) go to 80

        j = i

     50 z = a(i)
        y = a(j)
        p = i - y + n
        q = i + y - 1
        a(i) = y
        a(j) = z
        if ((u(p) == 0) .and. (u(q + r) == 0)) go to 30

     60 j = j + 1
        if (j <= n) go to 50

     70 j = j - 1
        if (j == i) go to 90

        z = a(i)
        a(i) = a(j)
        a(j) = z
        go to 70

        !valid queens position found
     80 m = m + 1

     90 i = i - 1
        if (i == 2) return

        p = i - a(i) + n
        q = i + a(i) - 1
        j = s(i)
        u(p) = 0
        u(q + r) = 0
        go to 60
    end function
end program
