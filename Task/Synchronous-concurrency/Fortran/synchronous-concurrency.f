program concurrent_line_printer
    ! Uses OpenMP to create 2 threads and manage the communication between them.
    use omp_lib
    implicit none

    character(len=256) :: shared_line
    integer :: shared_count
    integer :: state  ! 0=ready, 1=line_available, 2=reading_done, 3=count_available

    state = 0
    shared_count = 0

    !$omp parallel sections num_threads(2)

    !$omp section
    call reader_thread()

    !$omp section
    call printer_thread()

    !$omp end parallel sections

contains

    subroutine reader_thread()
        integer :: io_stat, unit_num, final_count
        character(len=256) :: line

        open(newunit=unit_num, file='input.txt', status='old', action='read', iostat=io_stat)
        if (io_stat /= 0) then
            print *, "Error: Cannot open input.txt"
            !$omp atomic write
            state = 2
            return
        end if

        ! Read and send each line
        do
            read(unit_num, '(A)', iostat=io_stat) line
            if (io_stat /= 0) exit

            ! Wait for printer to be ready
            do while (state /= 0)
                !$omp flush(state)
            end do

            ! Send line to printer
            shared_line = line
            !$omp flush(shared_line)
            !$omp atomic write
            state = 1
        end do

        close(unit_num)

        ! Wait for last line to be processed
        do while (state == 1)
            !$omp flush(state)
        end do

        ! Signal reading is done
        !$omp atomic write
        state = 2

        ! Wait for count to be available
        do while (state /= 3)
            !$omp flush(state)
        end do

        !$omp flush(shared_count)
        final_count = shared_count

        print *, "Number of lines printed by printer thread:", final_count

    end subroutine reader_thread

    subroutine printer_thread()
        character(len=256) :: line
        integer :: count, current_state

        count = 0

        do
            ! Wait for line or done signal
            do
                !$omp flush(state)
                current_state = state
                if (current_state /= 0) exit
            end do

            if (current_state == 2) exit  ! Reading done

            ! Get and print line
            !$omp flush(shared_line)
            line = shared_line
            count = count + 1
            print *, trim(line)

            ! Signal line processed
            !$omp atomic write
            state = 0
        end do

        ! Send count back to reader
        shared_count = count
        !$omp flush(shared_count)
        !$omp atomic write
        state = 3

    end subroutine printer_thread

end program concurrent_line_printer
