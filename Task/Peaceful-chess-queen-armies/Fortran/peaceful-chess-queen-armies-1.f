program peaceful_queens_elements_generator
  use, intrinsic :: iso_fortran_env, only: int64
  use, intrinsic :: iso_fortran_env, only: error_unit

  implicit none

  ! 64-bit integers, for boards up to 8-by-8.
  integer, parameter :: kind8x8 = int64

  ! 128-bit integers, for boards up to 11-by-11.
  ! This value is correct for gfortran.
  integer, parameter :: kind11x11 = 16

  integer(kind = kind11x11), parameter :: one = 1
  integer(kind = kind11x11), parameter :: two = 2

  integer, parameter :: n_max = 11

  integer(kind = kind11x11) :: rook1_masks(0 : n_max - 1)
  integer(kind = kind11x11) :: rook2_masks(0 : n_max - 1)
  integer(kind = kind11x11) :: bishop1_masks(0 : (2 * n_max) - 4)
  integer(kind = kind11x11) :: bishop2_masks(0 : (2 * n_max) - 4)

  ! Combines rook1_masks and rook2_masks.
  integer(kind = kind11x11) :: rook_masks(0 : (2 * n_max) - 1)

  ! Combines bishop1_masks and bishop2_masks.
  integer(kind = kind11x11) :: bishop_masks(0 : (4 * n_max) - 7)

  ! Combines rook and bishop masks.
  integer(kind = kind11x11) :: queen_masks(0 : (6 * n_max) - 7)

  character(len = 16), parameter :: s_kind8x8 = "kind8x8         "
  character(len = 16), parameter :: s_kind11x11 = "kind11x11       "

  character(200) :: arg
  integer :: arg_count

  integer :: m, n, max_solutions
  integer :: board_kind

  arg_count = command_argument_count ()
  if (arg_count /= 3) then
     call get_command_argument (0, arg)
     write (error_unit, '("Usage: ", A, " M N MAX_SOLUTIONS")') trim (arg)
     stop 1
  end if

  call get_command_argument (1, arg)
  read (arg, *) m
  if (m < 1) then
     write (error_unit, '("M must be between 1 or greater.")')
     stop 2
  end if

  call get_command_argument (2, arg)
  read (arg, *) n
  if (n < 3 .or. 11 < n) then
     write (error_unit, '("N must be between 3 and ", I0, ", inclusive.")') n_max
     stop 2
  end if

  call get_command_argument (3, arg)
  read (arg, *) max_solutions

  write (*, '("module peaceful_queens_elements")')
  write (*, '()')
  write (*, '("  use, intrinsic :: iso_fortran_env, only: int64")')
  write (*, '()')
  write (*, '("  implicit none")')
  write (*, '("  private")')
  write (*, '()')
  write (*, '("  integer, parameter, public :: m = ", I0)') m
  write (*, '("  integer, parameter, public :: n = ", I0)') n
  write (*, '("  integer, parameter, public :: max_solutions = ", I0)') max_solutions
  write (*, '()')
  if (n <= 8) then
     write (*, '("  ! 64-bit integers, for boards up to 8-by-8.")')
     write (*, '("  integer, parameter, private :: kind8x8 = int64")')
  else
     write (*, '("  ! 128-bit integers, for boards up to 11-by-11.")')
     write (*, '("  integer, parameter, private :: kind11x11 = ", I0)') kind11x11
  end if
  write (*, '("  integer, parameter, public :: board_kind = ", A)') trim (s_kindnxn (n))
  write (*, '()')
  write (*, '()')
  write (*, '("  public :: rooks1_attack_check")')
  write (*, '("  public :: rooks2_attack_check")')
  write (*, '("  public :: rooks_attack_check")')
  write (*, '("  public :: bishops1_attack_check")')
  write (*, '("  public :: bishops2_attack_check")')
  write (*, '("  public :: bishops_attack_check")')
  write (*, '("  public :: queens_attack_check")')
  write (*, '()')
  write (*, '("  public :: board_rotate90")')
  write (*, '("  public :: board_rotate180")')
  write (*, '("  public :: board_rotate270")')
  write (*, '("  public :: board_reflect1")')
  write (*, '("  public :: board_reflect2")')
  write (*, '("  public :: board_reflect3")')
  write (*, '("  public :: board_reflect4")')
  write (*, '()')

  call write_rook1_masks
  call write_rook2_masks
  call write_bishop1_masks
  call write_bishop2_masks
  call write_rook_masks
  call write_bishop_masks
  call write_queen_masks

  write (*, '("contains")')
  write (*, '()')

  call write_rooks1_attack_check
  call write_rooks2_attack_check
  call write_bishops1_attack_check
  call write_bishops2_attack_check
  call write_rooks_attack_check
  call write_bishops_attack_check
  call write_queens_attack_check

  call write_board_rotate90
  call write_board_rotate180
  call write_board_rotate270
  call write_board_reflect1
  call write_board_reflect2
  call write_board_reflect3
  call write_board_reflect4

  call write_insert_zeros
  call write_reverse_insert_zeros

  write (*, '("end module peaceful_queens_elements")')

