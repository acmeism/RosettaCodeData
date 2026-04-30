!Deadlock prevented by making one philosopher "left-handed"
!and making orderly use of omp locks which protect forks by ensuring that only one philosopher can use each fork at a time
    program dining_philosophers
    use omp_lib
    implicit none

    integer, parameter :: N = 5
    integer(omp_lock_kind) :: forks(N)
    character(len=20), dimension(N) :: names = [character(len=20) :: &
        "Aristotle", "Kant", "Spinoza", "Marx", "Russell"]
    integer :: i
    integer :: next_thread = 0  ! Shared sequencing variable

    ! Initialize forks (mutexes)
    do i = 1, N
        call omp_init_lock(forks(i))
    end do

    ! Parallel region with N threads
    !$omp parallel num_threads(N) private(i) shared(next_thread, forks, names)
        i = omp_get_thread_num() + 1  ! Philosopher IDs: 1 to N
        call philosopher(i, next_thread, forks, names)
    !$omp end parallel

    ! Destroy locks
    do i = 1, N
        call omp_destroy_lock(forks(i))
    end do

contains

    subroutine philosopher(id, next_thread, forks, names)
        integer, intent(in) :: id
        integer, intent(inout) :: next_thread
        integer(omp_lock_kind), intent(inout) :: forks(:)
        character(len=20), intent(in) :: names(:)
        integer :: left, right, meals

        left = id
        right = mod(id, size(forks)) + 1  ! Wrap around for right fork
        !$omp barrier
        ! Wait for turn to start
        do while (id - 1 /= next_thread)
            !$omp flush(next_thread)
        end do

        print *, trim(names(id)), " sits down at the table."

        !$omp atomic
        next_thread = next_thread + 1
        !$omp flush(next_thread)

        ! Philosopher's meal loop
        do meals = 1, 20
!            print *, trim(names(id)), " is thinking."
!            call sleep(1)

            ! Asymmetric fork acquisition to prevent deadlock
            if (id < size(forks)) then
                call omp_set_lock(forks(left))
                print *, trim(names(id)), " picked up left fork ", left
                call omp_set_lock(forks(right))
                print *, trim(names(id)), " picked up right fork ", right
            else
                call omp_set_lock(forks(right))
                print *, trim(names(id)), " picked up right fork ", right
                call omp_set_lock(forks(left))
                print *, trim(names(id)), " picked up left fork ", left
            end if

            print *, trim(names(id)), " is eating."
            call sleep(1)

            call omp_unset_lock(forks(left))
            call omp_unset_lock(forks(right))
            print *, trim(names(id)), " put down forks."
            print *, trim(names(id)), " is thinking."
            call sleep(1)
            print *, trim(names(id)), " returns to the table."

        end do

        print *, trim(names(id)), " leaves the table."
    end subroutine philosopher

end program dining_philosophers
