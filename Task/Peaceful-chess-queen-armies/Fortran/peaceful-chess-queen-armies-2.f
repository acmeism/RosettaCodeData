module peaceful_queens_support
  use, non_intrinsic :: peaceful_queens_elements

  implicit none
  private

  public :: write_board
  public :: write_board_without_spaces
  public :: write_board_with_spaces

  public :: save_a_solution

  interface write_board
     module procedure write_board_without_spaces
     module procedure write_board_with_spaces
  end interface write_board

contains

  subroutine write_board_without_spaces (unit, army_b, army_w)
    integer, intent(in) :: unit
    integer(kind = board_kind), intent(in) :: army_b, army_w

    call write_board_with_spaces (unit, army_b, army_w, 0)
  end subroutine write_board_without_spaces

  subroutine write_board_with_spaces (unit, army_b, army_w, num_spaces)
    integer, intent(in) :: unit
    integer(kind = board_kind), intent(in) :: army_b, army_w
    integer, intent(in) :: num_spaces

    integer(kind = board_kind), parameter :: zero = 0
    integer(kind = board_kind), parameter :: one = 1

    integer :: i, j
    integer(kind = board_kind) :: rank_b, rank_w
    integer(kind = board_kind) :: mask

    character(1), allocatable :: queens(:)
    character(4), allocatable :: rules(:)
    character(1), allocatable :: spaces(:)

    allocate (queens(0 : n - 1))
    allocate (rules(0 : n - 1))
    allocate (spaces(1 : num_spaces))

    rules = "----"
    if (0 < num_spaces) then
       spaces = " "             ! For putting spaces after newlines.
    end if

    mask = not (ishft (not (zero), n))
    write (unit, '("+", 100(A4, "+"))') rules
    do i = 0, n - 1
       rank_b = iand (mask, ishft (army_b, -i * n))
       rank_w = iand (mask, ishft (army_w, -i * n))
       do j = 0, n - 1
          if (iand (rank_b, ishft (one, j)) /= 0) then
             queens(j) = "B"
          else if (iand (rank_w, ishft (one, j)) /= 0) then
             queens(j) = "W"
          else
             queens(j) = " "
          end if
       end do
       write (unit, '(100A1)', advance = 'no') spaces
       write (unit, '("|", 100(A3, " |"))') queens
       write (unit, '(100A1)', advance = 'no') spaces
       if (i /= n - 1) then
          write (unit, '("+", 100(A4, "+"))') rules
       else
          write (unit, '("+", 100(A4, "+"))', advance = 'no') rules
       end if
    end do
  end subroutine write_board_with_spaces

  subroutine save_a_solution (army1, army2, num_solutions, armies1, armies2)
    integer(kind = board_kind), intent(in) :: army1, army2
    integer, intent(inout) :: num_solutions
    integer(kind = board_kind), intent(inout) :: armies1(1:8, 1:max_solutions)
    integer(kind = board_kind), intent(inout) :: armies2(1:8, 1:max_solutions)

    ! A sanity check.
    if (queens_attack_check (army1, army2)) then
       error stop
    end if

    num_solutions = num_solutions + 1

    armies1(1, num_solutions) = army1
    armies1(2, num_solutions) = board_rotate90 (army1)
    armies1(3, num_solutions) = board_rotate180 (army1)
    armies1(4, num_solutions) = board_rotate270 (army1)
    armies1(5, num_solutions) = board_reflect1 (army1)
    armies1(6, num_solutions) = board_reflect2 (army1)
    armies1(7, num_solutions) = board_reflect3 (army1)
    armies1(8, num_solutions) = board_reflect4 (army1)

    armies2(1, num_solutions) = army2
    armies2(2, num_solutions) = board_rotate90 (army2)
    armies2(3, num_solutions) = board_rotate180 (army2)
    armies2(4, num_solutions) = board_rotate270 (army2)
    armies2(5, num_solutions) = board_reflect1 (army2)
    armies2(6, num_solutions) = board_reflect2 (army2)
    armies2(7, num_solutions) = board_reflect3 (army2)
    armies2(8, num_solutions) = board_reflect4 (army2)
  end subroutine save_a_solution

end module peaceful_queens_support

module peaceful_queens_solver
  use, non_intrinsic :: peaceful_queens_elements
  use, non_intrinsic :: peaceful_queens_support

  implicit none
  private

  public :: solve_peaceful_queens

  integer(kind = board_kind), parameter :: zero = 0_board_kind
  integer(kind = board_kind), parameter :: one = 1_board_kind
  integer(kind = board_kind), parameter :: two = 2_board_kind

