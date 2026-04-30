! =================== or... we can cheat =========================================
! ==============================================================================
! Program : isqrt_real  (Rosetta Code task: Integer square root integer)
!
! Strategy:
!   isqrt column -- quad-precision reals (real(kind=16), ~34 decimal digits).
!                   isqrt(7^73) has 31 digits; quad has 34 -- fits with room.
!   7^n   column -- exact decimal digit array (base-10 "big integer").
!                   Multiply [1] by 7 n times; 7^73 needs at most 62 digits.
!
! Digit extraction for isqrt:
!   The result x is an exact integer in quad (< 10^31 < 2^113).  mod(x,10)
!   gives the exact last digit; subtract and divide by 10 (exact for integers
!   divisible by 10 in IEEE 754); prepend the digit character; repeat.
! ==============================================================================
program isqrt_real
   implicit none
   integer, parameter :: qp = 16    ! quad precision: ~34 decimal digits

   integer  :: n, digit, slen, i
   real(qp) :: x, y, d
   character(90) :: raw, out, s7n

   ! --------------------------------------------------------------------------
   ! Part 1: isqrt of integers 0..65, all values on one horizontal line
   ! --------------------------------------------------------------------------
   write(*, '(A)') "isqrt of integers 0 to 65:"
   do n = 0, 65
      write(*, '(I2)', advance='no') int(aint(sqrt(real(n, qp))))
   end do
   write(*, *)
   write(*, *)

   ! --------------------------------------------------------------------------
   ! Part 2: isqrt of odd powers of 7, one per line, with comma formatting
   ! 7^n column is right-justified in 82 chars (max: 7^73 = 62 digits + 20 commas)
   ! --------------------------------------------------------------------------
   write(*, '(A3, A, A82, A, A)') "  n", " | ", "7^n", " | ", "isqrt(7^n)"
   write(*, '(A)') repeat("-", 3 + 3 + 82 + 3 + 35)

   do n = 1, 73, 2

      ! --- exact decimal string for 7^n via base-10 digit array -------------
      s7n = pow7_str(n)

      ! --- isqrt(7^n) via quad sqrt, digits extracted one at a time ---------
      x   = aint(sqrt(7.0_qp**n))
      y   = x
      raw = ""
      if (y < 0.5_qp) then
         raw = "0"
      else
         do while (y >= 0.5_qp)
            d     = mod(y, 10.0_qp)
            digit = int(d + 0.5_qp)
            raw   = achar(48 + digit) // trim(raw)
            y     = (y - real(digit, qp)) / 10.0_qp
         end do
      end if
      ! insert commas in isqrt result
      slen = len_trim(raw)
      out  = ""
      do i = 0, slen - 1
         if (mod(i, 3) == 0 .and. i > 0) out = "," // trim(out)
         out = raw(slen - i : slen - i) // trim(out)
      end do

      ! right-justify 7^n in an 82-char field
      slen = len_trim(s7n)
      write(*, '(I3, A, A82, A, A)') &
         n, " | ", repeat(' ', 82 - slen) // s7n(1:slen), " | ", trim(out)
   end do

contains

   ! --------------------------------------------------------------------------
   ! pow7_str(n) -- returns exact decimal string of 7^n with comma separators
   !
   ! Method: maintain an array of decimal digits (index 1 = least significant).
   ! Multiply the whole array by 7 in n passes, propagating the carry.
   ! 7^73 has ceil(73 * log10(7)) = 62 digits, so 100 elements is ample.
   ! --------------------------------------------------------------------------
   function pow7_str(n) result(out)
      integer, intent(in)  :: n
      character(90)        :: out
      integer :: digs(100), nd, carry, i, j, slen
      character(90) :: raw

      digs = 0
      digs(1) = 1
      nd = 1

      do i = 1, n
         carry = 0
         do j = 1, nd
            carry   = digs(j) * 7 + carry
            digs(j) = mod(carry, 10)
            carry   = carry / 10
         end do
         do while (carry > 0)
            nd       = nd + 1
            digs(nd) = mod(carry, 10)
            carry    = carry / 10
         end do
      end do

      ! build raw string most-significant first
      raw = ""
      do i = nd, 1, -1
         raw = trim(raw) // achar(48 + digs(i))
      end do

      ! insert commas
      slen = len_trim(raw)
      out  = ""
      do i = 0, slen - 1
         if (mod(i, 3) == 0 .and. i > 0) out = "," // trim(out)
         out = raw(slen - i : slen - i) // trim(out)
      end do
   end function pow7_str

end program isqrt_real
