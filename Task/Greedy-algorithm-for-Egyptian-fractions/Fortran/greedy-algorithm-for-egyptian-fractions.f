program egyptian_fractions
   implicit none

   integer, parameter :: base = 1000000000
   integer, parameter :: max_dig = 800
   integer, parameter :: max_terms = 2000

   type big_int
      integer :: len = 0
      integer :: d(max_dig) = 0 ! least significant digit first
   end type big_int

   type(big_int) :: terms(max_terms)
   integer :: nterms

   type(big_int) :: max_terms_terms(max_terms)
   integer :: max_terms_n = 0
   integer :: max_terms_a, max_terms_b

   type(big_int) :: max_denom_terms(max_terms)
   integer :: max_denom_n = 0
   integer :: max_denom_a, max_denom_b
   type(big_int) :: max_denom_val

   integer :: a, b, int_part, frac_num

   ! ------------------------------------------------------------------
   ! Required examples
   ! ------------------------------------------------------------------
   call compute_egyptian(43, 48, terms, nterms)
   write(*, '(A)', advance='no') "43/48 = "
   call print_egyptian(0, terms, nterms)
   write(*, *)

   call compute_egyptian(5, 121, terms, nterms)
   write(*, '(A)', advance='no') "5/121 = "
   call print_egyptian(0, terms, nterms)
   write(*, *)

   int_part = 2014 / 59
   frac_num = 2014 - int_part * 59
   call compute_egyptian(frac_num, 59, terms, nterms)
   write(*, '(A)', advance='no') "2014/59 = "
   call print_egyptian(int_part, terms, nterms)
   write(*, '(/)')

   ! ------------------------------------------------------------------
   ! Proper fractions with 1- or 2-digit a,b
   ! ------------------------------------------------------------------
   call big_from_int(max_denom_val, 0)

   do a = 1, 99
      do b = a + 1, 99
         call compute_egyptian(a, b, terms, nterms)

         if (nterms > max_terms_n) then
            max_terms_n = nterms
            max_terms_a = a
            max_terms_b = b
            max_terms_terms(1:nterms) = terms(1:nterms)
         end if

         if (nterms > 0) then
            if (big_compare(terms(nterms), max_denom_val) > 0) then
               max_denom_val = terms(nterms)
               max_denom_n = nterms
               max_denom_a = a
               max_denom_b = b
               max_denom_terms(1:nterms) = terms(1:nterms)
            end if
         end if
      end do
   end do

   write(*, '(A,I0,A,I0,A,I0,A)', advance='no') &
         "Largest number of terms (1-99): ", max_terms_n, " terms => ", max_terms_a, "/", max_terms_b, " = "
   call print_egyptian(0, max_terms_terms, max_terms_n)
   write(*, '(/)')

   write(*, '(A)', advance='no') "Largest denominator (1-99): "
   call print_big(max_denom_val)
   write(*, '(A,I0,A,I0,A)', advance='no') " => ", max_denom_a, "/", max_denom_b, " = "
   call print_egyptian(0, max_denom_terms, max_denom_n)
   write(*, *)
   write(*, *)

   ! ------------------------------------------------------------------
   ! Extra credit: 1- to 3-digit a,b
   ! ------------------------------------------------------------------
   max_terms_n = 0
   call big_from_int(max_denom_val, 0)
   max_denom_n = 0

   do a = 1, 999
      do b = a + 1, 999
         call compute_egyptian(a, b, terms, nterms)

         if (nterms > max_terms_n) then
            max_terms_n = nterms
            max_terms_a = a
            max_terms_b = b
            max_terms_terms(1:nterms) = terms(1:nterms)
         end if

         if (nterms > 0) then
            if (big_compare(terms(nterms), max_denom_val) > 0) then
               max_denom_val = terms(nterms)
               max_denom_n = nterms
               max_denom_a = a
               max_denom_b = b
               max_denom_terms(1:nterms) = terms(1:nterms)
            end if
         end if
      end do
   end do

   write(*, '(A,I0,A,I0,A,I0,A)', advance='no') &
         "Largest number of terms (1-999): ", max_terms_n, " terms => ", max_terms_a, "/", max_terms_b, " = "
   call print_egyptian(0, max_terms_terms, max_terms_n)
   write(*, *)

   write(*, '(A)', advance='no') "Largest denominator (1-999): "
   call print_big(max_denom_val)
   write(*, '(A,I0,A,I0,A)', advance='no') " => ", max_denom_a, "/", max_denom_b, " = "
   call print_egyptian(0, max_denom_terms, max_denom_n)
   write(*, *)

