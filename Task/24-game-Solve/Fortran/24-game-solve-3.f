module game24_module
    use omp_lib
    use iso_fortran_env, only: int64
    implicit none
    ! Define constants
    integer, parameter :: max_limit = 8     ! Maximum allowed value for the number of inputs
    integer, parameter :: expr_len = 200   ! Maximum length for expressions

    ! Precomputed total calls for n=6,7,8
    integer(int64), parameter :: total_calls_n6 = 20000000_int64
    integer(int64), parameter :: total_calls_n7 = 2648275200_int64
    integer(int64), parameter :: total_calls_n8 = 444557593600_int64

    !----------------------- Progress Indicator Variables ---------------------
    integer(int64) :: total_calls = 0           ! Total number of recursive calls
    integer(int64) :: completed_calls = 0       ! Number of completed recursive calls
    integer :: last_percentage = -1              ! Last percentage reported
    integer, parameter :: progress_bar_width = 50  ! Width of the progress bar
    character(len=1) :: carriage_return = char(13) ! Carriage return character
    logical :: show_progress = .false.           ! Flag to show progress bar
    !--------------------------------------------------------------------------
contains

    !-----------------------------------------------------------------------
    ! ! Aborted function: calculate_total_calls
    ! ! Description:
    ! !   Estimates the total number of recursive calls for a given n,
    ! !   considering commutativity (addition and multiplication).
    ! ! Arguments:
    ! !   n: The number of input numbers.
    ! ! Returns:
    ! !   The estimated total number of recursive calls as an integer.
    ! !-----------------------------------------------------------------------
    ! integer function calculate_total_calls(n)
    !     implicit none
    !     integer, intent(in) :: n
    !     integer :: k
    !     calculate_total_calls = 1
    !     do k = 2, n
    !         ! For each pair, there are 6 possible operations:
    !         ! 1 addition, 1 multiplication (commutative)
    !         ! 2 subtraction, 2 division (non-commutative)
    !         calculate_total_calls = calculate_total_calls * ((k * (k - 1)) / 2) * 6
    !     end do
    ! end function calculate_total_calls

    !-----------------------------------------------------------------------
    ! Subroutine: convert_to_number
    ! Description:
    !   Converts user input (numbers or card values) into numeric values.
    !   Handles card values such as 'A', 'J', 'Q', 'K' and converts them into
    !   corresponding numbers (A=1, J=11, Q=12, K=13).
    ! Arguments:
    !   input_str: Input string representing the number or card.
    !   number:    Output real number after conversion.
    !   ios:       I/O status indicator (0 for success, non-zero for error).
    !-----------------------------------------------------------------------
    subroutine convert_to_number(input_str, number, ios)
        implicit none
        character(len=*), intent(in) :: input_str
        real, intent(out)            :: number
        integer, intent(out)         :: ios
        character(len=1)             :: first_char
        real                         :: temp_number

        ios = 0  ! Reset the I/O status to 0 (valid input by default)
        first_char = input_str(1:1)

        select case (first_char)
        case ('A', 'a')
            number = 1.0
        case ('J', 'j')
            number = 11.0
        case ('Q', 'q')
            number = 12.0
        case ('K', 'k')
            number = 13.0
        case default
            read (input_str, *, iostat=ios) temp_number  ! Attempt to read a real number

            ! If input is not a valid real number or is not an integer, set ios to 1
            if (ios /= 0 .or. mod(temp_number, 1.0) /= 0.0) then
                ios = 1  ! Invalid input
            else
                number = temp_number  ! Valid integer input
            end if
        end select
    end subroutine convert_to_number

    !-----------------------------------------------------------------------
    ! Subroutine: remove_decimal_zeros
    ! Description:
    !   Removes trailing zeros after the decimal point from a string.
    ! Arguments:
    !   str:    Input string that may contain trailing zeros.
    !   result: Output string with trailing zeros removed.
    !-----------------------------------------------------------------------
    subroutine remove_decimal_zeros(str, result)
        implicit none
        character(len=*), intent(in)  :: str       ! Input: String to remove zeros from
        character(len=*), intent(out) :: result    ! Output: String without trailing zeros
        integer                        :: i, len_str  ! Loop counter and string length

        len_str = len_trim(str)
        result = adjustl(str(1:len_str))

        ! Find the position of the decimal point
        i = index(result, '.')

        ! If there's a decimal point, remove trailing zeros
        if (i > 0) then
            do while (len_str > i .and. result(len_str:len_str) == '0')
                len_str = len_str - 1
            end do
            if (result(len_str:len_str) == '.') len_str = len_str - 1
            result = result(1:len_str)
        end if
    end subroutine remove_decimal_zeros

    !-----------------------------------------------------------------------
    ! Subroutine: create_new_arrays
    ! Description:
    !   Creates new arrays after performing an operation.
    ! Arguments:
    !   nums:      Input array of numbers.
    !   exprs:     Input array of expressions.
    !   idx1:      Index of the first element to remove.
    !   idx2:      Index of the second element to remove.
    !   result:    Result of the operation.
    !   new_expr:  New expression string.
    !   new_nums:  Output array of numbers with elements removed and result added.
    !   new_exprs: Output array of expressions with elements removed and new_expr added.
    !-----------------------------------------------------------------------
    subroutine create_new_arrays(nums, exprs, idx1, idx2, result, new_expr, new_nums, new_exprs)
        implicit none
        real, intent(in)                        :: nums(:)       ! Input: Array of numbers
        character(len=expr_len), intent(in)     :: exprs(:)      ! Input: Array of expressions
        integer, intent(in)                     :: idx1, idx2    ! Input: Indices of elements to remove
        real, intent(in)                        :: result        ! Input: Result of the operation
        character(len=expr_len), intent(in)     :: new_expr      ! Input: New expression
        real, allocatable, intent(out)          :: new_nums(:)   ! Output: New array of numbers
        character(len=expr_len), allocatable, intent(out) :: new_exprs(:) ! Output: New array of expressions
        integer                                 :: i, j, n       ! Loop counters and size of input arrays

        n = size(nums)
        allocate (new_nums(n - 1))
        allocate (new_exprs(n - 1))

        j = 0
        do i = 1, n
            if (i /= idx1 .and. i /= idx2) then
                j = j + 1
                new_nums(j) = nums(i)
                new_exprs(j) = exprs(i)
            end if
        end do

        ! Add the result of the operation to the new arrays
        new_nums(n - 1) = result
        new_exprs(n - 1) = new_expr
    end subroutine create_new_arrays

    !-----------------------------------------------------------------------
    ! Subroutine: update_progress_bar
    ! Description:
    !   Updates and displays the horizontal percentage-based progress bar.
    ! Arguments:
    !   None
    !-----------------------------------------------------------------------
    subroutine update_progress_bar()
        implicit none
        real :: percentage
        integer :: filled_length
        character(len=progress_bar_width) :: bar
        integer :: int_percentage

        if (total_calls == 0 .or. .not. show_progress) return  ! Avoid division by zero and check the flag

        percentage = real(completed_calls) / real(total_calls) * 100.0

        ! Ensure percentage does not exceed 100%
        if (percentage > 100.0) percentage = 100.0

        ! Calculate integer percentage
        int_percentage = int(percentage)

        ! Update progress bar only when percentage increases by at least 1%
        if (int_percentage > last_percentage) then
            last_percentage = int_percentage

            ! Calculate the filled length of the progress bar
            filled_length = min(int(percentage / 100.0 * progress_bar_width), progress_bar_width)

            ! Construct the progress bar string
            bar = repeat('=', filled_length)
            if (filled_length < progress_bar_width) then
                bar = bar//'>'//repeat(' ', progress_bar_width - filled_length - 1)
            end if

            ! Print the progress bar and integer percentage
            write (*, '(A, F4.1, A)', advance='no') carriage_return//'['//bar//'] ', percentage, '%'
            call flush (0)  ! Ensure output is displayed immediately
        end if
    end subroutine update_progress_bar

    !-----------------------------------------------------------------------
    ! Recursive Subroutine: solve_24
    ! Description:
    !   Recursively solves the 24 game by trying all possible operations.
    !   Utilizes OpenMP tasks for parallelization.
    ! Arguments:
    !   nums:   Array of numbers to use in the game.
    !   exprs:  Array of string expressions representing the numbers.
    !   found:  Logical flag indicating if a solution has been found.
    !-----------------------------------------------------------------------
    recursive subroutine solve_24(nums, exprs, found)
        use omp_lib
        implicit none
        real, intent(in)                         :: nums(:)       ! Input: Array of numbers
        character(len=expr_len), intent(in)      :: exprs(:)      ! Input: Array of expressions
        logical, intent(inout)                   :: found         ! Input/Output: Flag indicating if a solution is found
        integer                                  :: n             ! Size of the input arrays
        integer                                  :: i, j, op      ! Loop counters
        real                                     :: a, b, result  ! Temporary variables for calculations
        real, allocatable                        :: new_nums(:)   ! Temp array to store numbers after an operation
        character(len=expr_len), allocatable     :: new_exprs(:)  ! Temp array to store expressions after an operation
        character(len=expr_len)                  :: expr_a, expr_b, new_expr ! Temp variables for expressions

        n = size(nums)

        ! Increment the completed_calls counter and update progress bar
        if (show_progress) then
            !$omp atomic
            completed_calls = completed_calls + 1
            call update_progress_bar()
        end if

        ! If a solution is found, return
        if (found) return

        ! Base case: If only one number is left, check if it is 24
        if (n == 1) then
            if (abs(nums(1) - 24.0) < 1e-4) then
                if (show_progress) then
                    write (*, '(A, F5.1, A)', advance='no') carriage_return//'['//repeat('=', progress_bar_width)//'] ', 100.0, '%'
                    write (*, '(A)') ''  ! Insert a blank line
                end if
                !$omp critical
                write (*, '(A, A, A, F10.7, A)') 'Solution found:', trim(exprs(1)), '= 24 (', nums(1), ')'
                found = .true.
                !$omp end critical
            end if
            return
        end if

        ! Iterate over all pairs of numbers
        do i = 1, n - 1
            do j = i + 1, n
                a = nums(i)
                b = nums(j)
                expr_a = exprs(i)
                expr_b = exprs(j)

                ! Iterate over all operators
                do op = 1, 4
                    ! Avoid division by zero
                    if ((op == 4 .and. abs(b) < 1e-6)) cycle

                    ! Perform the operation and create the new expression
                    select case (op)
                    case (1)
                        result = a + b
                        new_expr = '('//trim(expr_a)//'+'//trim(expr_b)//')'
                    case (2)
                        result = a - b
                        new_expr = '('//trim(expr_a)//'-'//trim(expr_b)//')'
                    case (3)
                        result = a * b
                        new_expr = '('//trim(expr_a)//'*'//trim(expr_b)//')'
                    case (4)
                        result = a / b
                        new_expr = '('//trim(expr_a)//'/'//trim(expr_b)//')'
                    end select

                    ! Create new arrays with the selected numbers removed
                    call create_new_arrays(nums, exprs, i, j, result, new_expr, new_nums, new_exprs)

                    ! For the first few recursion levels, create parallel tasks
                    if (n >= 6 .and. omp_get_level() < 2) then
                        !$omp task shared(found) firstprivate(new_nums, new_exprs)
                        call solve_24(new_nums, new_exprs, found)
                        !$omp end task
                    else
                        call solve_24(new_nums, new_exprs, found)
                    end if

                    ! If a solution is found, deallocate memory and return
                    if (found) then
                        deallocate (new_nums)
                        deallocate (new_exprs)
                        return
                    end if

                    ! Handle commutative operations only once
                    if (op == 1 .or. op == 3) cycle

                    ! Swap operands for subtraction and division
                    if (op == 2 .or. op == 4) then
                        if (op == 4 .and. abs(a) < 1e-6) cycle  ! Avoid division by zero

                        select case (op)
                        case (2)
                            result = b - a
                            new_expr = '('//trim(expr_b)//'-'//trim(expr_a)//')'
                        case (4)
                            result = b / a
                            new_expr = '('//trim(expr_b)//'/'//trim(expr_a)//')'
                        end select

                        ! Create new arrays with the selected numbers removed
                        call create_new_arrays(nums, exprs, i, j, result, new_expr, new_nums, new_exprs)

                        ! For the first few recursion levels, create parallel tasks
                        if (n >= 6 .and. omp_get_level() < 2) then
                            !$omp task shared(found) firstprivate(new_nums, new_exprs)
                            call solve_24(new_nums, new_exprs, found)
                            !$omp end task
                        else
                            ! Recursively call the solve_24 function with the new arrays
                            call solve_24(new_nums, new_exprs, found)
                        end if

                        ! If a solution is found, deallocate memory and return
                        if (found) then
                            deallocate (new_nums)
                            deallocate (new_exprs)
                            return
                        end if
                    end if

                end do  ! End of operator loop
            end do  ! End of j loop
        end do  ! End of i loop
    end subroutine solve_24

