! =============================================================================
! metallic.f90  --  Metallic Ratios via Lucas-like sequences
!
! The b-th Metallic Ratio is the positive root of  x^2 - bx - 1 = 0,
! evaluated by the closed form  (b + sqrt(b^2 + 4)) / 2.
!
! It can also be approximated by the ratio of successive terms of the
! Lucas-like recurrence  x(n) = b*x(n-1) + x(n-2),  started at x(1)=x(2)=1.
! As n grows the ratio x(n+1)/x(n) converges to the b-th Metallic Ratio.
!
! This program:
!   - Generates and displays the first 15 terms for b = 0 .. 9
!   - Iterates the recurrence until the ratio stabilises to 32 decimal places
!   - Reports the converged value and the iteration count
!   - Stretch goal: repeats for b=1 (Golden Ratio) to 256 decimal places
!
! Because standard floating-point types top out at ~18 significant decimal
! digits, all ratio arithmetic is done in a hand-rolled arbitrary-precision
! integer module (bigint_mod).  The ratio a/b is extracted one decimal digit
! at a time by the long-division routine bg_div_dec.
!
! Compile:  gfortran -O2 -o metallic metallic.f90
! =============================================================================

! =============================================================================
! MODULE bigint_mod
!
! Minimal arbitrary-precision non-negative integer library.
!
! Representation
! --------------
! A big integer is stored as an array of "limbs"  a(1..na)  in base BB=10^9.
!   a(1)  holds the LEAST-significant 9 decimal digits.
!   a(na) holds the MOST-significant (possibly shorter) group.
! Only limbs a(1)..a(na) are active; a(na+1)..a(ML) are ignored (but are
! kept zeroed by all routines to avoid stale data causing wrong results).
!
! Why base 10^9?
!   Each limb is an int64 (range up to ~9.2e18).  During the multiply-by-10
!   inner loop we temporarily hold  a(i)*10 + carry  which is at most
!   (10^9 - 1)*10 + (10^9 - 1) = ~10^10, well within int64.  Using a power
!   of ten as the base also makes printing decimal digits straightforward.
!
! Public interface
! ----------------
!   bg_set      -- initialise a big-int from a small (< BB) integer
!   bg_copy     -- copy one big-int to another
!   bg_add      -- c = a + b
!   bg_mul_s    -- c = a * k  (k is a small ordinary integer, 0 <= k <= ~100)
!   bg_sub      -- c = a - b  (a >= b must hold)
!   bg_cmp      -- compare two big-ints, return +1/0/-1
!   bg_div_dec  -- divide a/b and return the result as a decimal string
!                  to an arbitrary number of places
! =============================================================================
module bigint_mod
   use iso_fortran_env, only: int64
   implicit none

   ! ML  : maximum number of limbs per big-int.
   !       ML=200 supports numbers with up to 200*9 = 1800 decimal digits,
   !       which is vastly more than the ~300 digits needed here.
   integer, parameter :: ml = 200

   ! BB  : the limb base.  Every limb satisfies  0 <= limb < BB.
   integer(kind=int64), parameter :: bb = 1000000000_int64  ! 10^9

