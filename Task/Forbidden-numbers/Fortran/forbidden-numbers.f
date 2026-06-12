: program forbidden_numbers
    ! The task involves identifying "forbidden numbers," which are positive integers that require exactly four squares
    ! to sum to them, based on Lagrange's four-square theorem. These numbers correspond to those of the form 4^k*(8m + 7),
    ! as per Legendre's three-square theorem. Here's how to solve the problem efficiently:
    !
    ! Approach:
    ! 1. Identify Forbidden Numbers: A number is forbidden if, after removing all factors of 4, the remaining value
    !    is congruent to 7 modulo 8. This avoids dynamic programming and leverages mathematical properties.
    ! 2. Iterative Check: For each number up to 500,000,000, check if it fits the form 4^k*(8m + 7). If so, classify as forbidden.
    implicit none
    integer, parameter :: max_limit = 500000000  ! Extended to 500 million
    integer :: n, q
    integer :: count_500 = 0, count_5000 = 0, count_50000 = 0, count_500000 = 0
    integer :: count_5M = 0, count_50M = 0, count_500M = 0  ! New counters
    integer :: forbidden_count = 0
    integer, dimension(50) :: forbidden_list
    logical :: is_forbidden
    real :: start, finish

    call cpu_time(start)

    do n = 1, max_limit
        q = n
        do while (mod(q, 4) == 0)
!            q = q / 4
            q = SHIFTR(q, 2)  ! Equivalent to q / 4
        end do
        is_forbidden = (mod(q, 8) == 7)

        if (is_forbidden) then
            if (forbidden_count < 50) then
                forbidden_count = forbidden_count + 1
                forbidden_list(forbidden_count) = n
            end if
            ! Update all relevant counters
            if (n <= 500) count_500 = count_500 + 1
            if (n <= 5000) count_5000 = count_5000 + 1
            if (n <= 50000) count_50000 = count_50000 + 1
            if (n <= 500000) count_500000 = count_500000 + 1
            if (n <= 5000000) count_5M = count_5M + 1
            if (n <= 50000000) count_50M = count_50M + 1
            if (n <= 500000000) count_500M = count_500M + 1
        endif
    end do

    print *, "First 50 forbidden numbers:"
    print "(10I7)", forbidden_list
    print *
    print '(A, I0)', "Count up to         500: ", count_500
    print '(A, I0)', "Count up to       5,000: ", count_5000
    print '(A, I0)', "Count up to      50,000: ", count_50000
    print '(A, I0)', "Count up to     500,000: ", count_500000
    print '(A, I0)', "Count up to   5,000,000: ", count_5M
    print '(A, I0)', "Count up to  50,000,000: ", count_50M
    print '(A, I0)', "Count up to 500,000,000: ", count_500M

    call cpu_time(finish)
    print '(/,a,1x,f6.4,1x,a)', "Total computation time:", finish - start, "seconds"
end program forbidden_numbers

