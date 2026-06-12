module cycler
    implicit none
    contains
   integer function ccyclesort(list, l_len) result(writes)
        implicit none
        integer, intent(in) :: l_len       ! Length of the array
        integer, intent(inout) :: list(l_len)  ! Array to be sorted
        integer :: cycleStart, pos
        integer :: item, swap_tmp
!$omp declare simd(ccyclesort)
        ! Initialize the number of writes
        writes = 0

        ! Loop through the array to find cycles to rotate
        do cycleStart = 1, l_len - 1
            item = list(cycleStart)

            ! Find where to put the item
            pos = cycleStart + count(list(cycleStart + 1:l_len) < item)

            ! If the item is already there, this is not a cycle
            if (pos == cycleStart) then
                cycle
            end if

            ! Otherwise, put the item there or right after any duplicates
            pos = pos + findloc(list(pos:l_len) /= item, .true., dim=1, back=.false.) - 1
            swap_tmp = list(pos)
            list(pos) = item
            item = swap_tmp
            writes = writes + 1

            ! Rotate the rest of the cycle
            do while (pos /= cycleStart)
                ! Find where to put the item
                pos = cycleStart + count(list(cycleStart + 1:l_len) < item)
                ! Put the item there or right after any duplicates
                pos = pos + findloc(list(pos:l_len) /= item, .true., dim=1, back=.false.) - 1
                swap_tmp = list(pos)
                list(pos) = item
                item = swap_tmp
                writes = writes + 1
            end do
        end do

        return ! Return the number of writes

    end function ccyclesort
    end module cycler

program cycle_sort_driver
    use cycler
    implicit none
    integer, parameter :: n = 20
    real :: rlist(n)
    integer :: writes, i,list(n)

    ! Seed the random number generator
    call random_seed()

    ! Generate 20 random integers between 0 and 17
    do i = 1, n
        call random_number(rlist(i))
        list(i) = int(rlist(i) * 18.0)  ! Scale to 0-17
    end do

    ! Print the unsorted array
    print *, 'Unsorted array:'
    print '(20I4)', list

    ! Call the cycle sort function
    writes = ccyclesort(list, n)

    ! Print the sorted array
    print *, 'Sorted array:'
    print '(20I4)', list

    ! Print the number of writes
    print *, 'Number of writes:', writes, 'For ',n,' integers'

end program cycle_sort_driver
