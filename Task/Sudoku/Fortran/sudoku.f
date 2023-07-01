program sudoku

  implicit none
  integer, dimension (9, 9) :: grid
  integer, dimension (9, 9) :: grid_solved
  grid = reshape ((/               &
    & 0, 0, 3, 0, 2, 0, 6, 0, 0,   &
    & 9, 0, 0, 3, 0, 5, 0, 0, 1,   &
    & 0, 0, 1, 8, 0, 6, 4, 0, 0,   &
    & 0, 0, 8, 1, 0, 2, 9, 0, 0,   &
    & 7, 0, 0, 0, 0, 0, 0, 0, 8,   &
    & 0, 0, 6, 7, 0, 8, 2, 0, 0,   &
    & 0, 0, 2, 6, 0, 9, 5, 0, 0,   &
    & 8, 0, 0, 2, 0, 3, 0, 0, 9,   &
    & 0, 0, 5, 0, 1, 0, 3, 0, 0/), &
    & shape = (/9, 9/),            &
    & order = (/2, 1/))
  call pretty_print (grid)
  call solve (1, 1)
  write (*, *)
  call pretty_print (grid_solved)

contains

  recursive subroutine solve (i, j)
    implicit none
    integer, intent (in) :: i
    integer, intent (in) :: j
    integer :: n
    integer :: n_tmp
    if (i > 9) then
      grid_solved = grid
    else
      do n = 1, 9
        if (is_safe (i, j, n)) then
          n_tmp = grid (i, j)
          grid (i, j) = n
          if (j == 9) then
            call solve (i + 1, 1)
          else
            call solve (i, j + 1)
          end if
          grid (i, j) = n_tmp
        end if
      end do
    end if
  end subroutine solve

  function is_safe (i, j, n) result (res)
    implicit none
    integer, intent (in) :: i
    integer, intent (in) :: j
    integer, intent (in) :: n
    logical :: res
    integer :: i_min
    integer :: j_min
    if (grid (i, j) == n) then
      res = .true.
      return
    end if
    if (grid (i, j) /= 0) then
      res = .false.
      return
    end if
    if (any (grid (i, :) == n)) then
      res = .false.
      return
    end if
    if (any (grid (:, j) == n)) then
      res = .false.
      return
    end if
    i_min = 1 + 3 * ((i - 1) / 3)
    j_min = 1 + 3 * ((j - 1) / 3)
    if (any (grid (i_min : i_min + 2, j_min : j_min + 2) == n)) then
      res = .false.
      return
    end if
    res = .true.
  end function is_safe

  subroutine pretty_print (grid)
    implicit none
    integer, dimension (9, 9), intent (in) :: grid
    integer :: i
    integer :: j
    character (*), parameter :: bar = '+-----+-----+-----+'
    character (*), parameter :: fmt = '(3 ("|", i0, 1x, i0, 1x, i0), "|")'
    write (*, '(a)') bar
    do j = 0, 6, 3
      do i = j + 1, j + 3
        write (*, fmt) grid (i, :)
      end do
      write (*, '(a)') bar
    end do
  end subroutine pretty_print

end program sudoku
