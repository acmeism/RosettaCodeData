module pascal

implicit none

contains
    function pascal_lower(n) result(a)
        integer :: n, i, j
        integer, allocatable :: a(:, :)
        allocate(a(n, n))
        a = 0
        do i = 1, n
            a(i, 1) = 1
        end do
        do i = 2, n
            do j = 2, i
                a(i, j) = a(i - 1, j) + a(i - 1, j - 1)
            end do
        end do
    end function

    function pascal_upper(n) result(a)
        integer :: n, i, j
        integer, allocatable :: a(:, :)
        allocate(a(n, n))
        a = 0
        do i = 1, n
            a(1, i) = 1
        end do
        do i = 2, n
            do j = 2, i
                a(j, i) = a(j, i - 1) + a(j - 1, i - 1)
            end do
        end do
    end function

    function pascal_symmetric(n) result(a)
        integer :: n, i, j
        integer, allocatable :: a(:, :)
        allocate(a(n, n))
        a = 0
        do i = 1, n
            a(i, 1) = 1
            a(1, i) = 1
        end do
        do i = 2, n
            do j = 2, n
                a(i, j) = a(i - 1, j) + a(i, j - 1)
            end do
        end do
    end function

    subroutine print_matrix(a)
        integer :: a(:, :)
        integer :: n, i
        n = ubound(a, 1)
        do i = 1, n
            print *, a(i, :)
        end do
    end subroutine
end module

program ex_pascal
    use pascal
    implicit none
    integer :: n
    integer, allocatable :: a(:, :)
    print *, "Size?"
    read *, n
    print *, "Lower Pascal Matrix"
    a = pascal_lower(n)
    call print_matrix(a)
    print *, "Upper Pascal Matrix"
    a = pascal_upper(n)
    call print_matrix(a)
    print *, "Symmetric Pascal Matrix"
    a = pascal_symmetric(n)
    call print_matrix(a)
end program
