module knuth_s
    implicit none
    private
    public :: s_of_n_creator, free_sample, sample_state, s_of_n

    ! Type to hold sample state
    type :: sample_state
        integer :: n
        integer :: count
        integer, allocatable :: sample(:)
    end type sample_state

contains

    ! Subroutine to create the s_of_n sampling function
    subroutine s_of_n_creator(n, state)
        integer, intent(in) :: n
        type(sample_state), pointer :: state

        allocate (state)
        state % n = n
        state % count = 0
        allocate (state % sample(n))
    end subroutine s_of_n_creator

    ! Function to perform sampling
    function s_of_n(state, item) result(current_sample)
        type(sample_state), pointer :: state
        integer, intent(in) :: item
        integer, pointer :: current_sample(:)
        real :: r
        integer :: j

        ! Add item to sample if we haven't reached n yet
        if (state % count < state % n) then
            state % count = state % count + 1
            state % sample(state % count) = item
        else
            ! Knuth's Algorithm S: select with probability n/i
            call random_number(r)
            if (r < real(state % n) / real(state % count + 1)) then
                ! Randomly replace one of the existing items
                call random_number(r)
                j = int(r * state % n) + 1
                state % sample(j) = item
            end if
            state % count = state % count + 1
        end if
        current_sample => state % sample
    end function s_of_n

    ! Cleanup function to deallocate sample state
    subroutine free_sample(state)
        type(sample_state), pointer :: state
        deallocate (state % sample)
        deallocate (state)
    end subroutine free_sample

end module knuth_s

program test_knuth_s
    use knuth_s
    implicit none
    type(sample_state), pointer :: state
    integer, pointer :: sample(:)
    integer :: i, j, k, reps
    integer :: frequencies(0:9)
    character(len=50) :: sample_str
    integer :: n, timex(8)
    integer, allocatable :: seed(:)
    call random_seed(size=n)
    allocate (seed(n))
    call date_and_time(values=timex)
    seed(1) = timex(5) * 3600000 + timex(6) * 60000 + timex(7) * 1000 + timex(8)
    do i = 2, n
      seed(i) = seed(1) + 37 * (i - 1)
    end do
    ! Initialize random seed
    call random_seed(put=seed)

    ! Show one run's sampling progression
    print *, 'Single run samples for n = 3:'
    call s_of_n_creator(3, state)
    do i = 0, 9
        sample => s_of_n(state, i)
        ! Format sample output
        sample_str = ''
        write (sample_str, '("[", *(I0, ", "))') sample(1:min(state % count, 3))
        if (state % count > 0) then
            sample_str = trim(sample_str)
            sample_str = sample_str(1:len_trim(sample_str) - 1)//']'
        else
            sample_str = '[]'
        end if
        print '(A, I0, A, A)', '  Item: ', i, ' -> sample: ', trim(sample_str)
    end do
    call free_sample(state)

    ! Initialize frequency counter
    frequencies = 0

    ! Run 100,000 repetitions to count final sample frequencies
    reps = 100000
    do i = 1, reps
        call s_of_n_creator(3, state)
        do j = 0, 9
            sample => s_of_n(state, j)
        end do
        ! Count frequencies from final sample
        do k = 1, 3
            frequencies(sample(k)) = frequencies(sample(k)) + 1
        end do
        call free_sample(state)
    end do

    ! Print frequency results
    print *, 'Test item frequencies for ', reps, ' runs:'
    do i = 0, 9
        print '(I2, ": ", I5)', i, frequencies(i)
    end do
end program test_knuth_s