contains

  subroutine write_rook1_masks
    integer :: i

    call fill_masks (n)
    do i = 0, n - 1
       write (*, '("  integer(kind = ", A, "), parameter :: rook1_mask_",&
            & I0, "x", I0, "_", I0, " = int (z''", Z0.32, "'', kind &
            &= ", A, ")")') trim (s_kindnxn (n)), n, n, i,&
            & rook1_masks(i), trim (s_kindnxn (n))
    end do
    write (*, '()')
  end subroutine write_rook1_masks

  subroutine write_rook2_masks
    integer :: i

    call fill_masks (n)
    do i = 0, n - 1
       write (*, '("  integer(kind = ", A, "), parameter :: rook2_mask_",&
            & I0, "x", I0, "_", I0, " = int (z''", Z0.32, "'', kind &
            &= ", A, ")")') trim (s_kindnxn (n)), n, n, i,&
            & rook2_masks(i), trim (s_kindnxn (n))
    end do
    write (*, '()')
  end subroutine write_rook2_masks

  subroutine write_bishop1_masks
    integer :: i

    call fill_masks (n)
    do i = 0, (2 * n) - 4
       write (*, '("  integer(kind = ", A, "), parameter :: bishop1_mask_",&
            & I0, "x", I0, "_", I0, " = int (z''", Z0.32, "'', kind &
            &= ", A, ")")') trim (s_kindnxn (n)), n, n, i,&
            & bishop1_masks(i), trim (s_kindnxn (n))
    end do
    write (*, '()')
  end subroutine write_bishop1_masks

  subroutine write_bishop2_masks
    integer :: i

    call fill_masks (n)
    do i = 0, (2 * n) - 4
       write (*, '("  integer(kind = ", A, "), parameter :: bishop2_mask_",&
            & I0, "x", I0, "_", I0, " = int (z''", Z0.32, "'', kind &
            &= ", A, ")")') trim (s_kindnxn (n)), n, n, i,&
            & bishop2_masks(i), trim (s_kindnxn (n))
    end do
    write (*, '()')
  end subroutine write_bishop2_masks

  subroutine write_rook_masks
    integer :: i

    call fill_masks (n)
    do i = 0, (2 * n) - 1
       write (*, '("  integer(kind = ", A, "), parameter :: rook_mask_",&
            & I0, "x", I0, "_", I0, " = int (z''", Z0.32, "'', kind &
            &= ", A, ")")') trim (s_kindnxn (n)), n, n, i,&
            & rook_masks(i), trim (s_kindnxn (n))
    end do
    write (*, '()')
  end subroutine write_rook_masks

  subroutine write_bishop_masks
    integer :: i

    call fill_masks (n)
    do i = 0, (4 * n) - 7
       write (*, '("  integer(kind = ", A, "), parameter :: bishop_mask_",&
            & I0, "x", I0, "_", I0, " = int (z''", Z0.32, "'', kind &
            &= ", A, ")")') trim (s_kindnxn (n)), n, n, i,&
            & bishop_masks(i), trim (s_kindnxn (n))
    end do
    write (*, '()')
  end subroutine write_bishop_masks

  subroutine write_queen_masks
    integer :: i

    call fill_masks (n)
    do i = 0, (6 * n) - 7
       write (*, '("  integer(kind = ", A, "), parameter :: queen_mask_",&
            & I0, "x", I0, "_", I0, " = int (z''", Z0.32, "'', kind &
            &= ", A, ")")') trim (s_kindnxn (n)), n, n, i,&
            & queen_masks(i), trim (s_kindnxn (n))
    end do
    write (*, '()')
  end subroutine write_queen_masks

  subroutine write_rooks1_attack_check
    integer :: i

    write (*, '("  elemental function rooks1_attack_check (army1, army2) result (attacking)")')
    write (*, '("    integer(kind = ", A, "), value :: army1, army2")') trim (s_kindnxn (n))
    write (*, '("    logical :: attacking")')
    write (*, '()')
    write (*, '("    attacking = ((iand (army1, rook1_mask_", I0, "x", I0,&
         & "_0) /= 0) .and. (iand (army2, rook1_mask_", I0, "x", I0, "_0) /=&
         & 0)) .or. &")') n, n, n, n
    do i = 1, n - 1
       write (*, '("              & ((iand (army1, rook1_mask_", I0, "x",&
            & I0, "_", I0, ") /= 0) .and. (iand (army2, rook1_mask_", I0,&
            & "x", I0, "_", I0, ") /= 0))")', advance = 'no') n, n, i, n, n, i
       if (i /= n - 1) then
          write (*, '(" .or. &")')
       else
          write (*, '()')
       end if
    end do
    write (*, '("  end function rooks1_attack_check")')
    write (*, '()')
  end subroutine write_rooks1_attack_check

  subroutine write_rooks2_attack_check
    integer :: i

    write (*, '("  elemental function rooks2_attack_check (army1, army2) result (attacking)")')
    write (*, '("    integer(kind = ", A, "), value :: army1, army2")') trim (s_kindnxn (n))
    write (*, '("    logical :: attacking")')
    write (*, '()')
    write (*, '("    attacking = ((iand (army1, rook2_mask_", I0, "x", I0,&
         & "_0) /= 0) .and. (iand (army2, rook2_mask_", I0, "x", I0, "_0) /=&
         & 0)) .or. &")') n, n, n, n
    do i = 1, n - 1
       write (*, '("              & ((iand (army1, rook2_mask_", I0, "x",&
            & I0, "_", I0, ") /= 0) .and. (iand (army2, rook2_mask_", I0,&
            & "x", I0, "_", I0, ") /= 0))")', advance = 'no') n, n, i, n, n, i
       if (i /= n - 1) then
          write (*, '(" .or. &")')
       else
          write (*, '()')
       end if
    end do
    write (*, '("  end function rooks2_attack_check")')
    write (*, '()')
  end subroutine write_rooks2_attack_check

  subroutine write_bishops1_attack_check
    integer :: i

    write (*, '("  elemental function bishops1_attack_check (army1, army2) result (attacking)")')
    write (*, '("    integer(kind = ", A, "), value :: army1, army2")') trim (s_kindnxn (n))
    write (*, '("    logical :: attacking")')
    write (*, '()')
    write (*, '("    attacking = ((iand (army1, bishop1_mask_", I0, "x", I0,&
         & "_0) /= 0) .and. (iand (army2, bishop1_mask_", I0, "x", I0, "_0) /=&
         & 0)) .or. &")') n, n, n, n
    do i = 1, (2 * n) - 4
       write (*, '("              & ((iand (army1, bishop1_mask_", I0, "x",&
            & I0, "_", I0, ") /= 0) .and. (iand (army2, bishop1_mask_", I0,&
            & "x", I0, "_", I0, ") /= 0))")', advance = 'no') n, n, i, n, n, i
       if (i /= (2 * n) - 4) then
          write (*, '(" .or. &")')
       else
          write (*, '()')
       end if
    end do
    write (*, '("  end function bishops1_attack_check")')
    write (*, '()')
  end subroutine write_bishops1_attack_check

  subroutine write_bishops2_attack_check
    integer :: i

    write (*, '("  elemental function bishops2_attack_check (army1, army2) result (attacking)")')
    write (*, '("    integer(kind = ", A, "), value :: army1, army2")') trim (s_kindnxn (n))
    write (*, '("    logical :: attacking")')
    write (*, '()')
    write (*, '("    attacking = ((iand (army1, bishop2_mask_", I0, "x", I0,&
         & "_0) /= 0) .and. (iand (army2, bishop2_mask_", I0, "x", I0, "_0) /=&
         & 0)) .or. &")') n, n, n, n
    do i = 1, (2 * n) - 4
       write (*, '("              & ((iand (army1, bishop2_mask_", I0, "x",&
            & I0, "_", I0, ") /= 0) .and. (iand (army2, bishop2_mask_", I0,&
            & "x", I0, "_", I0, ") /= 0))")', advance = 'no') n, n, i, n, n, i
       if (i /= (2 * n) - 4) then
          write (*, '(" .or. &")')
       else
          write (*, '()')
       end if
    end do
    write (*, '("  end function bishops2_attack_check")')
    write (*, '()')
  end subroutine write_bishops2_attack_check

  subroutine write_rooks_attack_check
    integer :: i

    write (*, '("  elemental function rooks_attack_check (army1, army2) result (attacking)")')
    write (*, '("    integer(kind = ", A, "), value :: army1, army2")') trim (s_kindnxn (n))
    write (*, '("    logical :: attacking")')
    write (*, '()')
    write (*, '("    attacking = ((iand (army1, rook_mask_", I0, "x", I0,&
         & "_0) /= 0) .and. (iand (army2, rook_mask_", I0, "x", I0, "_0) /=&
         & 0)) .or. &")') n, n, n, n
    do i = 1, (2 * n) - 1
       write (*, '("              & ((iand (army1, rook_mask_", I0, "x",&
            & I0, "_", I0, ") /= 0) .and. (iand (army2, rook_mask_", I0,&
            & "x", I0, "_", I0, ") /= 0))")', advance = 'no') n, n, i, n, n, i
       if (i /= (2 * n) - 1) then
          write (*, '(" .or. &")')
       else
          write (*, '()')
       end if
    end do
    write (*, '("  end function rooks_attack_check")')
    write (*, '()')
  end subroutine write_rooks_attack_check

  subroutine write_bishops_attack_check
    integer :: i

    write (*, '("  elemental function bishops_attack_check (army1, army2) result (attacking)")')
    write (*, '("    integer(kind = ", A, "), value :: army1, army2")') trim (s_kindnxn (n))
    write (*, '("    logical :: attacking")')
    write (*, '()')
    write (*, '("    attacking = ((iand (army1, bishop_mask_", I0, "x", I0,&
         & "_0) /= 0) .and. (iand (army2, bishop_mask_", I0, "x", I0, "_0) /=&
         & 0)) .or. &")') n, n, n, n
    do i = 1, (4 * n) - 7
       write (*, '("              & ((iand (army1, bishop_mask_", I0, "x",&
            & I0, "_", I0, ") /= 0) .and. (iand (army2, bishop_mask_", I0,&
            & "x", I0, "_", I0, ") /= 0))")', advance = 'no') n, n, i, n, n, i
       if (i /= (4 * n) - 7) then
          write (*, '(" .or. &")')
       else
          write (*, '()')
       end if
    end do
    write (*, '("  end function bishops_attack_check")')
    write (*, '()')
  end subroutine write_bishops_attack_check

  subroutine write_queens_attack_check
    integer :: i

    write (*, '("  elemental function queens_attack_check (army1, army2) result (attacking)")')
    write (*, '("    integer(kind = ", A, "), value :: army1, army2")') trim (s_kindnxn (n))
    write (*, '("    logical :: attacking")')
    write (*, '()')
    write (*, '("    attacking = ((iand (army1, queen_mask_", I0, "x", I0,&
         & "_0) /= 0) .and. (iand (army2, queen_mask_", I0, "x", I0, "_0) /=&
         & 0)) .or. &")') n, n, n, n
    do i = 1, (6 * n) - 7
       write (*, '("              & ((iand (army1, queen_mask_", I0, "x",&
            & I0, "_", I0, ") /= 0) .and. (iand (army2, queen_mask_", I0,&
            & "x", I0, "_", I0, ") /= 0))")', advance = 'no') n, n, i, n, n, i
       if (i /= (6 * n) - 7) then
          write (*, '(" .or. &")')
       else
          write (*, '()')
       end if
    end do
    write (*, '("  end function queens_attack_check")')
    write (*, '()')
  end subroutine write_queens_attack_check

  subroutine write_board_rotate90
    integer :: i, j

    write (*, '("  elemental function board_rotate90 (a) result (b)")')
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    write (*, '("    ! Rotation 90 degrees in one of the orientations.")')
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("  ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (reverse_insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, "), &")') n, n, n, i, -i * n, i
       else
          write (*, '("   ishft (reverse_insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, ")")', advance = 'no') n, n, n, i, -i * n, i
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function board_rotate90")')
    write (*, '()')
  end subroutine write_board_rotate90

  subroutine write_board_rotate180
    write (*, '("  elemental function board_rotate180 (a) result (b)")')
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    write (*, '("    ! Rotation 180 degrees.")')
    write (*, '()')
    write (*, '("    b = board_reflect1 (board_reflect2 (a))")')
    write (*, '("  end function board_rotate180")')
    write (*, '()')
  end subroutine write_board_rotate180

  subroutine write_board_rotate270
    integer :: i, j

    write (*, '("  elemental function board_rotate270 (a) result (b)")')
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    write (*, '("    ! Rotation 270 degrees in one of the orientations.")')
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("  ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, "), &")') n, n, n, i, -i * n, n - 1 - i
       else
          write (*, '("   ishft (insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, ")")', advance = 'no') n, n, n, i, -i * n, n - 1 - i
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function board_rotate270")')
    write (*, '()')
  end subroutine write_board_rotate270

  subroutine write_board_reflect1
    integer :: i, j

    write (*, '("  elemental function board_reflect1 (a) result (b)")')
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    write (*, '("    ! Reflection of rows or columns.")')
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("     ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (iand (rook2_mask_", I0, "x", I0, "_", I0, ", a), ", I0, "), &")') &
               & n, n, i, (n - 1) - (2 * i)
       else
          write (*, '("ishft (iand (rook2_mask_", I0, "x", I0, "_", I0, ", a), ", I0, ")")', advance = 'no') &
               & n, n, i, (n - 1) - (2 * i)
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function board_reflect1")')
    write (*, '()')
  end subroutine write_board_reflect1

  subroutine write_board_reflect2
    integer :: i, j

    write (*, '("  elemental function board_reflect2 (a) result (b)")')
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    write (*, '("    ! Reflection of rows or columns.")')
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("     ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ", I0, "), &")') &
               & n, n, i, n * ((n - 1) - (2 * i))
       else
          write (*, '("ishft (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ", I0, ")")', advance = 'no') &
               & n, n, i, n * ((n - 1) - (2 * i))
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function board_reflect2")')
    write (*, '()')
  end subroutine write_board_reflect2

  subroutine write_board_reflect3
    integer :: i, j

    write (*, '("  elemental function board_reflect3 (a) result (b)")')
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    write (*, '("    ! Reflection around one of the two main diagonals.")')
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("  ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, "), &")') n, n, n, i, -i * n, i
       else
          write (*, '("   ishft (insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, ")")', advance = 'no') n, n, n, i, -i * n, i
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function board_reflect3")')
    write (*, '()')
  end subroutine write_board_reflect3

  subroutine write_board_reflect4
    integer :: i, j

    write (*, '("  elemental function board_reflect4 (a) result (b)")')
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    write (*, '("    ! Reflection around one of the two main diagonals.")')
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("  ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (reverse_insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, "), &")') n, n, n, i, -i * n, n - 1 - i
       else
          write (*, '("   ishft (reverse_insert_zeros_", I0, " (ishft&
               & (iand (rook1_mask_", I0, "x", I0, "_", I0, ", a), ",&
               & I0, ")), ", I0, ")")', advance = 'no') n, n, n, i, -i * n, n - 1 - i
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function board_reflect4")')
    write (*, '()')
  end subroutine write_board_reflect4

  subroutine write_insert_zeros
    integer :: i, j

    write (*, '("  elemental function insert_zeros_", I0, " (a) result (b)")') n
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("     ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (ibits (a, ", I0, ", 1), ", I0, "), &")') i, i * n
       else
          write (*, '("ishft (ibits (a, ", I0, ", 1), ", I0, ")")', advance = 'no') i, i * n
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function insert_zeros_", I0)') n
    write (*, '()')
  end subroutine write_insert_zeros

  subroutine write_reverse_insert_zeros
    integer :: i, j

    write (*, '("  elemental function reverse_insert_zeros_", I0, " (a) result (b)")') n
    write (*, '("    integer(kind = ", A, "), value :: a")') trim (s_kindnxn (n))
    write (*, '("    integer(kind = ", A, ") :: b")') trim (s_kindnxn (n))
    write (*, '()')
    do i = 0, n - 1
       if (i == 0) then
          write (*, '("    b = ")', advance = 'no')
       else
          write (*, '("      & ")', advance = 'no')
          do j = 1, i
             write (*, '("     ")', advance = 'no')
          end do
       end if
       if (i /= n - 1) then
          write (*, '("ior (ishft (ibits (a, ", I0, ", 1), ", I0, "), &")') n - 1 - i, i * n
       else
          write (*, '("ishft (ibits (a, ", I0, ", 1), ", I0, ")")', advance = 'no') n - 1 - i, i * n
          do j = 1, n - 1
             write (*, '(")")', advance = 'no')
          end do
          write (*, '()')
       end if
    end do
    write (*, '("  end function reverse_insert_zeros_", I0)') n
    write (*, '()')
  end subroutine write_reverse_insert_zeros

  function s_kindnxn (n) result (s)
    integer, intent(in) :: n
    character(len = 16) :: s

    if (n <= 8) then
       s = s_kind8x8
    else
       s = s_kind11x11
    end if
  end function s_kindnxn

  subroutine fill_masks (n)
    integer, intent(in) :: n

    call fill_rook1_masks (n)
    call fill_rook2_masks (n)
    call fill_bishop1_masks (n)
    call fill_bishop2_masks (n)
    call fill_rook_masks (n)
    call fill_bishop_masks (n)
    call fill_queen_masks (n)
  end subroutine fill_masks

  subroutine fill_rook1_masks (n)
    integer, intent(in) :: n

    integer :: i
    integer(kind = kind11x11) :: mask

    mask = (two ** n) - 1
    do i = 0, n - 1
       rook1_masks(i) = mask
       mask = ishft (mask, n)
    end do
  end subroutine fill_rook1_masks

  subroutine fill_rook2_masks (n)
    integer, intent(in) :: n

    integer :: i
    integer(kind = kind11x11) :: mask

    mask = 0
    do i = 0, n - 1
       mask = ior (ishft (mask, n), one)
    end do
    do i = 0, n - 1
       rook2_masks(i) = mask
       mask = ishft (mask, 1)
    end do
  end subroutine fill_rook2_masks

  subroutine fill_bishop1_masks (n)
    integer, intent(in) :: n

    integer :: i, j, k
    integer(kind = kind11x11) :: mask0, mask1

    ! Masks for diagonals. Put them in order from most densely
    ! populated to least densely populated.

    do k = 0, n - 2
       mask0 = 0
       mask1 = 0
       do i = k, n - 1
          j = i - k
          mask0 = ior (mask0, ishft (one, i + (j * n)))
          mask1 = ior (mask1, ishft (one, j + (i * n)))
       end do
       if (k == 0) then
          bishop1_masks(0) = mask0
       else
          bishop1_masks((2 * k) - 1) = mask0
          bishop1_masks(2 * k) = mask1
       end if
    end do
  end subroutine fill_bishop1_masks

  subroutine fill_bishop2_masks (n)
    integer, intent(in) :: n

    integer :: i, j, k
    integer :: i1, j1
    integer(kind = kind11x11) :: mask0, mask1

    ! Masks for skew diagonals. Put them in order from most densely
    ! populated to least densely populated.

    do k = 0, n - 2
       mask0 = 0
       mask1 = 0
       do i = k, n - 1
          j = i - k
          i1 = n - 1 - i
          j1 = n - 1 - j
          mask0 = ior (mask0, ishft (one, j + (i1 * n)))
          mask1 = ior (mask1, ishft (one, i + (j1 * n)))
       end do
       if (k == 0) then
          bishop2_masks(0) = mask0
       else
          bishop2_masks((2 * k) - 1) = mask0
          bishop2_masks(2 * k) = mask1
       end if
    end do
  end subroutine fill_bishop2_masks

  subroutine fill_rook_masks (n)
    integer, intent(in) :: n

    rook_masks(0 : n - 1) = rook1_masks
    rook_masks(n : (2 * n) - 1) = rook2_masks
  end subroutine fill_rook_masks

  subroutine fill_bishop_masks (n)
    integer, intent(in) :: n

    integer :: i

    ! Put the masks in order from most densely populated to least
    ! densely populated.

    do i = 0, (2 * n) - 4
       bishop_masks(2 * i) = bishop1_masks(i)
       bishop_masks((2 * i) + 1) = bishop2_masks(i)
    end do
  end subroutine fill_bishop_masks

  subroutine fill_queen_masks (n)
    integer, intent(in) :: n

    queen_masks(0 : (2 * n) - 1) = rook_masks
    queen_masks(2 * n : (6 * n) - 7) = bishop_masks
  end subroutine fill_queen_masks

end program peaceful_queens_elements_generator
