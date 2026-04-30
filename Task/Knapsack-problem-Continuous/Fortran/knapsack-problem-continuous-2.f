! Fractional knapsack: butcher's shop problem.
! Items may be cut; greedy optimum is achieved by sorting on value/weight
! ratio descending, then filling the knapsack in that order.
program butcher
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: NITEMS = 9
    real(real64), parameter :: CAPACITY = 15.0_real64

    character(len=10), parameter :: name(NITEMS) = [ &
        "beef      ", "pork      ", "ham       ", "greaves   ", &
        "flitch    ", "brawn     ", "welt      ", "salami    ", &
        "sausage   " ]

    real(real64), parameter :: weight(NITEMS) = &
        [ 3.8_real64, 5.4_real64, 3.6_real64, 2.4_real64, 4.0_real64, &
          2.5_real64, 3.7_real64, 3.0_real64, 5.9_real64 ]

    real(real64), parameter :: price(NITEMS) = &
        [ 36.0_real64, 43.0_real64, 90.0_real64, 45.0_real64, 30.0_real64, &
          56.0_real64, 67.0_real64, 95.0_real64, 98.0_real64 ]

    real(real64) :: ratio(NITEMS), fraction(NITEMS)
    real(real64) :: remaining, total_value, taken
    integer      :: order(NITEMS), i, j, tmp

    ! Compute value-per-kg ratios
    do i = 1, NITEMS
        ratio(i) = price(i) / weight(i)
    end do

    ! Sort indices by ratio descending (insertion sort)
    order = [(i, i = 1, NITEMS)]
    do i = 2, NITEMS
        j = i
        do while (j > 1 .and. ratio(order(j)) > ratio(order(j-1)))
            tmp = order(j); order(j) = order(j-1); order(j-1) = tmp
            j = j - 1
        end do
    end do

    ! Greedy fill
    fraction    = 0.0_real64
    remaining   = CAPACITY
    total_value = 0.0_real64

    do i = 1, NITEMS
        if (remaining <= 0.0_real64) exit
        j = order(i)
        taken = min(weight(j), remaining)
        fraction(j) = taken / weight(j)
        total_value = total_value + fraction(j) * price(j)
        remaining   = remaining - taken
    end do

    ! Report
    write(*, '(a)') "Fractional knapsack -- butcher's shop (capacity 15 kg)"
    write(*, '(a)') repeat('-', 57)
    write(*, '(a10, 2x, a10, 2x, a10, 2x, a10, 2x, a10)') &
        "Item", "Weight kg", "Price", "Taken kg", "Value"
    write(*, '(a)') repeat('-', 57)

    do i = 1, NITEMS
        j = order(i)
        if (fraction(j) > 0.0_real64) then
            write(*, '(a10, 2x, f9.1, 2x, f9.2, 2x, f9.4, 2x, f9.2)') &
                trim(name(j)), weight(j), price(j), &
                fraction(j) * weight(j), fraction(j) * price(j)
        end if
    end do

    write(*, '(a)') repeat('-', 57)
    write(*, '(a10, 2x, f9.4, 2x, 10x, 2x, 10x, 2x, f9.2)') &
        "Total", CAPACITY - remaining, total_value

end program butcher
