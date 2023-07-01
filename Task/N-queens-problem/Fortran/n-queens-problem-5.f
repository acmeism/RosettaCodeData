program example__n_queens

  use, intrinsic :: iso_fortran_env, only: output_unit

  use, non_intrinsic :: garbage_collector
  use, non_intrinsic :: cons_pairs

  implicit none

  ! .true. is good for testing that necessary values are rooted.
  ! .false. to collect garbage only when the heap reaches a limit.
  logical :: aggressive_garbage_collection = .true.

  integer :: arg_count
  integer :: stat
  character(80) :: arg

  type(gcroot_t) :: board_sizes

  arg_count = command_argument_count ()
  if (arg_count < 1) then
     call print_usage (output_unit)
  else
     board_sizes = nil
     block
       integer :: i
       integer :: board_size
       do i = 1, arg_count
          call get_command_argument (i, arg)
          read (arg, *, iostat = stat) board_size
          if (stat /= 0 .or. board_size < 1) then
             board_size = -1
          end if
          board_sizes = cons (board_size, board_sizes)
       end do
       board_sizes = reversex (board_sizes)
     end block

     if (is_member (int_eq, -1, board_sizes)) then
        call print_usage (output_unit)
     else
        ! Use pair_for_each as a way to distinguish the last
        ! BOARD_SIZE from the others. The last entry will be the final
        ! pair, and so its CDR will *not* be a pair.
        call pair_for_each (find_and_print_all_solutions, &
             &              circular_list (output_unit), &
             &              board_sizes)
     end if
  end if

