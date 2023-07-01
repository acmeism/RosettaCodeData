!!!
!!! Find a Knight’s Tour.
!!!
!!! Use Warnsdorff’s heuristic, but write the program so it should not
!!! be able to terminate unsuccessfully.
!!!

module knights_tour
  use, intrinsic :: iso_fortran_env, only: output_unit, error_unit

  implicit none
  private

  public :: find_a_knights_tour
  public :: notation_is_a_square

  integer, parameter :: number_of_ranks = 8
  integer, parameter :: number_of_files = 8
  integer, parameter :: number_of_squares = number_of_ranks * number_of_files

  ! ‘Algebraic’ chess notation.
  character, parameter :: rank_notation(1:8) = (/ '1', '2', '3', '4', '5', '6', '7', '8' /)
  character, parameter :: file_notation(1:8) = (/ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' /)

  type :: board_square_t
     ! Squares are represented by their algebraic notation.
     character(2) :: algebraic_notation
   contains
     procedure, pass :: output => board_square_t_output
     procedure, pass :: knight_moves => board_square_t_knight_moves
     procedure, pass :: equal => board_square_t_equal
     generic :: operator(==) => equal
  end type board_square_t

  type :: knight_moves_t
     integer :: number_of_squares
     type(board_square_t) :: squares(1:8)
  end type knight_moves_t

  type :: path_t
     integer :: length
     type(board_square_t) :: squares(1:number_of_squares)
   contains
     procedure, pass :: output => path_t_output
  end type path_t

contains

  pure function notation_is_a_square (notation) result (bool)
    character(*), intent(in) :: notation
    logical :: bool

    integer :: length
    integer :: rank_no
    integer :: file_no

    length = len_trim (notation)
    if (length /= 2) then
       bool = .false.
    else
       rank_no = findloc (rank_notation, notation(2:2), 1)
       file_no = findloc (file_notation, notation(1:1), 1)
       bool = (1 <= rank_no .and. rank_no <= number_of_ranks)         &
            &   .and. (1 <= file_no .and. file_no <= number_of_files)
    end if
  end function notation_is_a_square

  subroutine path_t_output (path, unit)
    !
    ! Print a path in algebraic notation.
    !
    class(path_t), intent(in) :: path
    integer, intent(in) :: unit

    integer :: moves_counter
    integer :: i

    moves_counter = 1
    if (1 <= path%length) then
       call path%squares(1)%output(unit)
       do i = 2, path%length
          if (moves_counter == 8) then
             write (unit, '(" ->")', advance = 'yes')
             moves_counter = 1
          else
             write (unit, '(" -> ")', advance = 'no')
             moves_counter = moves_counter + 1
          end if
          call path%squares(i)%output(unit)
       end do
    end if
    write (output_unit, '()')
  end subroutine path_t_output

  subroutine board_square_t_output (square, unit)
    !
    ! Print a square in algebraic notation.
    !
    class(board_square_t), intent(in) :: square
    integer, intent(in) :: unit

    write (unit, '(A2)', advance = 'no') square%algebraic_notation
  end subroutine board_square_t_output

  elemental function board_square_t_equal (p, q) result (bool)
    class(board_square_t), intent(in) :: p, q
    logical :: bool

    bool = (p%algebraic_notation == q%algebraic_notation)
  end function board_square_t_equal

  pure function board_square_t_knight_moves (square) result (moves)
    !
    ! Return all possible moves of a knight from a given square.
    !
    class(board_square_t), intent(in) :: square
    type(knight_moves_t) :: moves

    integer, parameter :: rank_stride(1:number_of_ranks) = (/ +1, +2, +1, +2, -1, -2, -1, -2 /)
    integer, parameter :: file_stride(1:number_of_files) = (/ +2, +1, -2, -1, +2, +1, -2, -1 /)

    integer :: rank_no, file_no
    integer :: new_rank_no, new_file_no
    integer :: i
    character(2) :: notation

    rank_no = findloc (rank_notation, square%algebraic_notation(2:2), 1)
    file_no = findloc (file_notation, square%algebraic_notation(1:1), 1)

    moves%number_of_squares = 0
    do i = 1, 8
       new_rank_no = rank_no + rank_stride(i)
       new_file_no = file_no + file_stride(i)
       if (1 <= new_rank_no                           &
            & .and. new_rank_no <= number_of_ranks    &
            & .and. 1 <= new_file_no                  &
            & .and. new_file_no <= number_of_files) then
          moves%number_of_squares = moves%number_of_squares + 1
          notation(2:2) = rank_notation(new_rank_no)
          notation(1:1) = file_notation(new_file_no)
          moves%squares(moves%number_of_squares) = board_square_t (notation)
       end if
    end do
  end function board_square_t_knight_moves

  pure function unvisited_knight_moves (path) result (moves)
    !
    ! Return moves of a knight from a given square, but only those
    ! that have not been visited already.
    !
    class(path_t), intent(in) :: path
    type(knight_moves_t) :: moves

    type(knight_moves_t) :: all_moves
    integer :: i

    all_moves = path%squares(path%length)%knight_moves()
    moves%number_of_squares = 0
    do i = 1, all_moves%number_of_squares
       if (all (.not. all_moves%squares(i) == path%squares(1:path%length))) then
          moves%number_of_squares = moves%number_of_squares + 1
          moves%squares(moves%number_of_squares) = all_moves%squares(i)
       end if
    end do
  end function unvisited_knight_moves

  pure function potential_knight_moves (path) result (moves)
    !
    ! Return moves of a knight from a given square, but only those
    ! that are unvisited, and from which another unvisited move can be
    ! made.
    !
    ! Sort the returned moves in nondecreasing order of the number of
    ! possible moves after the first. (This is how we implement
    ! Warnsdorff’s heuristic.)
    !
    class(path_t), intent(in) :: path
    type(knight_moves_t) :: moves

    type(knight_moves_t) :: unvisited_moves
    type(knight_moves_t) :: next_moves
    type(path_t) :: next_path
    type(board_square_t) :: unpruned_squares(1:8)
    integer :: warnsdorff_numbers(1:8)
    integer :: number_of_unpruned_squares
    integer :: i

    if (path%length == number_of_squares - 1) then
       !
       ! There is only one square left on the board. Either the knight
       ! can reach it or it cannot.
       !
       moves = unvisited_knight_moves (path)
    else
       !
       ! Use Warnsdorff’s heuristic: return unvisited moves, but try
       ! first those with the least number of possible moves following
       ! it.
       !
       ! If the number of possible moves following is zero, prune the
       ! move, because it is a dead end.
       !
       number_of_unpruned_squares = 0
       unvisited_moves = unvisited_knight_moves (path)
       do i = 1, unvisited_moves%number_of_squares
          next_path%length = path%length + 1
          next_path%squares(1:path%length) = path%squares(1:path%length)
          next_path%squares(next_path%length) = unvisited_moves%squares(i)

          next_moves = unvisited_knight_moves (next_path)

          if (next_moves%number_of_squares /= 0) then
             number_of_unpruned_squares = number_of_unpruned_squares + 1
             unpruned_squares(number_of_unpruned_squares) = unvisited_moves%squares(i)
             warnsdorff_numbers(number_of_unpruned_squares) = next_moves%number_of_squares
          end if
       end do

       ! In-place insertion sort of the unpruned squares.
       block
         type(board_square_t) :: square
         integer :: w_number
         integer :: i, j

         i = 2
         do while (i <= number_of_unpruned_squares)
            square = unpruned_squares(i)
            w_number = warnsdorff_numbers(i)
            j = i - 1
            do while (1 <= j .and. w_number < warnsdorff_numbers(j))
               unpruned_squares(j + 1) = unpruned_squares(j)
               warnsdorff_numbers(j + 1) = warnsdorff_numbers(j)
               j = j - 1
            end do
            unpruned_squares(j + 1) = square
            warnsdorff_numbers(j + 1) = w_number
            i = i + 1
         end do
       end block

       moves%number_of_squares = number_of_unpruned_squares
       moves%squares(1:number_of_unpruned_squares) = &
            & unpruned_squares(1:number_of_unpruned_squares)
    end if
  end function potential_knight_moves

  subroutine find_a_knights_tour (starting_square)
    !
    ! Find and print a full knight’s tour.
    !
    character(2), intent(in) :: starting_square

    type(path_t) :: path

    path%length = 1
    path%squares(1) = board_square_t (starting_square)
    path = try_paths (path)
    if (path%length /= 0) then
       call path%output(output_unit)
    else
       write (error_unit, '("The program terminated without finding a solution.")')
       write (error_unit, '("This is supposed to be impossible for an 8-by-8 board.")')
       write (error_unit, '("The program is wrong.")')
       error stop
    end if

  contains

    recursive function try_paths (path) result (solution)
      !
      ! Recursively try all possible paths, but using Warnsdorff’s
      ! heuristic to speed up the search.
      !
      class(path_t), intent(in) :: path
      type(path_t) :: solution

      type(path_t) :: new_path
      type(knight_moves_t) :: moves
      integer :: i

      if (path%length == number_of_squares) then
         solution = path
      else
         solution%length = 0

         moves = potential_knight_moves (path)

         if (moves%number_of_squares /= 0) then
            new_path%length = path%length + 1
            new_path%squares(1:path%length) = path%squares(1:path%length)

            i = 1
            do while (solution%length == 0 .and. i <= moves%number_of_squares)
               new_path%squares(new_path%length) = moves%squares(i)
               solution = try_paths (new_path)
               i = i + 1
            end do
         end if
      end if
    end function try_paths

  end subroutine find_a_knights_tour

end module knights_tour

program knights_tour_main
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, non_intrinsic :: knights_tour
  implicit none

  character(200) :: arg
  integer :: arg_count
  integer :: i

  arg_count = command_argument_count ()
  do i = 1, arg_count
     call get_command_argument (i, arg)
     arg = adjustl (arg)
     if (1 < i) write (output_unit, '()')
     if (notation_is_a_square (arg)) then
        call find_a_knights_tour (arg)
     else
        write (output_unit, '("This is not algebraic notation: ", A)') arg
     end if
  end do
end program knights_tour_main
