! Translated from C then highly modified to be efficient.
module forsooth
   use iso_fortran_env
   implicit none
   ! Constants and types
   integer, parameter :: key_len = 8
   integer, parameter :: ubyte = selected_int_kind(2)

   ! Permutation tables (converted to 0-based indexing)
   integer(kind=ubyte), parameter :: pc1(0:55) = [&
         56, 48, 40, 32, 24, 16, 8, &
         0, 57, 49, 41, 33, 25, 17, &
         9, 1, 58, 50, 42, 34, 26, &
         18, 10, 2, 59, 51, 43, 35, &
         62, 54, 46, 38, 30, 22, 14, &
         6, 61, 53, 45, 37, 29, 21, &
         13, 5, 60, 52, 44, 36, 28, &
         20, 12, 4, 27, 19, 11, 3]

   integer(kind=ubyte), parameter :: pc2(0:47) = [&
         13, 16, 10, 23, 0, 4, &
         2, 27, 14, 5, 20, 9, &
         22, 18, 11, 3, 25, 7, &
         15, 6, 26, 19, 12, 1, &
         40, 51, 30, 36, 46, 54, &
         29, 39, 50, 44, 32, 47, &
         43, 48, 38, 55, 33, 52, &
         45, 41, 49, 35, 28, 31]

   integer(kind=ubyte), parameter :: ip(0:63) = [&
         57, 49, 41, 33, 25, 17, 9, 1, &
         59, 51, 43, 35, 27, 19, 11, 3, &
         61, 53, 45, 37, 29, 21, 13, 5, &
         63, 55, 47, 39, 31, 23, 15, 7, &
         56, 48, 40, 32, 24, 16, 8, 0, &
         58, 50, 42, 34, 26, 18, 10, 2, &
         60, 52, 44, 36, 28, 20, 12, 4, &
         62, 54, 46, 38, 30, 22, 14, 6]

   integer(kind=ubyte), parameter :: e(0:47) = [&
         31, 0, 1, 2, 3, 4, &
         3, 4, 5, 6, 7, 8, &
         7, 8, 9, 10, 11, 12, &
         11, 12, 13, 14, 15, 16, &
         15, 16, 17, 18, 19, 20, &
         19, 20, 21, 22, 23, 24, &
         23, 24, 25, 26, 27, 28, &
         27, 28, 29, 30, 31, 0]

   integer(kind=ubyte), parameter :: s(0:7, 0:63) = reshape([&
         14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7, &
         0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8, &
         4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0, &
         15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13, &
         15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10, &
         3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5, &
         0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15, &
         13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9, &
         10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8, &
         13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1, &
         13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7, &
         1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12, &
         7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15, &
         13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9, &
         10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4, &
         3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14, &
         2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9, &
         14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6, &
         4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14, &
         11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3, &
         12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11, &
         10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8, &
         9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6, &
         4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13, &
         4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1, &
         13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6, &
         1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2, &
         6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12, &
         13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7, &
         1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2, &
         7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8, &
         2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11], &
         [8, 64])

   integer(kind=ubyte), parameter :: p(0:31) = [&
         15, 6, 19, 20, &
         28, 11, 27, 16, &
         0, 14, 22, 25, &
         4, 17, 30, 9, &
         1, 7, 23, 13, &
         31, 26, 2, 8, &
         18, 12, 29, 5, &
         21, 10, 3, 24]

   integer(kind=ubyte), parameter :: ip2(0:63) = [&
         39, 7, 47, 15, 55, 23, 63, 31, &
         38, 6, 46, 14, 54, 22, 62, 30, &
         37, 5, 45, 13, 53, 21, 61, 29, &
         36, 4, 44, 12, 52, 20, 60, 28, &
         35, 3, 43, 11, 51, 19, 59, 27, &
         34, 2, 42, 10, 50, 18, 58, 26, &
         33, 1, 41, 9, 49, 17, 57, 25, &
         32, 0, 40, 8, 48, 16, 56, 24]

   integer(kind=ubyte), parameter :: shifts(0:15) = [&
         1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

   ! Test data
   integer(kind=ubyte) :: key1(0:key_len - 1) = [int(z'13', ubyte), int(z'34', ubyte), int(z'57', ubyte), int(z'79', ubyte), &
         int(z'9B', ubyte), int(z'BC', ubyte), int(z'DF', ubyte), int(z'F1', ubyte)]
   integer(kind=ubyte) :: message1(0:7) = [int(z'01', ubyte), int(z'23', ubyte), int(z'45', ubyte), int(z'67', ubyte), &
         int(z'89', ubyte), int(z'AB', ubyte), int(z'CD', ubyte), int(z'EF', ubyte)]

contains
   pure function string_to_ubyte(str) result(bytes)
      character(len=*), intent(in) :: str
      integer(kind=ubyte), allocatable :: bytes(:)
      integer :: n, i

      ! length of the trimmed input
      n = len_trim(str)
      allocate(bytes(n), source=[(iachar(str(i:i), kind=int8), i = 1, n)]) !Allocate and fill with the string

   end function string_to_ubyte

   function hex16_to_ubytes(hexstr) result(bytes)
      character(len=16), intent(in) :: hexstr
      integer(kind=ubyte) :: bytes(8)

      read(hexstr, '(8z2)')bytes
   end function hex16_to_ubytes

   subroutine print_bytes(ptr, len, out)
      integer(kind=ubyte), intent(in) :: ptr(0:)
      integer, intent(in) :: len
      character(len=*), intent(out) :: out
      integer :: i
      out = ' '
      ! Using internal write with hex format
      write(out, '(*(Z2.2))')(ptr(i), i = 0, len - 1)
      !   out = trim(out)
   end subroutine print_bytes

   pure function peek_bit(src, index) result(bit_val)
      integer(kind=ubyte), intent(in) :: src(0:)
      integer, intent(in) :: index
      integer :: bit_val
      integer :: cell, pos

      ! Determine which byte and which bit (0=LSB … 7=MSB)
      cell = index / 8
      pos = 7 - mod(index, 8)

      ! BTEST returns .TRUE. if bit 'pos' of src(cell) is set
      bit_val = merge(1, 0, btest(src(cell), pos))
   end function peek_bit

   subroutine poke_bit(dst, index, value)
      implicit none
      integer, parameter :: ubyte = selected_int_kind(2)
      integer(kind=ubyte), intent(inout) :: dst(0:)
      integer, intent(in) :: index, value
      integer :: cell, bit

      ! Determine which byte in dst and which bit within that byte
      cell = index / 8
      bit = 7 - mod(index, 8)

      if (value == 0) then
         ! Clear the bit using ibclr(byte, position)
         dst(cell) = ibclr(dst(cell), bit)
      else
         ! Set the bit using ibset(byte, position)
         dst(cell) = ibset(dst(cell), bit)
      end if
   end subroutine poke_bit

   subroutine shift_left(src, len, times, dst)
      integer(kind=ubyte), intent(in) :: src(:)
      integer, intent(in) :: times, len
      integer(kind=ubyte), intent(out) :: dst(:)

      ! now src(:) and dst(:) pick up the caller’s bounds automatically
      dst = ishftc(src, times, bit_size(src(1)))
   end subroutine shift_left

   subroutine get_sub_keys(key, ks)
      integer(kind=ubyte), intent(in) :: key(0:key_len - 1)
      integer(kind=ubyte), intent(out) :: ks(0:16, 0:5) ! 17 sets of 48 bits
      integer(kind=ubyte) :: c(0:16, 0:6) ! 56 bits
      integer(kind=ubyte) :: d(0:16, 0:3) ! 28 bits
      integer(kind=ubyte) :: kp(0:6)
      integer :: i

      ! Initialize arrays
      c = 0
      d = 0
      ks = 0

      ! Permute 'key' using table PC1
      !      do i = 0, 55
      !         call poke_bit(kp, i, peek_bit(key, int(pc1(i))))
      !      end do
      call permute_bits(kp, key, pc1, 56)

      ! Split 'kp' in half and process the resulting series of 'c' and 'd'
      do i = 0, 27
         call poke_bit(c(0, :), i, peek_bit(kp, i))
         call poke_bit(d(0, :), i, peek_bit(kp, i + 28))
      end do

      ! Shift the components of c and d
      do i = 1, 16
         call shift_left(c(i - 1, :), 28, int(shifts(i - 1)), c(i, :))
         call shift_left(d(i - 1, :), 28, int(shifts(i - 1)), d(i, :))
      end do

      ! Merge 'd' into 'c'
      do i = 1, 16
         ! Direct byte copy (most efficient)
         c(i, 3:6) = d(i, 0:3) ! Copying bits 28-55 (bytes 3-6) from bits 0-27 (bytes 0-3)
      end do

      ! Form the sub-keys and store them in 'ks'
      ! Permute 'c' using table PC2
      do i = 1, 16
         call permute_bits(ks(i, :), c(i, :), pc2, 48)
      end do
   end subroutine get_sub_keys

   subroutine f(r, ks, sp)
      integer(kind=ubyte), intent(in) :: r(0:3) ! 32 bits
      integer(kind=ubyte), intent(in) :: ks(0:5) ! 48 bits
      integer(kind=ubyte), intent(out) :: sp(0:3) ! 32 bits
      integer(kind=ubyte) :: er(0:5) ! 48 bits
      integer(kind=ubyte) :: sr(0:3) ! 32 bits
      integer :: i, j, k, row, col, m
      integer :: b(0:5)

      ! Initialize
      er = 0
      sr = 0

      ! Permute 'r' using table E
      call permute_bits(er, r, e, 48)

      ! XOR 'er' with 'ks' and store back into 'er'
      do i = 0, 5
         er(i) = ieor(er(i), ks(i))
      end do

      ! Process 'er' six bits at a time and store resulting four bits in 'sr'
      do i = 0, 7
         j = i * 6

         do k = 0, 5
            if (peek_bit(er, j + k) /= 0) then
               b(k) = 1
            else
               b(k) = 0
            end if
         end do

         row = 2 * b(0) + b(5)
         col = 8 * b(1) + 4 * b(2) + 2 * b(3) + b(4)
         m = s(i, row * 16 + col) ! Apply table S
         call store_4bit_reversed(sr, (i + 1) * 4 - 1, m)
      end do
      ! Permute sr using table P
      call permute_bits(sp, sr, p, 32)
   end subroutine f

   ! Assumes m is a 4-bit value and we're storing in positions base_pos to base_pos+3
   subroutine store_4bit_reversed(sr, base_pos, m)
      integer(kind=ubyte), intent(inout) :: sr(0:)
      integer, intent(in) :: base_pos, m
      integer :: byte_idx, bit_pos, actual_pos, j

      ! Store each bit directly using bit manipulation
      ! Go backwards from base_pos (base_pos, base_pos-1, base_pos-2, base_pos-3)
      do j = 0, 3
         actual_pos = base_pos - j
         byte_idx = shiftr(actual_pos, 3)! / 8
         bit_pos = 7 - iand(actual_pos, 7)! mod(actual_pos, 8)

         if (btest(m, j)) then ! Test bit j of m (LSB first)
            sr(byte_idx) = ibset(sr(byte_idx), bit_pos)
         else
            sr(byte_idx) = ibclr(sr(byte_idx), bit_pos)
         end if
      end do
   end subroutine store_4bit_reversed

   subroutine process_message(message, ks, ep)
      integer(kind=ubyte), intent(in) :: message(0:7) ! 64 bits
      integer(kind=ubyte), intent(in) :: ks(0:16, 0:5) ! subkeys
      integer(kind=ubyte), intent(out) :: ep(0:7) ! 64 bits
      integer(kind=ubyte) :: left(0:16, 0:3) ! 32 bits
      integer(kind=ubyte) :: right(0:16, 0:3) ! 32 bits
      integer(kind=ubyte) :: mp(0:7) ! 64 bits
      integer(kind=ubyte) :: e(0:7) ! 64 bits
      integer(kind=ubyte) :: fs(0:3) ! 32 bits
      integer :: i, j

      ! Permute 'message' using table IP
      call permute_bits(mp, message, ip, 64)

      ! Split 'mp' in half and process the resulting series of 'left' and 'right'
      left(0, 0:3) = mp(0:3) ! First 4 bytes (bits 0-31)
      right(0, 0:3) = mp(4:7) ! Next 4 bytes (bits 32-63)

      do i = 1, 16
         left(i, :) = right(i - 1, :)
         call f(pack(right(i - 1, :), .true.), pack(ks(i, :), .true.), fs) !We pack to get contiguous temp arrays
         do j = 0, 3
            left(i - 1, j) = ieor(left(i - 1, j), fs(j))
         end do
         right(i, :) = left(i - 1, :)
      end do

      ! Amalgamate right(16) and left(16) (in that order) into 'e'
      e(0:3) = right(16, 0:3)
      e(4:7) = left(16, 0:3)

      ! Permute 'e' using table IP2 and return result
      call permute_bits(ep, e, ip2, 64)

   end subroutine process_message
   ! Generic bit permutation function - handles any number of bits
   subroutine permute_bits(dst, src, perm_table, num_bits)
      integer(kind=ubyte), intent(out) :: dst(0:)
      integer(kind=ubyte), intent(in) :: src(0:)
      integer(kind=ubyte), intent(in) :: perm_table(0:)
      integer, intent(in) :: num_bits

      integer :: i, src_bit, src_cell, src_pos, dst_cell, dst_pos
      integer :: num_bytes

      ! Clear destination bytes
      num_bytes = (num_bits + 7) / 8
      dst(0:num_bytes - 1) = 0

      do i = 0, num_bits - 1
         src_bit = perm_table(i)

         ! Source bit location using bit operations
         src_cell = ishft(src_bit, -3) ! Divide by 8 using right shift
         src_pos = 7 - iand(src_bit, 7) ! mod 8 using bitwise AND with 7

         ! Destination bit location using bit operations
         dst_cell = ishft(i, -3) ! Divide by 8 using right shift
         dst_pos = 7 - iand(i, 7) ! mod 8 using bitwise AND with 7

         ! Copy bit using direct bit manipulation
         if (btest(src(src_cell), src_pos)) then
            dst(dst_cell) = ibset(dst(dst_cell), dst_pos)
         end if
      end do
   end subroutine permute_bits
   !
   subroutine driver(key, message, length)
      integer(kind=ubyte), intent(in) :: key(0:key_len - 1)
      integer(kind=ubyte), intent(in) :: message(0:)
      integer, intent(in) :: length
      integer(kind=ubyte), allocatable :: encoded_data(:), decoded_data(:)
      integer :: encoded_len, decoded_len
      integer(kind=ubyte) :: ks(0:16, 0:5), pad_byte
      character(len=256) :: buffer
      integer :: i, j
      buffer = ' '
      call print_bytes(key, key_len, buffer)
      print '(a,a)', 'Key     : ', trim(buffer)

      call print_bytes(message, length, buffer)
      print '(a,a)', 'Message : ', trim(buffer)

      ! Encrypt
      call get_sub_keys(key, ks)
      pad_byte = int(8 - iand(length, 7),kind=ubyte) !8 - mod(length, 8)
      encoded_len = length + pad_byte
      allocate(encoded_data(0:encoded_len - 1))

      ! Copy message and add padding
      encoded_data(0:length - 1) = message(0:length - 1)
      encoded_data(length:encoded_len - 1) = pad_byte

      ! Process in 8-byte blocks
      do i = 0, encoded_len - 1, 8
         call process_message(encoded_data(i:i + 7), ks, encoded_data(i:i + 7))
      end do

      call print_bytes(encoded_data, encoded_len, buffer)
      print '(a,a)', 'Encoded : ', trim(buffer)

      ! Decrypt (reverse subkeys for decryption)
      do i = 1, 8
         do j = 0, 5
            call swap_bytes(ks(i, j), ks(17 - i, j))
         end do
      end do

      decoded_len = encoded_len
      allocate(decoded_data(0:decoded_len - 1), source=encoded_data)
      !      decoded_data = encoded_data

      do i = 0, decoded_len - 1, 8
         call process_message(decoded_data(i:i + 7), ks, decoded_data(i:i + 7))
      end do

      ! Remove padding
      pad_byte = decoded_data(decoded_len - 1)
      decoded_len = decoded_len - pad_byte

      call print_bytes(decoded_data, decoded_len, buffer)
      print '(a,a)', 'Decoded : ', trim(buffer)
      print'(A,8a1,/)', 'The secret word is : ', transfer(hex16_to_ubytes(buffer), [character(len=1) ::repeat(' ',8)])

      deallocate(encoded_data, decoded_data)
   end subroutine driver

   subroutine swap_bytes(a, b)
      integer(kind=ubyte), intent(inout) :: a, b
      integer(kind=ubyte) :: temp
      temp = a
      a = b
      b = temp
   end subroutine swap_bytes
end module forsooth

program des_fortran
   use iso_fortran_env
   use forsooth
   implicit none

   message1 = string_to_ubyte('Hannibal')
   call driver(key1, message1, 8)

   message1 = string_to_ubyte('Good Boy')
   call driver(key1, message1, 8)

end program des_fortran