contains

  subroutine solve_peaceful_queens (unit, show_equivalents, &
       &                            num_solutions, armies1, armies2)
    integer, intent(in) :: unit
    logical, intent(in) :: show_equivalents
    integer, intent(out) :: num_solutions
    integer(kind = board_kind), intent(out) :: armies1(1:8, 1:max_solutions)
    integer(kind = board_kind), intent(out) :: armies2(1:8, 1:max_solutions)

    call solve (zero, 0, 0, zero, 0, 0, 0)

  contains

    recursive subroutine solve (army1, rooklike11, rooklike12, &
         &                      army2, rooklike21, rooklike22, index)
      integer(kind = board_kind), value :: army1
      integer, value :: rooklike11, rooklike12
      integer(kind = board_kind), value :: army2
      integer, value :: rooklike21, rooklike22
      integer, value :: index

      integer :: num_queens1
      integer :: num_queens2
      integer(kind = board_kind) :: new_army
      integer(kind = board_kind) :: new_army_reversed
      integer :: bit1, bit2
      logical :: skip

      num_queens1 = popcnt (army1)
      num_queens2 = popcnt (army2)

      if (num_queens1 + num_queens2 == 2 * m) then
         if (.not. is_a_duplicate (army1, army2, num_solutions, armies1, armies2)) then
            call save_a_solution (army1, army2, num_solutions, armies1, armies2)
            write (unit, '("Solution ", I0)') num_solutions
            call write_board (unit, army1, army2)
            write (unit, '()')
            write (unit, '()')
            call optionally_write_equivalents
         end if
      else if (num_queens1 - num_queens2 == 0) then
         ! It is time to add a queen to army1.
         do while (num_solutions < max_solutions .and. index /= n**2)
            skip = .false.
            new_army = ior (army1, ishft (one, index))
            if (new_army == army1) then
               skip = .true.
            else if (index < n) then
               new_army_reversed = board_reflect1 (new_army)
               if (new_army_reversed < new_army) then
                  ! Skip a bunch of board_reflect1 equivalents.
                  skip = .true.
               end if
            end if
            if (skip) then
               index = index + 1
            else
               bit1 = ishft (1, index / n)
               bit2 = ishft (1, mod (index, n))
               if (iand (rooklike21, bit1) /= 0) then
                  index = round_up_to_multiple (index + 1, n)
               else if (iand (rooklike22, bit2) /= 0) then
                  index = index + 1
               else if (bishops_attack_check (new_army, army2)) then
                  index = index + 1
               else
                  call solve (new_army, &
                       &      ior (rooklike11, bit1), &
                       &      ior (rooklike12, bit2), &
                       &      army2, rooklike21, rooklike22, &
                       &      n)
                  index = index + 1
               end if
            end if
         end do
      else
         ! It is time to add a queen to army2.
         do while (num_solutions < max_solutions .and. index /= n**2)
            new_army = ior (army2, ishft (one, index))
            skip = (new_army == army2)
            if (skip) then
               index = index + 1
            else
               bit1 = ishft (1, index / n)
               bit2 = ishft (1, mod (index, n))
               if (iand (rooklike11, bit1) /= 0) then
                  index = round_up_to_multiple (index + 1, n)
               else if (iand (rooklike12, bit2) /= 0) then
                  index = index + 1
               else if (bishops_attack_check (army1, new_army)) then
                  index = index + 1
               else
                  call solve (army1, rooklike11, rooklike12, &
                       &      new_army, &
                       &      ior (rooklike21, bit1), &
                       &      ior (rooklike22, bit2), &
                       &      0)
                  index = index + 1
               end if
            end if
         end do
      end if
    end subroutine solve

    subroutine optionally_write_equivalents
      integer :: i

      if (show_equivalents) then
         write (unit, '(5X)', advance = 'no')
         write (unit, '("Equivalents")')

         write (unit, '(5X)', advance = 'no')
         call write_board (unit, armies2(1, num_solutions), armies1(1, num_solutions), 5)
         write (unit, '()')
         write (unit, '()')

         do i = 2, 5
            if (all ((armies1(i, num_solutions) /= armies1(1 : i - 1, num_solutions) .or. &
                 &    armies2(i, num_solutions) /= armies2(1 : i - 1, num_solutions)) .and. &
                 &   (armies2(i, num_solutions) /= armies1(1 : i - 1, num_solutions) .or. &
                 &    armies1(i, num_solutions) /= armies2(1 : i - 1, num_solutions)))) then
               write (unit, '(5X)', advance = 'no')
               call write_board (unit, armies1(i, num_solutions), armies2(i, num_solutions), 5)
               write (unit, '()')
               write (unit, '()')
               write (unit, '(5X)', advance = 'no')
               call write_board (unit, armies2(i, num_solutions), armies1(i, num_solutions), 5)
               write (unit, '()')
               write (unit, '()')
            end if
         end do
      end if
    end subroutine optionally_write_equivalents

  end subroutine solve_peaceful_queens

  elemental function round_up_to_multiple (x, n) result (y)
    integer, value :: x, n
    integer :: y

    y = x + mod (n - mod (x, n), n)
  end function round_up_to_multiple

  pure function is_a_duplicate (army1, army2, num_solutions, armies1, armies2) result (is_dup)
    integer(kind = board_kind), intent(in) :: army1, army2
    integer, intent(in) :: num_solutions
    integer(kind = board_kind), intent(in) :: armies1(1:8, 1:max_solutions)
    integer(kind = board_kind), intent(in) :: armies2(1:8, 1:max_solutions)
    logical :: is_dup

    is_dup = any ((army1 == armies1(:, 1:num_solutions) .and. &
         &         army2 == armies2(:, 1:num_solutions)) .or. &
         &        (army2 == armies1(:, 1:num_solutions) .and. &
         &         army1 == armies2(:, 1:num_solutions)))
  end function is_a_duplicate

end module peaceful_queens_solver

program peaceful_queens
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, non_intrinsic :: peaceful_queens_elements
  use, non_intrinsic :: peaceful_queens_support
  use, non_intrinsic :: peaceful_queens_solver

  implicit none

  integer :: num_solutions
  logical :: show_equivalents
  integer(kind = board_kind) :: armies1(1:8, 1:max_solutions)
  integer(kind = board_kind) :: armies2(1:8, 1:max_solutions)

  integer :: arg_count
  character(len = 200) :: arg

  show_equivalents = .false.

  arg_count = command_argument_count ()
  if (1 <= arg_count) then
     call get_command_argument (1, arg)
     select case (trim (arg))
     case ('1', 't', 'T', 'true', 'y', 'Y', 'yes')
        show_equivalents = .true.
     end select
  end if

  call solve_peaceful_queens (output_unit, show_equivalents, &
       &                      num_solutions, armies1, armies2)

end program peaceful_queens
