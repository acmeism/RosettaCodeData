! As was already pointed out, Fortran has intrinsic functions that
! should compile to efficient code, such as a single machine
! instruction. But it seems profitable to have written implementations
! according to the task description.

! Here, by the way, is a page devoted to the topic of finding the LS1B
! and MS1B positions:
! https://www.chessprogramming.org/index.php?title=BitScan&oldid=22495#With_separated_LS1B

! I am uncertain what the "lwb" and "upb" are supposed to mean, but I
! imagine it is to isolate the bit. I do this below using
! bit-twiddling methods, *before* doing binary searches to find the
! positions of the bits.

module bit_thingies_for_rosetta_code

  ! INT64 is the largest integer kind standardized in ISO_FORTRAN_ENV,
  ! although 128-bit integers are available with gfortran on AMD64. I
  ! shall stick with INT64; the principles do not differ.
  use, intrinsic :: iso_fortran_env, only: int64

  implicit none

  integer(kind = int64), parameter :: most_negative = ishft (1_int64, 63)

  integer(kind = int64), parameter :: mask1 = &
       & int (b'1010101010101010101010101010101010101010101010101010101010101010', &
       &      kind = int64)
  integer(kind = int64), parameter :: mask2 = &
       & int (b'1100110011001100110011001100110011001100110011001100110011001100', &
       &      kind = int64)
  integer(kind = int64), parameter :: mask3 = &
       & int (b'1111000011110000111100001111000011110000111100001111000011110000', &
       &      kind = int64)
  integer(kind = int64), parameter :: mask4 = &
       & int (b'1111111100000000111111110000000011111111000000001111111100000000', &
       &      kind = int64)
  integer(kind = int64), parameter :: mask5 = &
       & int (b'1111111111111111000000000000000011111111111111110000000000000000', &
       &      kind = int64)
  integer(kind = int64), parameter :: mask6 = &
       & int (b'1111111111111111111111111111111100000000000000000000000000000000', &
       &      kind = int64)

contains

  ! LS1B-position by binary search. This method is MUCH improved by
  ! first isolating the least significant 1-bit, so I do that. This
  ! action makes the masks more effective.
  elemental function rlwb (n) result (i)
    integer(kind = int64), value :: n
    integer :: i

    if (n == most_negative) then
       !
       ! With the most negative two's complement number, one cannot
       ! trust Fortran to do arithmetic as one intends. Thus this
       ! branch. (There would be no such problem with *unsigned*
       ! integers in C; these are required by the standard to overflow
       ! and underflow freely.)
       !
       ! If you take into account the task's restriction to positive
       ! integers, then of course this case never occurs, and you can
       ! leave out the branch.
       !
       i = 63
    else
       ! Isolate the least significant 1-bit. This method is specific
       ! for two's complement. Your platform is very unlikely not to
       ! be two's complement.
       n = iand (n, -n)

       i = 0_int64
       if (iand (n, not (mask6)) == 0) i = 32_int64
       if (iand (n, not (mask5)) == 0) i = i + 16_int64
       if (iand (n, not (mask4)) == 0) i = i + 8_int64
       if (iand (n, not (mask3)) == 0) i = i + 4_int64
       if (iand (n, not (mask2)) == 0) i = i + 2_int64
       if (iand (n, not (mask1)) == 0) i = i + 1_int64
    end if
  end function rlwb

  ! MS1B-position by binary search. This method is MUCH improved by
  ! first isolating the most significant 1-bit, so I do that. This
  ! action makes the masks more effective.
  elemental function rupb (n) result (i)
    integer(kind = int64), value :: n
    integer :: i

    if (ibits (n, 63, 1) /= 0) then
       ! The task restricts itself to positive integers, but I shall
       ! do a branch for negative numbers.
       i = 0_int64
    else if (ibits (n, 62, 1) /= 0) then
       ! Also, in Fortran one cannot safely add one to every 63-bit
       ! number, so another special branch.
       i = 1_int64
    else
       ! Fill all bits to the right of the MS1B.
       n = ior (n, ishft (n, -1))
       n = ior (n, ishft (n, -2))
       n = ior (n, ishft (n, -4))
       n = ior (n, ishft (n, -8))
       n = ior (n, ishft (n, -16))
       n = ior (n, ishft (n, -32))

       ! Isolate the most significant 1-bit.
       n = ishft (n + 1, -1)

       i = 0_int64
       if (iand (n, mask6) /= 0) i = 32_int64
       if (iand (n, mask5) /= 0) i = i + 16_int64
       if (iand (n, mask4) /= 0) i = i + 8_int64
       if (iand (n, mask3) /= 0) i = i + 4_int64
       if (iand (n, mask2) /= 0) i = i + 2_int64
       if (iand (n, mask1) /= 0) i = i + 1_int64
    end if
  end function rupb

end module bit_thingies_for_rosetta_code

program find_set_bits
  use, intrinsic :: iso_fortran_env, only: int64
  use, non_intrinsic :: bit_thingies_for_rosetta_code
  implicit none

  integer :: i
  integer(kind = int64) :: n

  write (*, '(A70)') "Using intrinsic functions TRAILZ and LEADZ"
  n = 1_int64
  do i = 0, 11
     write (*, '(B0.64, 2(" ", I2))') n, trailz (n), 63 - leadz (n)
     n = 42_int64 * n
  end do

  write (*, '()')

  write (*, '(A70)') "Using binary search"
  n = 1_int64
  do i = 0, 11
     write (*, '(B0.64, 2(" ", I2))') n, rlwb (n), rupb (n)
     n = 42_int64 * n
  end do

end program find_set_bits