contains

  subroutine print_usage (outp)
    integer, intent(in) :: outp

    write (outp, '("Usage: example__n_queens BOARD_SIZE [BOARD_SIZE...]")')
    write (outp, '("Each BOARD_SIZE must be at least 1.")')
    write (outp, '("For each BOARD_SIZE, all solutions are computed before any is printed.")')
  end subroutine print_usage

  subroutine find_and_print_all_solutions (outp_pair, board_sizes)
    class(*), intent(in) :: outp_pair
    class(*), intent(in) :: board_sizes

    integer :: n_outp
    type(gcroot_t) :: all_solutions

    n_outp = int_cast (car (outp_pair))

    all_solutions = find_all_solutions (car (board_sizes))
    call check_garbage
    call print_all_solutions (n_outp, car (board_sizes), all_solutions)
    call check_garbage
    if (is_pair (cdr (board_sizes))) then
       ! Space between one BOARD_SIZE and another.
       write (n_outp, '()')
    end if
  end subroutine find_and_print_all_solutions

  function find_all_solutions (board_size) result (all_solutions)
    class(*), intent(in) :: board_size
    type(cons_t) :: all_solutions

    class(*), allocatable :: solutions

    call find_solutions_from_ranks_so_far (board_size, nil, solutions)
    all_solutions = solutions
  end function find_all_solutions

  recursive subroutine find_solutions_from_ranks_so_far (board_size, ranks_so_far, solutions)
    class(*), intent(in) :: board_size
    class(*), intent(in) :: ranks_so_far
    class(*), allocatable, intent(out) :: solutions

    type(cons_t) :: ranks

    if (length (ranks_so_far) == int_cast (board_size)) then
       solutions = list (ranks_so_far)
    else
       ranks = find_legal_ranks_for_file (int_cast (board_size), ranks_so_far)
       solutions = concatenatex (map (find_solutions_from_ranks_so_far,                  &
            &                         circular_list (board_size),                        &
            &                         map (kons, ranks, circular_list (ranks_so_far))))
    end if
  end subroutine find_solutions_from_ranks_so_far

  function find_legal_ranks_for_file (board_size, ranks_so_far) result (ranks)
    !
    ! Return a list of all the ranks in the next file, under the
    ! constraint that a queen placed in the position not be under
    ! attack.
    !
    integer, intent(in) :: board_size
    class(*), intent(in) :: ranks_so_far
    type(cons_t) :: ranks

    ranks = iota (board_size, 1) ! All the possible ranks.
    ranks = remove_illegal_ranks (ranks, ranks_so_far)
  end function find_legal_ranks_for_file

  function remove_illegal_ranks (new_ranks, ranks_so_far) result (legal_ranks)
    class(*), intent(in) :: new_ranks
    class(*), intent(in) :: ranks_so_far
    type(cons_t) :: legal_ranks

    legal_ranks = filter_map (keep_legal_rank, new_ranks, &
         &                    circular_list (ranks_so_far))
  end function remove_illegal_ranks

  subroutine keep_legal_rank (rank, ranks_so_far, retval)
    class(*), intent(in) :: rank
    class(*), intent(in) :: ranks_so_far
    class(*), allocatable, intent(out) :: retval

    if (rank_is_legal (rank, ranks_so_far)) then
       retval = rank
    else
       retval = .false.
    end if
  end subroutine keep_legal_rank

  function rank_is_legal (new_rank, ranks_so_far) result (bool)
    class(*), intent(in) :: new_rank
    class(*), intent(in) :: ranks_so_far
    logical :: bool

    integer :: new_file
    type(cons_t) :: files_so_far

    new_file = int (length (ranks_so_far)) + 1
    files_so_far = iota (new_file - 1, new_file - 1, -1)
    bool = every (these_two_queens_are_nonattacking, &
         &        circular_list (new_file),          &
         &        circular_list (new_rank),          &
         &        files_so_far,                      &
         &        ranks_so_far)
  end function rank_is_legal

  function these_two_queens_are_nonattacking (file1, rank1, file2, rank2) result (bool)
    class(*), intent(in) :: file1, rank1
    class(*), intent(in) :: file2, rank2
    logical :: bool

    integer :: f1, r1
    integer :: f2, r2

    ! The rank and the two diagonals must not be the same. (The files
    ! are known to be different.)

    f1 = int_cast (file1)
    r1 = int_cast (rank1)
    f2 = int_cast (file2)
    r2 = int_cast (rank2)

    bool = (r1 /= r2 .and. r1 + f1 /= r2 + f2 .and. r1 - f1 /= r2 - f2)
  end function these_two_queens_are_nonattacking

  subroutine print_all_solutions (outp, board_size, all_solutions)
    class(*), intent(in) :: outp
    class(*), intent(in) :: board_size
    class(*), intent(in) :: all_solutions

    integer(size_kind) :: n

    n = length (all_solutions)
    write (int_cast (outp), '("For a board ", I0, " by ", I0, ", ")', advance = 'no') &
         &    int_cast (board_size), int_cast (board_size)
    if (n == 1) then
       write (int_cast (outp), '("there is ", I0, " solution.")') n
    else
       write (int_cast (outp), '("there are ", I0, " solutions.")') n
    end if
    call for_each (print_spaced_solution, circular_list (outp), &
         &         circular_list (board_size), all_solutions)
  end subroutine print_all_solutions

  subroutine print_spaced_solution (outp, board_size, solution)
    class(*), intent(in) :: outp
    class(*), intent(in) :: board_size
    class(*), intent(in) :: solution

    write (int_cast (outp), '()', advance = 'yes')
    call print_solution (outp, board_size, solution)
  end subroutine print_spaced_solution

  subroutine print_solution (outp, board_size, solution)
    class(*), intent(in) :: outp
    class(*), intent(in) :: board_size
    class(*), intent(in) :: solution

    integer :: n_outp
    integer :: n_board_size
    integer :: rank
    integer :: file
    integer :: file_of_queen

    n_outp = int_cast (outp)
    n_board_size = int_cast (board_size)

    do rank = n_board_size, 1, -1
       do file = 1, n_board_size
          write (n_outp, '("----")', advance = 'no')
       end do
       write (n_outp, '("-")', advance = 'yes')

       file_of_queen = n_board_size - int (list_index0 (int_eq, circular_list (rank), solution))

       do file = 1, n_board_size
          if (file == file_of_queen) then
             write (n_outp, '("| Q ")', advance = 'no')
          else
             write (n_outp, '("|   ")', advance = 'no')
          end if
       end do
       write (n_outp, '("|")', advance = 'yes')
    end do

    do file = 1, n_board_size
       write (n_outp, '("----")', advance = 'no')
    end do
    write (n_outp, '("-")', advance = 'yes')
  end subroutine print_solution

  subroutine kons (x, y, xy)
    class(*), intent(in) :: x
    class(*), intent(in) :: y
    class(*), allocatable, intent(out) :: xy

    xy = cons (x, y)
  end subroutine kons

  pure function int_cast (x) result (val)
    class(*), intent(in) :: x
    integer :: val

    select type (x)
    type is (integer)
       val = x
    class default
       error stop
    end select
  end function int_cast

  pure function int_eq (x, y) result (bool)
    class(*), intent(in) :: x
    class(*), intent(in) :: y
    logical :: bool

    bool = (int_cast (x) == int_cast (y))
  end function int_eq

  subroutine check_garbage
    if (aggressive_garbage_collection) then
       call collect_garbage_now
    else
       call check_heap_size
    end if
  end subroutine check_garbage

end program example__n_queens
