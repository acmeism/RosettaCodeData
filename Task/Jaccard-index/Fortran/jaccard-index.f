program jaccard_similarity
    implicit none
    integer, parameter :: max_sets = 6
    integer, parameter :: max_elements = 10
    integer :: tests(max_sets, max_elements)
    integer :: test_sizes(max_sets)
    integer :: i, j, k
    real :: jaccard_val

    ! Initialize test data
    call initialize_tests()

    ! Print header
    write(*,'(A19,A19,A10)') '     Set A', 'Set B', 'J(A, B)'
    write(*,'(A45)') '---------------------------------------------'

    ! Calculate and display Jaccard indices
    do i = 1, max_sets
        do j = 1, max_sets
            jaccard_val = jaccard_index(i, j)
            call print_sets_with_jaccard(i, j, jaccard_val)
        end do
    end do

contains

    subroutine initialize_tests()
        ! Set 1: empty set
        test_sizes(1) = 0

        ! Set 2: [1, 2, 3, 4, 5]
        tests(2, 1:5) = [1, 2, 3, 4, 5]
        test_sizes(2) = 5

        ! Set 3: [1, 3, 5, 7, 9]
        tests(3, 1:5) = [1, 3, 5, 7, 9]
        test_sizes(3) = 5

        ! Set 4: [2, 4, 6, 8, 10]
        tests(4, 1:5) = [2, 4, 6, 8, 10]
        test_sizes(4) = 5

        ! Set 5: [2, 3, 5, 7]
        tests(5, 1:4) = [2, 3, 5, 7]
        test_sizes(5) = 4

        ! Set 6: [8]
        tests(6, 1:1) = [8]
        test_sizes(6) = 1
    end subroutine initialize_tests

    function jaccard_index(set_a_idx, set_b_idx) result(jaccard_val)
        integer, intent(in) :: set_a_idx, set_b_idx
        real :: jaccard_val
        integer :: intersection_count, union_count
        logical :: in_set_a(100)  ! Assuming elements are in range 1-100
        logical :: in_union(100)
        integer :: i, element

        ! Initialize arrays
        in_set_a = .false.
        in_union = .false.
        intersection_count = 0
        union_count = 0

        ! Build set A
        do i = 1, test_sizes(set_a_idx)
            element = tests(set_a_idx, i)
            if (element >= 1 .and. element <= 100) then
                in_set_a(element) = .true.
                in_union(element) = .true.
            end if
        end do

        ! Count intersection and build union
        do i = 1, test_sizes(set_b_idx)
            element = tests(set_b_idx, i)
            if (element >= 1 .and. element <= 100) then
                if (in_set_a(element)) then
                    ! Only count each element once for intersection
                    if (in_union(element)) then
                        intersection_count = intersection_count + 1
                        in_union(element) = .false.  ! Mark as counted
                    end if
                else
                    in_union(element) = .true.
                end if
            end if
        end do

        ! Count total union elements
        union_count = 0
        do i = 1, 100
            if (in_union(i)) union_count = union_count + 1
        end do

        ! Reset in_union for proper union count
        in_union = .false.

        ! Rebuild proper union
        do i = 1, test_sizes(set_a_idx)
            element = tests(set_a_idx, i)
            if (element >= 1 .and. element <= 100) then
                in_union(element) = .true.
            end if
        end do

        do i = 1, test_sizes(set_b_idx)
            element = tests(set_b_idx, i)
            if (element >= 1 .and. element <= 100) then
                in_union(element) = .true.
            end if
        end do

        union_count = count(in_union)

        ! Reset in_set_a for proper intersection count
        in_set_a = .false.
        do i = 1, test_sizes(set_a_idx)
            element = tests(set_a_idx, i)
            if (element >= 1 .and. element <= 100) then
                in_set_a(element) = .true.
            end if
        end do

        intersection_count = 0
        do i = 1, test_sizes(set_b_idx)
            element = tests(set_b_idx, i)
            if (element >= 1 .and. element <= 100) then
                if (in_set_a(element)) then
                    intersection_count = intersection_count + 1
                    in_set_a(element) = .false.  ! Avoid double counting
                end if
            end if
        end do

        ! Handle edge cases
        if (union_count == 0) then
            jaccard_val = 1.0
        else if (intersection_count == 0) then
            jaccard_val = 0.0
        else
            jaccard_val = real(intersection_count) / real(union_count)
        end if
    end function jaccard_index

    subroutine print_sets_with_jaccard(set_a_idx, set_b_idx, jaccard_val)
        integer, intent(in) :: set_a_idx, set_b_idx
        real, intent(in) :: jaccard_val
        character(len=100) :: set_a_str, set_b_str

        call array_to_string(set_a_idx, set_a_str)
        call array_to_string(set_b_idx, set_b_str)

        write(*,'(A19,A19,F10.5)') trim(set_a_str), trim(set_b_str), jaccard_val
    end subroutine print_sets_with_jaccard

    subroutine array_to_string(set_idx, result_str)
        integer, intent(in) :: set_idx
        character(len=*), intent(out) :: result_str
        character(len=100) :: temp_str
        integer :: i

        result_str = '['

        if (test_sizes(set_idx) == 0) then
            result_str = trim(result_str) // ']'
            return
        end if

        do i = 1, test_sizes(set_idx)
            write(temp_str, '(I0)') tests(set_idx, i)
            if (i == 1) then
                result_str = trim(result_str) // trim(temp_str)
            else
                result_str = trim(result_str) // ', ' // trim(temp_str)
            end if
        end do

        result_str = trim(result_str) // ']'
    end subroutine array_to_string

end program jaccard_similarity
