! Program to solve the coconut problem for 5 and 6 sailors
! Calculates the minimum initial pile of coconuts that satisfies the problem constraints
! Each sailor divides the pile into equal parts, gives one coconut to the monkey, hides one part,
! and combines the rest. In the morning, the final pile divides equally among sailors with no remainder.
program coconut_problem
    implicit none
    ! Variable declarations
    integer :: d              ! Number of sailors (5 or 6)
    integer :: x0             ! Initial guess for final morning pile size
    integer :: current        ! Current pile size during calculations
    integer :: m              ! Size of each divided pile for a sailor
    integer :: i              ! Loop counters
    integer :: min_pile       ! Stores the minimum initial pile size
    integer, dimension(6) :: hidden  ! Array to store number of coconuts each sailor hides (max 6 sailors)
    logical :: valid          ! Flag to indicate if a solution is valid

    ! --- Solve for 5 sailors ---
    ! Initialize number of sailors
    d = 5
    ! Start with the smallest possible final pile size that divides evenly among 5 sailors
    x0 = d
    ! Loop to find the minimum initial pile
    do while (.true.)
        ! Start with the current guess for the final pile
        current = x0
        ! Assume the solution is valid until proven otherwise
        valid = .true.
        ! Simulate the process backwards for each sailor
        do i = 1, d
            ! Check if the current pile size is divisible by (d-1)
            ! This checks if the pile before the sailor took their share and gave one to the monkey
            ! can be formed by combining (d-1) equal piles
            if (mod(current, d-1) /= 0) then
                valid = .false.
                exit
            end if
            ! Calculate the size of each pile the sailor made
            m = current / (d-1)
            ! Reverse the process: compute the pile size before the sailor took their share
            ! If current pile is from (d-1) parts, the original pile was d*m + 1 (including monkey's coconut)
            current = d * m + 1
        end do
        ! If the process completed without issues, we found a valid initial pile
        if (valid) then
            min_pile = current
            exit
        end if
        ! Increment the final pile size by d to keep it divisible by d in the morning
        x0 = x0 + d
    end do

    ! Output the minimum initial pile size for 5 sailors
    write(*,*) "Minimum initial pile for 5 sailors:", min_pile

    ! --- Simulate to find hidden amounts for 5 sailors ---
    ! Start with the minimum initial pile
    current = min_pile
    write(*,*) "Hidden amounts for 5 sailors:"
    ! Simulate each sailor's actions in forward order
    do i = 1, d
        ! Verify the pile divides into d parts with 1 coconut left for the monkey
        if (mod(current, d) /= 1) then
            write(*,*) "Error in simulation"
            stop
        end if
        ! Calculate the size of each pile the sailor makes
        m = (current - 1) / d
        ! Store the number of coconuts hidden by this sailor
        hidden(i) = m
        ! Update the pile size: sailor takes one pile, leaves (d-1) piles
        current = (d - 1) * m
        ! Output the number of coconuts hidden by this sailor
        write(*,*) "Sailor", i, "hides:", hidden(i)
    end do
    ! Output the final pile size in the morning
    write(*,*) "Final pile in morning:", current
    ! Verify the final pile divides evenly among sailors
    if (mod(current, d) /= 0) then
        write(*,*) "Error in final division"
    else
        ! Output the number of coconuts each sailor gets in the morning
        write(*,*) "Each gets in morning:", current / d
    end if

    ! --- Solve for 6 sailors ---
    ! Initialize number of sailors
    d = 6
    ! Start with the smallest possible final pile size that divides evenly among 6 sailors
    x0 = d
    ! Loop to find the minimum initial pile
    do while (.true.)
        ! Start with the current guess for the final pile
        current = x0
        ! Assume the solution is valid until proven otherwise
        valid = .true.
        ! Simulate the process backwards for each sailor
        do i = 1, d
            ! Check if the current pile size is divisible by (d-1)
            if (mod(current, d-1) /= 0) then
                valid = .false.
                exit
            end if
            ! Calculate the size of each pile the sailor made
            m = current / (d-1)
            ! Reverse the process: compute the pile size before the sailor took their share
            current = d * m + 1
        end do
        ! If the process completed without issues, we found a valid initial pile
        if (valid) then
            min_pile = current
            exit
        end if
        ! Increment the final pile size by d to keep it divisible by d in the morning
        x0 = x0 + d
    end do

    ! Output the minimum initial pile size for 6 sailors
    write(*,*) "Minimum initial pile for 6 sailors:", min_pile

    ! --- Simulate to find hidden amounts for 6 sailors ---
    ! Start with the minimum initial pile
    current = min_pile
    write(*,*) "Hidden amounts for 6 sailors:"
    ! Simulate each sailor's actions in forward order
    do i = 1, d
        ! Verify the pile divides into d parts with 1 coconut left for the monkey
        if (mod(current, d) /= 1) then
            write(*,*) "Error in simulation"
            stop
        end if
        ! Calculate the size of each pile the sailor makes
        m = (current - 1) / d
        ! Store the number of coconuts hidden by this sailor
        hidden(i) = m
        ! Update the pile size: sailor takes one pile, leaves (d-1) piles
        current = (d - 1) * m
        ! Output the number of coconuts hidden by this sailor
        write(*,*) "Sailor", i, "hides:", hidden(i)
    end do
    ! Output the final pile size in the morning
    write(*,*) "Final pile in morning:", current
    ! Verify the final pile divides evenly among sailors
    if (mod(current, d) /= 0) then
        write(*,*) "Error in final division"
    else
        ! Output the number of coconuts each sailor gets in the morning
        write(*,*) "Each gets in morning:", current / d
    end if

end program coconut_problem
