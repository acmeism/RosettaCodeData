program szymanski_algorithm
    implicit none

    ! Define constants for state representation
    integer, parameter :: OUTSIDE = 0
    integer, parameter :: WAITING_ROOM = 1
    integer, parameter :: WAITING_FOR_OTHERS = 2
    integer, parameter :: DOORWAY = 3
    integer, parameter :: IN_CRITICAL_SECTION = 4

    ! Maximum number of processes
    integer, parameter :: MAX_PROCESSES = 100

    ! Global variables
    integer :: flags(MAX_PROCESSES)
    integer :: critical_value
    integer :: n_processes

    ! Initialize and run test
    call test_szymanski(5)  ! Using smaller number for sequential simulation

contains

    subroutine run_szymanski(id)
        implicit none
        integer, intent(in) :: id
        integer :: i, t
        logical :: condition_met
        integer :: wait_count

        write(*,'(A,I0,A)') 'Process ', id, ' starting'

        ! Standing outside waiting room
        flags(id) = WAITING_ROOM
        write(*,'(A,I0,A)') 'Process ', id, ' entered waiting room'

        ! Wait until no other process is in or passing through the doorway
        wait_count = 0
        do
            condition_met = .false.
            do i = 1, n_processes
                if (i /= id .and. flags(i) >= DOORWAY) then
                    condition_met = .true.
                    exit
                endif
            end do

            if (.not. condition_met) exit

            wait_count = wait_count + 1
            if (mod(wait_count, 1000) == 0) then
                write(*,'(A,I0,A,I0)') 'Process ', id, ' waiting for doorway, count: ', wait_count
            endif
        end do

        ! Standing in doorway
        flags(id) = DOORWAY
        write(*,'(A,I0,A)') 'Process ', id, ' entered doorway'

        ! Check if other processes are still waiting
        condition_met = .false.
        do i = 1, n_processes
            if (i /= id .and. flags(i) == WAITING_ROOM) then
                condition_met = .true.
                exit
            endif
        end do

        if (condition_met) then
            ! Waiting for other processes to enter
            flags(id) = WAITING_FOR_OTHERS
            write(*,'(A,I0,A)') 'Process ', id, ' waiting for others'

            ! Wait for other processes to close the door
            wait_count = 0
            do
                condition_met = .false.
                do i = 1, n_processes
                    if (i /= id .and. flags(i) == IN_CRITICAL_SECTION) then
                        condition_met = .true.
                        exit
                    endif
                end do

                if (condition_met) exit

                wait_count = wait_count + 1
                if (mod(wait_count, 1000) == 0) then
                    write(*,'(A,I0,A,I0)') 'Process ', id, ' waiting for door close, count: ', wait_count
                endif
            end do
        endif

        ! The door is closed
        flags(id) = IN_CRITICAL_SECTION
        write(*,'(A,I0,A)') 'Process ', id, ' marked as in critical section'

        ! Wait for lower numbered processes
        do t = 1, id - 1
            wait_count = 0
            do
                if (flags(t) <= WAITING_ROOM) exit

                wait_count = wait_count + 1
                if (mod(wait_count, 1000) == 0) then
                    write(*,'(A,I0,A,I0,A,I0)') 'Process ', id, ' waiting for process ', t, ', count: ', wait_count
                endif
            end do
        end do

        ! Critical section
        write(*,'(A,I0,A)') 'Process ', id, ' ENTERING CRITICAL SECTION'
        critical_value = critical_value + id * 3
        critical_value = critical_value / 2
        write(*,'(A,I0,A,I0,A)') 'Thread ', id, ' changed the critical value to ', &
                                critical_value, '.'
        write(*,'(A,I0,A)') 'Process ', id, ' EXITING CRITICAL SECTION'

        ! Exit protocol
        do t = id + 1, n_processes
            wait_count = 0
            do
                condition_met = (flags(t) /= OUTSIDE .and. &
                               flags(t) /= WAITING_ROOM .and. &
                               flags(t) /= IN_CRITICAL_SECTION)

                if (.not. condition_met) exit

                wait_count = wait_count + 1
                if (mod(wait_count, 1000) == 0) then
                    write(*,'(A,I0,A,I0,A,I0)') 'Process ', id, ' exit waiting for process ', t, ', count: ', wait_count
                endif
            end do
        end do

        ! Leave
        flags(id) = OUTSIDE
        write(*,'(A,I0,A)') 'Process ', id, ' left and is outside'

    end subroutine run_szymanski

    subroutine test_szymanski(n)
        implicit none
        integer, intent(in) :: n
        integer :: i

        n_processes = n
        critical_value = 1

        ! Initialize flags
        do i = 1, MAX_PROCESSES
            flags(i) = OUTSIDE
        end do

        write(*,'(A,I0,A)') 'Starting Szymanski algorithm simulation with ', n, ' processes'
        write(*,'(A,I0)') 'Initial critical value: ', critical_value
        write(*,*)

        ! Sequential simulation of concurrent processes
        ! In a real concurrent system, these would run in parallel
        do i = 1, n
            write(*,'(A,I0)') '=== Running process ', i, ' ==='
            call run_szymanski(i)
            write(*,*)
        end do

        write(*,'(A,I0)') 'Final critical value: ', critical_value

    end subroutine test_szymanski

end program szymanski_algorithm