end module game24_module

program game24
    use game24_module
    implicit none

    ! Declare variables
    integer                        :: maxn            ! Number of numbers to be entered by the user
    real, allocatable              :: numbers(:)      ! Array to store the numbers entered by the user
    character(len=expr_len), allocatable :: expressions(:)  ! Array to store the expressions
    integer                        :: i, ios          ! Loop counter and I/O status
    logical                        :: found_solution  ! Flag to indicate if a solution was found
    character(len=10)              :: user_input      ! Variable to store user input
    character(len=1)               :: play_again      ! Variable to store the user's decision

    do  ! Game loop to allow restarting the game

        ! Prompt the user for the number of numbers to use in the game
        do
            write (*, '(A,I0,A)', advance='no') 'Enter the number of numbers (1 to ', max_limit, '): '
            read (*, *, iostat=ios) maxn

            ! Check if the input is valid
            if (ios /= 0) then
                write (*, '(A,I0,A)') 'Invalid input. Please enter an integer between 1 and ', max_limit, '.'
                cycle
            end if

            ! Validate the input: Ensure the number of numbers is within the valid range
            if (maxn < 1 .or. maxn > max_limit) then
                write (*, '(A,I0,A)') 'Error: Number of numbers must be between 1 and ', max_limit, '. Try again.'
                cycle
            end if

            exit  ! Exit loop if the input is valid
        end do

        ! Allocate memory for the arrays based on the number of numbers
        allocate (numbers(maxn))
        allocate (expressions(maxn))

        ! Prompt the user to enter the numbers or card values
        write (*, '(A,I0,A)') 'Enter ', maxn, ' numbers or card values (A=1, J=11, Q=12, K=13).'
        do i = 1, maxn
            do
                ! Prompt the user to enter a number or card value
                write (*, '(A,I0,A)', advance='no') 'Enter value for card ', i, ': '
                read (*, '(A)', iostat=ios) user_input

                ! Check if input is an integer or valid card symbol (A, J, Q, K)
                call convert_to_number(user_input, numbers(i), ios)

                ! If the input is valid, exit loop
                if (ios == 0) exit

                ! Invalid input: prompt the user to try again
                write (*, '(A)') 'Invalid input. Please enter an integer or valid card symbol (A, J, Q, K).'
            end do

            ! Convert the number to a string expression and remove trailing zeros
            write (expressions(i), '(F0.2)') numbers(i)
            call remove_decimal_zeros(expressions(i), expressions(i))
        end do

        ! Initialize the solution flag to false
        found_solution = .false.

        ! Assign precomputed total_calls based on n
        select case (maxn)
        case (6)
            total_calls = total_calls_n6
        case (7)
            total_calls = total_calls_n7
        case (8)
            total_calls = total_calls_n8
        case default
            total_calls = 0
        end select

        ! Decide whether to show progress bar based on n
        if (maxn >= 6) then
            show_progress = .true.
            completed_calls = 0
            last_percentage = -1

            ! Initialize progress bar display
            write (*, '(A)', advance='no') '['//repeat(' ', progress_bar_width)//'] 0%'
            call flush (0)  ! Ensure the output is displayed immediately
        else
            show_progress = .false.
        end if

        ! Start parallel region
        !$omp parallel
        !$omp single nowait
        call solve_24(numbers, expressions, found_solution)
        !$omp end single
        !$omp end parallel

        ! After search completes, ensure the progress bar reaches 100% if shown
        if (show_progress .and. .not. found_solution) then
            write (*, '(A, A)', advance='no') carriage_return//'['//repeat('=', progress_bar_width)//'] 100%  '
            call flush (0)
            write (*, '(A)') ''  ! Insert a blank line
        end if

        ! If a solution was found and progress bar is shown, ensure a blank line
        if (show_progress .and. found_solution) then
            ! Progress bar already refreshed to 100% and blank line inserted in solve_24
        end if

        ! If no solution was found, print a message
        if (.not. found_solution) then
            write (*, '(A)') 'No valid solution found.'
        end if

        ! Deallocate the memory used by the arrays
        deallocate (numbers)
        deallocate (expressions)

        ! Ask the user if they want to play again
        if (show_progress) then
            write (*, '(A)', advance='no') carriage_return//'Play again? (Enter y/n to continue or any other key to exit): '
        else
            write (*, '(A)', advance='no') 'Play again? (Enter y/n to continue or any other key to exit): '
        end if
        read (*, '(A)') play_again  ! Read user input

        ! Check if the user wants to exit
        if (play_again /= 'y' .and. play_again /= 'Y') exit

    end do  ! End of game loop

    write (*, '(A)') 'Exiting the game...'

end program game24
