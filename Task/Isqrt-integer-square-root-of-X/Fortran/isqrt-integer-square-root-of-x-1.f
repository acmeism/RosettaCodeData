! ==============================================================================
! Module : integer_square_root
! Purpose: Exact integer square root and comma-formatted printing for 128-bit
!          signed integers (integer(kind=16), range -2^127 .. 2^127-1).
!
! Public procedures:
!   isqrt(num)      -- returns floor(sqrt(num)) for num >= 0; O(log4 n)
!   commatize(num)  -- formats num as a comma-separated decimal string
! ==============================================================================
module integer_square_root
   implicit none

contains

   ! ===========================================================================
   ! commatize(num)
   !
   ! Formats a 128-bit integer as a decimal string with comma separators
   ! every three digits, e.g. 1234567 -> "1,234,567".
   !
   ! Method: write to a scratch buffer with I0 (no leading spaces), then
   ! rebuild right-to-left, prepending a comma whenever the digit count
   ! is a non-zero multiple of 3 and we are not yet at the leftmost digit.
   !
   ! Output width 83 comfortably holds any int128 value: the maximum
   ! 2^127-1 ~ 1.70e38 has 39 digits + 12 commas = 51 characters.
   ! The loop variable is a default integer -- no need for int128 here since
   ! it only counts character positions (0..82 at most).
   ! ===========================================================================
   function commatize(num) result(out_str)
      integer(kind=16), intent(in) :: num
      character(83) :: temp, out_str
      integer :: i           ! digit position counter; default int is sufficient

      write(temp, '(I0)') num

      out_str = ""

      do i = 0, len_trim(temp) - 1
         if (mod(i, 3) == 0 .and. i > 0 .and. i < len_trim(temp)) then
            out_str = "," // trim(out_str)
         end if
         out_str = temp(len_trim(temp) - i : len_trim(temp) - i) // trim(out_str)
      end do
   end function commatize

   ! ===========================================================================
   ! isqrt(num)
   !
   ! Returns floor(sqrt(num)) for num >= 0 using the binary digit-by-digit
   ! method (base-4 variant).  All arithmetic is exact integer; no floating
   ! point is involved so the result is always correct to the last bit.
   !
   ! Algorithm -- digit-by-digit base-4 square root:
   !   q  : current place value (a descending power of 4)
   !   r  : result accumulated so far (floor(sqrt) of the digits seen)
   !   z  : residual of num not yet accounted for
   !   t  : trial remainder if the current base-4 digit were set to 1
   !
   !   Each iteration tests whether setting the next digit to 1 keeps the
   !   residual non-negative.  If yes, digit = 1: update z and add q to r.
   !   If no, digit = 0: leave z unchanged.  Then shift r right by 1 bit
   !   (halve r, making room for the current digit) and shift q right by 2
   !   bits (divide by 4, moving to the next lower place value).
   !   After processing q = 1 (the units digit), r = floor(sqrt(num)).
   !
   !   Running time: O(log4 n), approx 64 iterations for 128-bit input.
   !
   ! Overflow bug in original initialisation loop (now fixed):
   !   Original: `do while (q <= num); q = q * 4; end do`
   !   For num >= 4^63 = 2^126, the loop eventually computes q = 2^126 * 4
   !   = 2^128, which overflows 128-bit signed arithmetic.  The wrapped
   !   result is negative; since negative < positive num the condition stays
   !   true and the loop runs forever.  This caused a hang for any input
   !   >= 2^126 -- including 7^45 (approx 2^126.3) in the demo program.
   !
   ! Fix -- overflow-safe initialisation:
   !   `do while (q <= num/4); q = shiftl(q, 2); end do`
   !   The condition q <= num/4 means q*4 <= num before multiplication,
   !   so shiftl(q,2) [i.e. q*4] can never exceed num (which fits in int128).
   !   No overflow is possible.  This loop finds the LARGEST power of 4 not
   !   exceeding num.  The main loop processes q directly (rather than
   !   starting with q/4 as the original did), which is equivalent.
   ! ===========================================================================
   function isqrt(num)
      integer(kind=16), intent(in) :: num
      integer(kind=16) :: isqrt
      integer(kind=16) :: q, z, r, t

      ! sqrt is not defined for negative inputs; return 0 as a safe default
      if (num <= 0_16) then
         isqrt = 0_16
         return
      end if

      ! Find the largest power of 4 not exceeding num.
      ! Because q <= num/4 implies q*4 <= num, shiftl(q,2) inside the loop
      ! never overflows regardless of how large num is.
      q = 1_16
      do while (q <= num / 4)
         q = shiftl(q, 2)      ! q = q * 4; safe: q*4 <= num, no overflow
      end do
      ! Post-condition: q = 4^k is the largest power of 4 with q <= num.

      z = num
      r = 0_16

      ! Process base-4 digits from the highest place value down to 1.
      do
         t = z - r - q     ! would accepting digit 1 keep the residual >= 0?
         r = shiftr(r, 1)  ! r = r / 2; make room for the current digit in r
         if (t >= 0_16) then
            z = t           ! accept digit 1: residual reduces to t
            r = r + q       ! record digit 1 at the current place value
         end if
         if (q == 1_16) exit   ! all digits processed; r holds floor(sqrt(num))
         q = shiftr(q, 2)  ! q = q / 4; descend to the next lower place value
      end do

      isqrt = r
   end function isqrt