contains

   ! ---------------------------------------------------------------------------
   ! bg_set(a, na, val)
   !
   ! Set the big-int  a  to the small non-negative value  val  (val < BB).
   ! All limbs are zeroed first to guarantee a clean state; then limb 1 is set
   ! to val and na is set to 1 (a single-limb number).
   ! ---------------------------------------------------------------------------
   subroutine bg_set(a, na, val)
      integer(kind=int64), intent(out) :: a(ml)   ! limb array to initialise
      integer,             intent(out) :: na       ! number of active limbs
      integer(kind=int64), intent(in)  :: val      ! value to store (< BB)

      a = 0_int64   ! zero every limb so no stale data remains
      a(1) = val    ! least-significant limb carries the whole value
      na = 1        ! exactly one active limb
   end subroutine bg_set

   ! ---------------------------------------------------------------------------
   ! bg_copy(src, ns, dst, nd)
   !
   ! Copy big-int src (with ns active limbs) into dst, setting nd = ns.
   ! A whole-array copy is used because ML is fixed at compile time; it is
   ! fast and ensures no stale limbs survive in dst beyond position ns.
   ! ---------------------------------------------------------------------------
   subroutine bg_copy(src, ns, dst, nd)
      integer(kind=int64), intent(in)  :: src(ml)  ! source big-int
      integer,             intent(in)  :: ns        ! active limbs in src
      integer(kind=int64), intent(out) :: dst(ml)  ! destination big-int
      integer,             intent(out) :: nd        ! active limbs in dst

      dst = src   ! copies all ML limbs (unused ones are already zero)
      nd  = ns
   end subroutine bg_copy

   ! ---------------------------------------------------------------------------
   ! bg_add(a, na, b, nb, c, nc)
   !
   ! c = a + b
   !
   ! Standard schoolbook addition, limb by limb from least significant to most.
   ! At each position we accumulate  carry + a(i) + b(i),  write the result mod
   ! BB into c(i), and pass floor(result/BB) as carry to the next position.
   ! We iterate up to max(na,nb)+1 limbs to catch any final carry overflow.
   ! After the loop the leading-zero trimmer keeps nc as small as possible.
   !
   ! NOTE: c must be a distinct array from both a and b (no aliasing).
   ! ---------------------------------------------------------------------------
   subroutine bg_add(a, na, b, nb, c, nc)
      integer(kind=int64), intent(in)  :: a(ml), b(ml)  ! operands
      integer,             intent(in)  :: na, nb          ! their active limbs
      integer(kind=int64), intent(out) :: c(ml)          ! result  c = a + b
      integer,             intent(out) :: nc              ! active limbs in c

      integer(kind=int64) :: carry   ! carry propagating upward through limbs
      integer :: i, nm

      nm = max(na, nb)   ! highest limb index that might be non-zero in a or b
      c = 0_int64
      carry = 0_int64

      do i = 1, nm + 1   ! +1 to absorb a possible carry out of the top limb
         c(i) = carry
         if (i <= na) c(i) = c(i) + a(i)   ! add a's contribution (if present)
         if (i <= nb) c(i) = c(i) + b(i)   ! add b's contribution (if present)
         carry   = c(i) / bb                ! extract carry for next limb
         c(i)    = mod(c(i), bb)            ! keep only the low BB part
      end do

      ! Set nc to the index of the highest non-zero limb (at least 1).
      nc = nm + 1
      do while (nc > 1 .and. c(nc) == 0_int64)
         nc = nc - 1
      end do
   end subroutine bg_add

   ! ---------------------------------------------------------------------------
   ! bg_mul_s(a, na, k, c, nc)
   !
   ! c = a * k,  where k is a small non-negative integer (0 <= k <= ~100).
   !
   ! Multiplies each limb by k, accumulating carries upward.  The product
   !   a(i)*k + carry_in
   ! fits comfortably in int64 because:
   !   a(i) < 10^9,  k <= 100,  carry_in < 100
   !   => max product ~= 10^9 * 100 + 100 = 10^11,  well within 2^63 - 1.
   !
   ! k=0 is handled specially (result is zero stored as a single zero limb).
   !
   ! NOTE: c must be a distinct array from a (no aliasing).
   ! ---------------------------------------------------------------------------
   subroutine bg_mul_s(a, na, k, c, nc)
      integer(kind=int64), intent(in)  :: a(ml)   ! multiplicand
      integer,             intent(in)  :: na, k   ! active limbs; small factor
      integer(kind=int64), intent(out) :: c(ml)   ! result  c = a * k
      integer,             intent(out) :: nc       ! active limbs in c

      integer(kind=int64) :: carry, kk   ! carry between limbs; k as int64
      integer :: i

      c = 0_int64

      ! Special case: multiplying by zero yields zero (single zero limb).
      if (k == 0) then
         nc = 1
         return
      end if

      kk    = int(k, int64)   ! widen k to int64 to avoid 32-bit overflow
      carry = 0_int64

      do i = 1, na
         c(i)  = a(i) * kk + carry   ! partial product plus incoming carry
         carry = c(i) / bb            ! carry for the next limb
         c(i)  = mod(c(i), bb)        ! store only the low BB part
      end do

      ! If there is a leftover carry it forms a new most-significant limb.
      if (carry > 0_int64) then
         nc      = na + 1
         c(nc)   = carry
      else
         nc = na
      end if
   end subroutine bg_mul_s

   ! ---------------------------------------------------------------------------
   ! bg_sub(a, na, b, nb, c, nc)
   !
   ! c = a - b   (caller must ensure a >= b; the result is always >= 0)
   !
   ! Standard schoolbook subtraction with borrow.  We work on a local copy
   ! `tmp` so that c may safely alias a (c and a may point to the same array).
   ! After subtraction the leading-zero trimmer reduces nc.
   ! ---------------------------------------------------------------------------
   subroutine bg_sub(a, na, b, nb, c, nc)
      integer(kind=int64), intent(in)  :: a(ml), b(ml)  ! a >= b required
      integer,             intent(in)  :: na, nb
      integer(kind=int64), intent(out) :: c(ml)         ! c = a - b
      integer,             intent(out) :: nc

      integer(kind=int64) :: borrow    ! borrow propagating upward (0 or 1)
      integer(kind=int64) :: tmp(ml)   ! local working copy so c may alias a
      integer :: i

      tmp    = a            ! copy a into tmp so we can safely write into c
      borrow = 0_int64

      do i = 1, na
         tmp(i) = tmp(i) - borrow            ! subtract any borrow from above
         if (i <= nb) tmp(i) = tmp(i) - b(i) ! subtract b's limb (if present)
         ! If the result went negative, borrow from the next higher limb.
         if (tmp(i) < 0_int64) then
            tmp(i) = tmp(i) + bb   ! add one full base to restore positivity
            borrow = 1_int64       ! and carry that borrow upward
         else
            borrow = 0_int64       ! result non-negative: no borrow needed
         end if
      end do

      ! Trim leading zero limbs (but always keep at least one limb).
      nc = na
      do while (nc > 1 .and. tmp(nc) == 0_int64)
         nc = nc - 1
      end do
      c = tmp   ! write result out (safe even if c aliases a, since tmp is local)
   end subroutine bg_sub

   ! ---------------------------------------------------------------------------
   ! bg_cmp(a, na, b, nb)  ->  integer result
   !
   ! Compare two big-ints.  Returns:
   !   +1  if  a > b
   !    0  if  a = b
   !   -1  if  a < b
   !
   ! Strategy:
   !   1. A number with more active limbs is larger (they share the same base).
   !   2. If both have the same limb count, scan from most significant to least;
   !      the first differing limb determines the outcome.
   !   3. If every limb matches the numbers are equal.
   ! ---------------------------------------------------------------------------
   function bg_cmp(a, na, b, nb) result(res)
      integer(kind=int64), intent(in) :: a(ml), b(ml)
      integer,             intent(in) :: na, nb
      integer :: res, i

      ! More limbs => larger magnitude (no leading-zero limbs are ever stored).
      if (na > nb) then;  res =  1;  return;  end if
      if (na < nb) then;  res = -1;  return;  end if

      ! Same limb count: scan from the most significant limb downward.
      do i = na, 1, -1
         if (a(i) > b(i)) then;  res =  1;  return;  end if
         if (a(i) < b(i)) then;  res = -1;  return;  end if
      end do

      res = 0   ! every limb matched: the numbers are equal
   end function bg_cmp

   ! ---------------------------------------------------------------------------
   ! bg_div_dec(a, na, b, nb, ndec, rstr)
   !
   ! Compute  a / b  and write the result into the character variable  rstr
   ! in decimal notation with exactly  ndec  digits after the decimal point.
   ! Example:  a/b = golden ratio, ndec=32  =>  rstr = "1.61803398874989484820..."
   !
   ! The caller must ensure  a >= b  (i.e. ratio >= 1), and that  rstr  is
   ! at least  ndec + len(int_part) + 1  characters wide.
   !
   ! Algorithm
   ! ---------
   ! Step 1 -- Integer part
   !   Find the largest integer  q  such that  q*b <= a,  by incrementing q
   !   from 0 while  (q+1)*b <= a.  For our sequences q is at most b+1 (the
   !   metallic parameter), so at most ~11 multiplications are needed.
   !   Compute the remainder  r = a - q*b.
   !
   ! Step 2 -- Decimal digits (long division)
   !   The classical long-division digit loop:
   !     r  <-  r * 10                    (shift remainder left one decimal place)
   !     d  <-  floor(r / b),  0 <= d <= 9  (next decimal digit)
   !     r  <-  r - d*b                   (new remainder for the next digit)
   !   Finding d uses the same trial-multiplication trick: start d=0, increment
   !   while (d+1)*b <= r.  Since 0 <= d <= 9 this costs at most 10 multiplies.
   !
   ! Step 3 -- Assemble result string
   !   Write the integer part using Fortran's I0 format, append '.', then
   !   append the decimal digits one character at a time.
   ! ---------------------------------------------------------------------------
   subroutine bg_div_dec(a, na, b, nb, ndec, rstr)
      integer(kind=int64), intent(in)  :: a(ml), b(ml)  ! numerator, denominator
      integer,             intent(in)  :: na, nb         ! their active limbs
      integer,             intent(in)  :: ndec           ! decimal places wanted
      character(len=*),    intent(out) :: rstr           ! result string

      integer(kind=int64) :: r(ml), t1(ml), t2(ml)  ! remainder; temporaries
      integer :: nr, nt1, nt2                        ! their active limb counts
      integer :: int_part   ! integer part of a/b (small, ~0-10 for our use)
      integer :: d          ! one decimal digit (0-9)
      integer :: j          ! loop counter over decimal positions
      integer :: pos        ! current write position in rstr
      character(len=20) :: ips   ! scratch to format the integer part

      ! ------------------------------------------------------------------
      ! Step 1: find the integer part q = floor(a/b).
      ! We compute (q+1)*b and check whether it still <= a.  If so, q is
      ! not yet large enough and we increment.  When (q+1)*b > a we stop
      ! and q is correct.
      ! ------------------------------------------------------------------
      int_part = 0
      call bg_mul_s(b, nb, int_part + 1, t1, nt1)   ! t1 = 1*b
      do while (bg_cmp(t1, nt1, a, na) <= 0)         ! while (int_part+1)*b <= a
         int_part = int_part + 1
         call bg_mul_s(b, nb, int_part + 1, t1, nt1) ! next candidate
      end do

      ! Compute the remainder  r = a - int_part * b
      call bg_mul_s(b, nb, int_part, t1, nt1)   ! t1 = int_part * b
      call bg_sub(a, na, t1, nt1, r, nr)         ! r  = a - t1

      ! ------------------------------------------------------------------
      ! Assemble the start of the result string: "<integer_part>."
      ! I0 format suppresses leading zeros, e.g. 1 -> "1", 12 -> "12".
      ! After assignment to rstr (a fixed-length char variable) Fortran
      ! pads with spaces to the right; the subsequent character-by-character
      ! writes will overwrite those spaces with decimal digits.
      ! pos points to the first character position after the decimal point.
      ! ------------------------------------------------------------------
      write(ips, '(I0)') int_part
      rstr = trim(ips) // '.'
      pos  = len_trim(ips) + 2   ! 1-based: skip int_part digits and the '.'

      ! ------------------------------------------------------------------
      ! Step 2: long-division decimal digit loop.
      ! Each iteration extracts exactly one decimal digit and updates r.
      ! ------------------------------------------------------------------
      do j = 1, ndec

         ! Shift the remainder left by one decimal place (multiply by 10).
         ! We must use a temporary because bg_mul_s cannot alias input/output.
         call bg_mul_s(r, nr, 10, t1, nt1)
         r  = t1    ! update r in-place via copy (t1 is a local array)
         nr = nt1

         ! Find the digit d = floor(r / b),  0 <= d <= 9.
         ! We try d=0,1,2,... until (d+1)*b > r.
         d = 0
         call bg_mul_s(b, nb, d + 1, t1, nt1)   ! t1 = (d+1)*b = 1*b
         do while (bg_cmp(t1, nt1, r, nr) <= 0)  ! while (d+1)*b <= r
            d = d + 1
            call bg_mul_s(b, nb, d + 1, t1, nt1) ! next candidate digit
         end do
         ! Now d is the correct decimal digit.

         ! Store the digit as a character ('0'+d).
         rstr(pos:pos) = char(ichar('0') + d)
         pos = pos + 1

         ! Update the remainder:  r <- r - d*b
         call bg_mul_s(b, nb, d, t1, nt1)        ! t1 = d*b
         call bg_sub(r, nr, t1, nt1, t2, nt2)    ! t2 = r - t1
         r  = t2    ! copy back into r
         nr = nt2

      end do   ! next decimal digit

   end subroutine bg_div_dec

