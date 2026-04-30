! Full Fortran program using an efficient sieve-based unprimeable number finder
! with packed bit array and digit changing, printing first 35, 600th, and lowest per digit unprimeables.

module bitarray_mod
   implicit none
   private
   public :: bit_array, bit_array_create, bit_array_destroy, bit_array_set, bit_array_get

   type :: bit_array
      integer :: size ! number of bits
      integer, allocatable :: array(:) ! integer array storing bits
   end type bit_array

contains

   function bit_array_create(size) result(b)
      integer, intent(in) :: size
      type(bit_array) :: b
      integer :: nwords

      nwords = shiftr(size + 31, 5)! / 32
      allocate(b%array(nwords))
      b%array = 0
      b%size = size
   end function bit_array_create

   subroutine bit_array_destroy(b)
      type(bit_array), intent(inout) :: b
      if (allocated(b%array)) deallocate(b%array)
      b%size = 0
   end subroutine bit_array_destroy

   subroutine bit_array_set(b, index, value)
      type(bit_array), intent(inout) :: b
      integer, intent(in) :: index
      logical, intent(in) :: value
      integer :: word, bitpos

      word = shiftr(index, 5) + 1
      bitpos = iand(index, 31)
      if (value) then
         b%array(word) = ibset(b%array(word), bitpos)
      else
         b%array(word) = ibclr(b%array(word), bitpos)
      end if
   end subroutine bit_array_set

   logical function bit_array_get(b, index)
      type(bit_array), intent(in) :: b
      integer, intent(in) :: index
      integer :: word, bitpos

      word = shiftr(index, 5) + 1
      bitpos = iand(index, 31)
      bit_array_get = btest(b%array(word), bitpos)
   end function bit_array_get

end module bitarray_mod

program unprimeable_numbers
  use bitarray_mod
   implicit none
   integer, parameter :: limit = 10000000
   type(bit_array) :: sieve
   integer :: n, i, count, found, digit
   integer, dimension(0:9) :: lowest = 0
   character(len=20) :: outstr

   call sieve_create(sieve, limit)

   print *, "First 35 unprimeable numbers:"
   count = 0
   found = 0
   n = 100
   do while ((found < 10 .or. count < 600) .and. n < limit)
      if (unprimeable(sieve, n)) then
         count = count + 1
         if (count <= 35) then
            if (count > 1) write(*, '(A)', advance='no') ", "
            call format_with_commas(n, outstr)
            write(*, '(A)', advance='no') trim(outstr)
         end if
         if (count == 600) then
            print *
            call format_with_commas(n, outstr)
            print *, "600th unprimeable number: ", trim(outstr)
         end if
         digit = mod(n, 10)
         if (lowest(digit) == 0) then
            lowest(digit) = n
            found = found + 1
         end if
      end if
      n = n + 1
   end do
   print *
   print *, "Lowest unprimeable numbers ending in each digit:"
   do i = 0, 9
      if (lowest(i) == 0) then
         print "(A,I1,A)", "Digit ", i, ": none found"
      else
         call format_with_commas(lowest(i), outstr)
         print "(A,I1,A,A)", "Digit ", i, ": ", trim(outstr)
      end if
   end do

   call sieve_destroy(sieve)

contains

   subroutine sieve_create(s, lim)
      type(bit_array), intent(out) :: s
      integer, intent(in) :: lim
      integer :: sqrtn, p, inc, q, idx

      s = bit_array_create(lim / 2)
      sqrtn = int(sqrt(real(lim)))
      do p = 3, sqrtn, 2
         idx = shiftr(p, 1) - 1
         if (.not.bit_array_get(s, idx)) then
            inc = shiftl(p, 1)
            q = p * p
            do while (q <= lim)
               call bit_array_set(s, shiftr(q, 1) - 1, .true.)
               q = q + inc
            end do
         end if
      end do
   end subroutine sieve_create

   subroutine sieve_destroy(s)
      type(bit_array), intent(inout) :: s
      call bit_array_destroy(s)
   end subroutine sieve_destroy

   logical function is_prime(s, num)
      type(bit_array), intent(in) :: s
      integer, intent(in) :: num
      if (num == 2) then
         is_prime = .true.
      else if (num < 2 .or. iand(num, 1) == 0) then
         is_prime = .false.
      else
         is_prime = .not.bit_array_get(s, shiftr(num, 1) - 1)
      end if
   end function is_prime

   function count_digits(n) result(d)
      integer, intent(in) :: n
      integer :: d
      if (n <= 0) then
         d = 1
      else
         d = int(log10(real(n))) + 1
      end if
   end function count_digits

   function change_digit(n, index, new_digit) result(res)
      integer, intent(in) :: n ! Input integer (assumed non-negative)
      integer, intent(in) :: index ! Zero-based index from the right (0 = least significant digit)
      integer, intent(in) :: new_digit ! Digit to insert (should be 0–9)
      integer :: res ! Resulting integer after digit replacement
      integer :: pow10 ! 10^index (position multiplier)
      integer :: old_digit ! Digit currently at the target position

      ! Guard against invalid index (e.g., negative)
      if (index < 0) then
         res = n
         return
      end if

      ! Compute 10^index to isolate the target digit
      pow10 = 10**index

      ! Extract the digit currently at the target position
      old_digit = mod(n / pow10, 10)

      ! Subtract the old digit's contribution and add the new digit's contribution
      res = n - old_digit * pow10 + new_digit * pow10
   end function change_digit

   logical function unprimeable(s, n)
      type(bit_array), intent(in) :: s
      integer, intent(in) :: n
      integer :: d, i, j, m
      logical :: prime_found

      if (is_prime(s, n)) then
         unprimeable = .false.
         return
      end if

      d = count_digits(n)
      prime_found = .false.
      do i = 0, d - 1
         do j = 0, 9
            m = change_digit(n, i, j)
            if (m /= n .and. is_prime(s, m)) then
               prime_found = .true.
               exit
            end if
         end do
         if (prime_found) exit
      end do
      unprimeable = .not.prime_found
   end function unprimeable

   subroutine format_with_commas(n, s)
      integer, intent(in) :: n
      character(len=*), intent(out) :: s
      character(len=20) :: t
      integer :: len_t, i, j, comma_pos, len_s

      write(t, '(I0)') n
      len_t = len_trim(t)
      s = ''
      len_s = 0
      comma_pos = 0
      do i = len_t, 1, -1
         len_s = len_s + 1
         s(len_s:len_s) = t(i:i)
         comma_pos = comma_pos + 1
         if (mod(comma_pos, 3) == 0 .and. i > 1) then
            len_s = len_s + 1
            s(len_s:len_s) = ','
         end if
      end do
      ! Reverse string s to get correct order
      do i = 1, len_s / 2
         j = iachar(s(i:i))
         s(i:i) = s(len_s - i + 1:len_s - i + 1)
         s(len_s - i + 1:len_s - i + 1) = char(j)
      end do
      s = adjustl(s(1:len_s))
   end subroutine format_with_commas

end program unprimeable_numbers