contains

   subroutine compute_egyptian(num0, den0, terms_out, nterms_out)
      integer, intent(in) :: num0, den0
      type(big_int), intent(out) :: terms_out(:)
      integer, intent(out) :: nterms_out

      type(big_int) :: den_big, d_big, temp
      integer :: num, mod_val, new_num

      nterms_out = 0
      if (num0 <= 0 .or. den0 <= 0) return

      num = num0
      call big_from_int(den_big, den0)

      do while (num > 0)
         temp = den_big
         call big_add_small(temp, num - 1)
         call big_div_small(temp, num, d_big)

         nterms_out = nterms_out + 1
         if (nterms_out > size(terms_out)) stop 'Too many terms - increase MAX_TERMS'

         terms_out(nterms_out) = d_big

         mod_val = big_mod_small(den_big, num)
         if (mod_val == 0) then
            new_num = 0
         else
            new_num = num - mod_val
         end if

         call big_mul(den_big, d_big, temp)
         den_big = temp

         num = new_num
      end do
   end subroutine compute_egyptian

   subroutine big_from_int(b, i)
      type(big_int), intent(out) :: b
      integer, intent(in) :: i
      b%len = 0
      b%d = 0
      if (i == 0) return
      b%len = 1
      b%d(1) = i
   end subroutine big_from_int

   subroutine big_add_small(b, s)
      type(big_int), intent(inout) :: b
      integer, intent(in) :: s
      integer(kind=8) :: carry, tmp
      integer :: i

      if (s == 0) return
      carry = s
      i = 1
      do while (carry > 0)
         if (i > b%len) then
            if (i > max_dig) stop 'Overflow in big_add_small'
            b%len = i
            b%d(i) = 0
         end if
         tmp = int(b%d(i), 8) + carry
         b%d(i) = mod(tmp, int(base, 8))
         carry = tmp / int(base, 8)
         i = i + 1
      end do
   end subroutine big_add_small

   subroutine big_mul(a, b, res)
      type(big_int), intent(in) :: a, b
      type(big_int), intent(out) :: res
      integer(kind=8) :: tmp, carry
      integer :: i, j, k

      res%d = 0
      res%len = 0
      if (a%len == 0 .or. b%len == 0) return

      do i = 1, a%len
         carry = 0
         do j = 1, b%len
            k = i + j - 1
            tmp = int(a%d(i), 8) * int(b%d(j), 8) + int(res%d(k), 8) + carry
            res%d(k) = mod(tmp, int(base, 8))
            carry = tmp / int(base, 8)
         end do
         k = i + b%len
         do while (carry > 0)
            if (k > max_dig) stop 'Overflow in big_mul'
            tmp = int(res%d(k), 8) + carry
            res%d(k) = mod(tmp, int(base, 8))
            carry = tmp / int(base, 8)
            k = k + 1
         end do
      end do

      res%len = a%len + b%len + 1
      do while (res%len > 0 .and. res%d(res%len) == 0)
         res%len = res%len - 1
      end do
   end subroutine big_mul

   integer function big_mod_small(b, s)
      type(big_int), intent(in) :: b
      integer, intent(in) :: s
      integer(kind=8) :: rem
      integer :: i

      rem = 0
      do i = b%len, 1, -1
         rem = mod(rem * int(base, 8) + b%d(i), int(s, 8))
      end do
      big_mod_small = int(rem)
   end function big_mod_small

   subroutine big_div_small(b, s, q)
      type(big_int), intent(in) :: b
      integer, intent(in) :: s
      type(big_int), intent(out) :: q
      integer(kind=8) :: tmp, carry
      integer :: i

      q%d = 0
      q%len = b%len
      carry = 0
      do i = b%len, 1, -1
         tmp = carry * int(base, 8) + b%d(i)
         q%d(i) = tmp / s
         carry = mod(tmp, int(s, 8))
      end do
      do while (q%len > 0 .and. q%d(q%len) == 0)
         q%len = q%len - 1
      end do
   end subroutine big_div_small

   integer function big_compare(a, b)
      type(big_int), intent(in) :: a, b
      integer :: i

      if (a%len > b%len) then
         big_compare = 1
      else if (a%len < b%len) then
         big_compare = -1
      else if (a%len == 0) then
         big_compare = 0
      else
         do i = a%len, 1, -1
            if (a%d(i) > b%d(i)) then
               big_compare = 1
               return
            else if (a%d(i) < b%d(i)) then
               big_compare = -1
               return
            end if
         end do
         big_compare = 0
      end if
   end function big_compare

   subroutine print_big(b)
      type(big_int), intent(in) :: b
      character(20) :: buf
      character(len=max_dig) :: pooka
      character(len=8) :: front, back
      integer :: i
      pooka = ''
      if (b%len == 0) then
         write(*, '(A)', advance='no') "0"
         return
      end if
      write(buf, '(I0)') b%d(b%len)
!      write(*, '(A)', advance='no') trim(buf)
      pooka = trim(adjustl(buf))
      do i = b%len - 1, 1, -1
         write(buf, '(I9.9)') b%d(i)
         !         write(*,'(A)',advance='no') trim(adjustl(buf))
         pooka = trim(pooka) // trim(adjustl(buf))
      end do
      i = len_trim(pooka)
      if (i > 19)then
         front = pooka(1:8)
         back = pooka(i - 8:)
         pooka = front // '....' // back
      end if
      write(*, '(A)', advance='no') trim(adjustl(pooka))
   end subroutine print_big

   subroutine print_egyptian(int_part, terms_in, n_in)
      integer, intent(in) :: int_part, n_in
      type(big_int), intent(in) :: terms_in(:)
      integer :: i
      logical :: need_plus

      need_plus = .false.
      if (int_part > 0) then
         write(*, '(A,I0,A)', advance='no') "[", int_part, "]"
         if (n_in > 0) then
            write(*, '(A)', advance='no') " + "
            need_plus = .false.
         end if
      end if

      do i = 1, n_in
         if (need_plus) write(*, '(A)', advance='no') " + "
         write(*, '(A)', advance='no') "1/"
         call print_big(terms_in(i))
         need_plus = .true.
      end do
   end subroutine print_egyptian

end program egyptian_fractions