end module bigint_mod


! =============================================================================
! PROGRAM metallic_ratios
!
! Main driver.  For each of the first ten Metallic Ratios (b = 0 .. 9):
!   1. Generate and print the first 15 terms of the Lucas-like sequence
!        x(n) = b * x(n-1) + x(n-2),   x(1) = x(2) = 1.
!   2. Iterate the recurrence using arbitrary-precision big-ints, computing
!      the ratio x(n+1)/x(n) to 32 decimal places after each step.
!   3. Stop when two consecutive ratio strings are identical (convergence).
!   4. Report the converged ratio and the iteration index n.
!
! Stretch goal: repeat step 2-4 for b=1 (Golden Ratio) to 256 decimal places.
!
! Variable layout
! ---------------
!   xa, xb   -- the two most-recent sequence terms (big-ints)
!   xc       -- temporary holding  b * x(n),  the first part of the recurrence
!   xt       -- the new term  x(n+1) = b*x(n) + x(n-1)
!   na..nt_v -- active limb counts for xa..xt respectively
!   seq(15)  -- first 15 terms as ordinary int64 (they fit; largest is ~3e12)
!   prev_str -- ratio string from the previous iteration
!   curr_str -- ratio string from the current iteration
! =============================================================================
program metallic_ratios
   use bigint_mod
   use iso_fortran_env, only: int64
   implicit none

   ! Big-int working arrays for the two live sequence terms and two temporaries.
   integer(kind=int64) :: xa(ml), xb(ml), xc(ml), xt(ml)
   integer :: na    ! active limbs in xa  (the x(n-1) term)
   integer :: nb_v  ! active limbs in xb  (the x(n)   term)
   integer :: nc    ! active limbs in xc  (intermediate: b * x(n))
   integer :: nt_v  ! active limbs in xt  (the new x(n+1) term)

   integer :: bv        ! metallic parameter (the "b" in the task description)
   integer :: i         ! loop index for building seq()
   integer :: iter      ! iteration count (= n in the task description)
   integer :: ndec      ! how many decimal places we want

   ! First 15 terms stored as 64-bit integers (the largest, for b=9, is ~3e12,
   ! well within int64's range of ~9.2e18).
   integer(kind=int64) :: seq(15)

   ! Ratio strings.  Length 310 comfortably holds:
   !   2 chars  (integer part + '.') + 256 decimal digits + padding spaces
   character(len=310) :: prev_str   ! ratio string from the previous iteration
   character(len=310) :: curr_str   ! ratio string from the current iteration

   logical :: converged   ! .TRUE. once curr_str matches prev_str

   ! Human-readable names indexed by b.
   character(len=10) :: names(0:9)
   names(0) = 'Platinum'
   names(1) = 'Golden'
   names(2) = 'Silver'
   names(3) = 'Bronze'
   names(4) = 'Copper'
   names(5) = 'Nickel'
   names(6) = 'Aluminum'
   names(7) = 'Iron'
   names(8) = 'Tin'
   names(9) = 'Lead'

   ! -------------------------------------------------------------------------
   ! Header
   ! -------------------------------------------------------------------------
   write(*, '(A)') "Metallic Ratios via Lucas-like Sequences"
   write(*, '(A)') repeat('=', 62)
   write(*, *)

   ndec = 32   ! target precision for the main loop

   ! =========================================================================
   ! Main loop: b = 0, 1, ..., 9
   ! =========================================================================
   do bv = 0, 9

      ! -----------------------------------------------------------------------
      ! Part A: Generate the first 15 sequence terms using ordinary int64.
      !
      ! The sequence is  x(n) = bv * x(n-1) + x(n-2),  x(1) = x(2) = 1.
      ! For bv=0 every term is 1.
      ! For bv=1 we get the Fibonacci sequence: 1,1,2,3,5,8,...
      ! For bv=9 the 15th term is ~3.26e12, comfortably within int64.
      ! -----------------------------------------------------------------------
      seq(1) = 1_int64
      seq(2) = 1_int64
      do i = 3, 15
         seq(i) = int(bv, int64) * seq(i - 1) + seq(i - 2)
      end do

      write(*, '(A,I1,A,A)') "b=", bv, "  ", trim(names(bv))
      write(*, '(A)') "First 15 Lucas sequence terms:"
      write(*, '(5(1X,I18))') seq(1:5)    ! rows of 5 for compact display
      write(*, '(5(1X,I18))') seq(6:10)
      write(*, '(5(1X,I18))') seq(11:15)

      ! -----------------------------------------------------------------------
      ! Part B: Converge the ratio to ndec=32 decimal places.
      !
      ! Special case b=0: the sequence is identically 1, the ratio is
      ! exactly 1, and the formula (0 + sqrt(4)) / 2 = 1 confirms this.
      ! No iteration is needed.
      ! -----------------------------------------------------------------------
      if (bv == 0) then
         write(*, '(A)') "Ratio = 1  (exact, degenerate Platinum case)"
         write(*, *)
         cycle   ! skip to next b
      end if

      ! Seed the big-int sequence with x(1) = 1, x(2) = 1.
      call bg_set(xa, na,   1_int64)   ! xa = x(n-1) = 1  (previous-previous term)
      call bg_set(xb, nb_v, 1_int64)  ! xb = x(n)   = 1  (previous term)

      prev_str  = ''       ! empty string: guaranteed not to match first ratio
      converged = .false.
      iter      = 2        ! we already have terms 1 and 2 in xa and xb

      ! -----------------------------------------------------------------------
      ! Iteration loop.
      !
      ! Each pass:
      !   1. Compute  x(n+1) = bv * x(n) + x(n-1)   using big-int arithmetic.
      !   2. Compute the ratio  x(n+1) / x(n)  to ndec decimal places.
      !   3. Compare with the ratio from the previous iteration.
      !      If identical, the approximation has stabilised and we stop.
      !      Otherwise record the new ratio and advance the sequence.
      !
      ! Note on aliasing: bg_mul_s and bg_add require distinct arrays for
      ! input and output, so we use xc and xt as intermediates rather than
      ! overwriting xb in place.
      ! -----------------------------------------------------------------------
      do while (.not. converged)

         ! Step 1: compute the new sequence term.
         !   xc = bv * xb             (b * x(n))
         !   xt = xc + xa             (b * x(n) + x(n-1) = x(n+1))
         call bg_mul_s(xb, nb_v, bv, xc, nc)     ! xc = bv * x(n)
         call bg_add(xc, nc, xa, na, xt, nt_v)   ! xt = xc + x(n-1)

         ! Step 2: form the ratio x(n+1) / x(n) as a decimal string.
         call bg_div_dec(xt, nt_v, xb, nb_v, ndec, curr_str)

         ! Step 3: test for convergence.
         ! Fortran character comparison checks all len(curr_str) characters,
         ! including the trailing spaces that Fortran appends to fixed-length
         ! strings.  Both strings are built identically by bg_div_dec, so
         ! trailing-space counts match and the comparison is correct.
         if (curr_str == prev_str) then
            converged = .true.   ! ratio unchanged to ndec places -- done
         else
            ! Not yet converged: record this ratio and advance the sequence.
            !   xa <-- old xb  (old x(n) becomes the new x(n-1))
            !   xb <-- xt      (new x(n+1) becomes the new x(n))
            prev_str = curr_str
            call bg_copy(xb, nb_v, xa, na)    ! xa = old xb
            call bg_copy(xt, nt_v, xb, nb_v) ! xb = xt
            iter = iter + 1
         end if

      end do   ! while not converged

      write(*, '(A,I6)') "Converged at n =", iter
      write(*, '(2A)')   "Ratio = ", trim(curr_str)
      write(*, *)

   end do   ! bv = 0 .. 9

   ! ==========================================================================
   ! Stretch goal: Golden Ratio (b=1) to 256 decimal places.
   !
   ! The Golden Ratio has the SLOWEST convergence of all Metallic Ratios
   ! because its continued fraction [1;1,1,1,...] converges most slowly
   ! among all irrationals (a classical result in Diophantine approximation).
   ! Roughly 256 / log10(phi) â‰ˆ 1225 iterations are needed.
   ! At that point each Fibonacci number has about 256 decimal digits, so
   ! the big-int arithmetic is the only practical approach.
   ! ==========================================================================
   write(*, '(A)') repeat('=', 62)
   write(*, '(A)') "STRETCH GOAL: Golden Ratio to 256 decimal places"
   write(*, '(A)') repeat('=', 62)
   write(*, *)

   ndec = 256
   bv   = 1      ! Golden Ratio: b=1

   call bg_set(xa, na,   1_int64)   ! seed x(1) = 1
   call bg_set(xb, nb_v, 1_int64)  ! seed x(2) = 1
   prev_str  = ''
   converged = .false.
   iter      = 2

   ! Same iteration loop as above; only ndec differs.
   do while (.not. converged)
      call bg_mul_s(xb, nb_v, bv, xc, nc)
      call bg_add(xc, nc, xa, na, xt, nt_v)
      call bg_div_dec(xt, nt_v, xb, nb_v, ndec, curr_str)
      if (curr_str == prev_str) then
         converged = .true.
      else
         prev_str = curr_str
         call bg_copy(xb, nb_v, xa, na)
         call bg_copy(xt, nt_v, xb, nb_v)
         iter = iter + 1
      end if
   end do

   write(*, '(A,I6)') "Converged at n =", iter
   write(*, '(A)')    "Golden Ratio ="

   ! Print the 258-character result ("1." + 256 digits) as 40-character lines
   ! so it is readable in a standard 80-column terminal.
   ! The slice boundaries step by 40 through the string, with the last slice
   ! picking up the remaining 18 characters (positions 241-258).
   write(*, '(A)') curr_str(  1: 42)
   write(*, '(A)') curr_str( 43: 82)
   write(*, '(A)') curr_str( 83:122)
   write(*, '(A)') curr_str(123:162)
   write(*, '(A)') curr_str(163:202)
   write(*, '(A)') curr_str(203:242)
   write(*, '(A)') curr_str(243:258)
   write(*, *)

end program metallic_ratios