end module integer_square_root

! ==============================================================================
! Program : isqrt_demo
! Purpose : Demonstrates isqrt on two test sets:
!   1. Integers 1..65  -- spot-check the well-known pattern 1,1,1,2,2,2,2,2,3,...
!   2. Odd powers of 7 from 7^1 to 7^45 -- exercises large 128-bit inputs.
!
! Safe upper limit for base-7 test:
!   log2(7) approx 2.807, so 7^n occupies approx 2.807n bits.
!   7^45 approx 2^126.3 < 2^127-1  ->  fits in int128, isqrt works correctly.
!   7^47 approx 2^131.9 > 2^127-1  ->  overflows int128 (undefined behaviour).
!   With step 2 from power_min=1, the loop reaches 45 when power_max=46,
!   so power_max=46 is the correct safe ceiling.
!
! Note: the original power_max was 73 and the original isqrt had an overflow
! bug in its initialisation loop that caused an infinite loop for any input
! >= 2^126 -- which includes 7^45.  Both issues are now fixed.
! ==============================================================================
program isqrt_demo
   use integer_square_root
   implicit none

   integer(kind=16), parameter :: min_num_hz = 0
   integer(kind=16), parameter :: max_num_hz = 65
   integer(kind=16), parameter :: power_base = 7
   integer(kind=16), parameter :: power_min = 1
   integer(kind=16), parameter :: power_max = 46
   integer(kind=16), dimension(max_num_hz - min_num_hz + 1) :: values
   character(2) :: header_1
   character(83) :: header_2
   character(83) :: header_3

   integer(kind=16) :: i

   header_1 = " n"
   header_2 = "7^n"
   header_3 = "isqrt(7^n)"

   write(*, '(A, I0, A, I0)') "Integer square root for numbers ", min_num_hz, " to ", max_num_hz

   do i = 1, size(values)
      values(i) = isqrt(min_num_hz + i)
   end do

   write(*, '(100I2)') values
   write(*, *) new_line('A')

   write(*, '(A,A,A,A,A)') header_1, " | ", header_2, " | ", header_3
   write(*, *) repeat("-", 8 + 83 * 2)

   do i = power_min, power_max, 2
      write(*, '(I2, A, A, A, A)') i, " | " // commatize(7**i), " | ", commatize(isqrt(7**i))
   end do


end program isqrt_demo
