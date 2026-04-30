program cocktail_sort_demo
    implicit none
    integer, parameter :: n = 12
    integer :: arr(n)
    integer :: i
!
    call system_clock(count=i)  ! Get a value we can use as a seed
    call srand(i)               ! Set random number seed
    do i = 1,n
        arr(i) = irand(0)       ! Fill with random integers
    end do
    print *, "Original array:"
    print *, arr

    call cocktail_sort(arr, n)

    print *, "Sorted array:"
    print *, arr

contains

!===========================================================
! Subroutine: cocktail_sort
! Purpose   : Sort an integer array using the Cocktail Sort
!             algorithm (also known as bidirectional bubble sort).
!             This algorithm repeatedly traverses the array in
!             both directions, bubbling the largest element to
!             the end and the smallest element to the beginning.
!===========================================================
subroutine cocktail_sort(A, n)
    ! Input:  n = number of elements in the array
    ! InOut:  A = integer array to be sorted in ascending order

    integer, intent(in)    :: n        ! size of the array
    integer, intent(inout) :: A(n)     ! array to be sorted
    integer :: beginIdx                ! current left boundary of unsorted region
    integer :: endIdx                  ! current right boundary of unsorted region
    integer :: newBeginIdx             ! updated left boundary after backward pass
    integer :: newEndIdx               ! updated right boundary after forward pass
    integer :: i                       ! loop index
    integer :: temp                    ! temporary variable for swapping

    ! Initialize boundaries:
    ! beginIdx starts at the first element (index 1 in Fortran arrays).
    ! endIdx starts at the last element (index n-1, since we compare A(i) with A(i+1)).
    beginIdx = 1
    endIdx   = n - 1

    ! Outer loop: continue until the left boundary crosses the right boundary.
    ! Each iteration performs one forward pass and one backward pass.
    do while (beginIdx <= endIdx)

        ! Reset new boundaries for this iteration.
        ! These will track the last swap positions to shrink the unsorted region.
        newBeginIdx = endIdx
        newEndIdx   = beginIdx

        !---------------------------------------------------
        ! Forward pass: move left to right.
        ! Compare each pair A(i), A(i+1) and swap if out of order.
        ! This bubbles the largest element toward the right end.
        !---------------------------------------------------
        do i = beginIdx, endIdx
            if (A(i) > A(i+1)) then
                ! Swap elements A(i) and A(i+1)
                temp   = A(i)
                A(i)   = A(i+1)
                A(i+1) = temp

                ! Track the last index where a swap occurred.
                ! This helps reduce the range for the next pass.
                newEndIdx = i
            end if
        end do

        ! After forward pass, update right boundary.
        ! Elements beyond newEndIdx are already in correct position.
        endIdx = newEndIdx - 1

        !---------------------------------------------------
        ! Backward pass: move right to left.
        ! Compare each pair A(i), A(i+1) and swap if out of order.
        ! This bubbles the smallest element toward the left end.
        !---------------------------------------------------
        do i = endIdx, beginIdx, -1
            if (A(i) > A(i+1)) then
                ! Swap elements A(i) and A(i+1)
                temp   = A(i)
                A(i)   = A(i+1)
                A(i+1) = temp

                ! Track the last index where a swap occurred.
                ! This helps reduce the range for the next pass.
                newBeginIdx = i
            end if
        end do

        ! After backward pass, update left boundary.
        ! Elements before newBeginIdx are already in correct position.
        beginIdx = newBeginIdx + 1

    end do
end subroutine cocktail_sort
end program cocktail_sort_demo
