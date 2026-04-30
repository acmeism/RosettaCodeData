! I didn't have an built sha256 library that I could call so I built a mini-version here for the task
! Uses OPENMP to obtain parallelism
program brute_sha256
   use iso_fortran_env, only: int64, int32
   use omp_lib
   implicit none
   character(len=5) :: pw
   character(len=64) :: hash
   integer :: i1, i2, i3, i4, i5
   real(kind=8) :: start_time, end_time
   character :: letters(26) = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',&
         'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',&
         'u', 'v', 'w', 'x', 'y', 'z']
   character(len=64), parameter :: target1 = '1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad'
   character(len=64), parameter :: target2 = '3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b'
   character(len=64), parameter :: target3 = '74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f'

   start_time = omp_get_wtime()
   !$omp parallel do collapse(5) private(pw, hash, i2, i3, i4, i5) num_threads(16)
   do i1 = 1, 26
      do i2 = 1, 26
         do i3 = 1, 26
            do i4 = 1, 26
               do i5 = 1, 26
                  pw = letters(i1) // letters(i2) // letters(i3) // letters(i4) // letters(i5)
                  hash = sha256(pw)
                  if (hash == target1 .or. hash == target2 .or. hash == target3) then
                     print '(A5,1X,A64)', pw, hash
                  end if
               end do
            end do
         end do
      end do
   end do
   !$omp end parallel do
   end_time = omp_get_wtime()

   print '("Total execution time: ", F10.4, " seconds")', end_time - start_time

contains

   function sha256(message)
      character(len=*), intent(in) :: message
      character(len=64) :: sha256
      integer(kind=int32), parameter :: k(64) = [ &
            int(z'428a2f98', kind=int32), int(z'71374491', kind=int32), int(z'b5c0fbcf', kind=int32), int(z'e9b5dba5', kind=int32), &
            int(z'3956c25b', kind=int32), int(z'59f111f1', kind=int32), int(z'923f82a4', kind=int32), int(z'ab1c5ed5', kind=int32), &
            int(z'd807aa98', kind=int32), int(z'12835b01', kind=int32), int(z'243185be', kind=int32), int(z'550c7dc3', kind=int32), &
            int(z'72be5d74', kind=int32), int(z'80deb1fe', kind=int32), int(z'9bdc06a7', kind=int32), int(z'c19bf174', kind=int32), &
            int(z'e49b69c1', kind=int32), int(z'efbe4786', kind=int32), int(z'0fc19dc6', kind=int32), int(z'240ca1cc', kind=int32), &
            int(z'2de92c6f', kind=int32), int(z'4a7484aa', kind=int32), int(z'5cb0a9dc', kind=int32), int(z'76f988da', kind=int32), &
            int(z'983e5152', kind=int32), int(z'a831c66d', kind=int32), int(z'b00327c8', kind=int32), int(z'bf597fc7', kind=int32), &
            int(z'c6e00bf3', kind=int32), int(z'd5a79147', kind=int32), int(z'06ca6351', kind=int32), int(z'14292967', kind=int32), &
            int(z'27b70a85', kind=int32), int(z'2e1b2138', kind=int32), int(z'4d2c6dfc', kind=int32), int(z'53380d13', kind=int32), &
            int(z'650a7354', kind=int32), int(z'766a0abb', kind=int32), int(z'81c2c92e', kind=int32), int(z'92722c85', kind=int32), &
            int(z'a2bfe8a1', kind=int32), int(z'a81a664b', kind=int32), int(z'c24b8b70', kind=int32), int(z'c76c51a3', kind=int32), &
            int(z'd192e819', kind=int32), int(z'd6990624', kind=int32), int(z'f40e3585', kind=int32), int(z'106aa070', kind=int32), &
            int(z'19a4c116', kind=int32), int(z'1e376c08', kind=int32), int(z'2748774c', kind=int32), int(z'34b0bcb5', kind=int32), &
            int(z'391c0cb3', kind=int32), int(z'4ed8aa4a', kind=int32), int(z'5b9cca4f', kind=int32), int(z'682e6ff3', kind=int32), &
            int(z'748f82ee', kind=int32), int(z'78a5636f', kind=int32), int(z'84c87814', kind=int32), int(z'8cc70208', kind=int32), &
            int(z'90befffa', kind=int32), int(z'a4506ceb', kind=int32), int(z'bef9a3f7', kind=int32), int(z'c67178f2', kind=int32) ]

      integer(kind=int32), parameter :: h_init(8) = [ &
            int(z'6a09e667', kind=int32), int(z'bb67ae85', kind=int32), int(z'3c6ef372', kind=int32), int(z'a54ff53a', kind=int32), &
            int(z'510e527f', kind=int32), int(z'9b05688c', kind=int32), int(z'1f83d9ab', kind=int32), int(z'5be0cd19', kind=int32) ]

      integer(kind=int64), parameter :: ff = int(z'ffffffff', kind=int64)

      character(len=:), allocatable :: padded
      integer(kind=int64) :: bitlen
      integer :: len_msg, padlen, i, j
      integer(kind=int32) :: h(8), w(64), a, b, c, d, e, f, g, hh_temp
      integer(kind=int32) :: t1, t2, s0, s1, ch, maj

      character(len=1), parameter :: hex(16) = [ &
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', &
            'a', 'b', 'c', 'd', 'e', 'f' ]

      len_msg = len(message)
      bitlen = int(len_msg, int64) * 8_int64
      if (mod(len_msg, 64) < 56) then
         padlen = 55 - mod(len_msg, 64)
      else
         padlen = 119 - mod(len_msg, 64)
      end if
      padded = message // char(128) // repeat(char(0), padlen) // int64_to_be(bitlen)
      h = h_init

      ! Since 5 letters, only one block
      w(1:16) = [(char_to_int32(padded((j - 1) * 4 + 1 : (j - 1) * 4 + 4)), j = 1, 16) ]

      do j = 17, 64
         s0 = ieor(ishftc(w(j - 15), -7, 32), &
               ieor(ishftc(w(j - 15), -18, 32), ishft(w(j - 15), -3)))

         s1 = ieor(ishftc(w(j - 2), -17, 32), &
               ieor(ishftc(w(j - 2), -19, 32), ishft(w(j - 2), -10)))

         w(j) = w(j - 16) + s0 + w(j - 7) + s1
      end do

      a = h(1)
      b = h(2)
      c = h(3)
      d = h(4)
      e = h(5)
      f = h(6)
      g = h(7)
      hh_temp = h(8)

      do i = 1, 64
         s1 = ieor(ishftc(e, -6, 32), ieor(ishftc(e, -11, 32), ishftc(e, -25, 32)))
         ch = ieor(iand(e, f), iand(not(e), g))
         t1 = int(iand(int(hh_temp, int64) + int(s1, int64) + int(ch, int64) + int(k(i), int64) + int(w(i), int64), ff))
         s0 = ieor(ishftc(a, -2, 32), ieor(ishftc(a, -13, 32), ishftc(a, -22, 32)))
         maj = ieor(iand(a, b), ieor(iand(a, c), iand(b, c)))
         t2 = int(iand(int(s0, int64) + int(maj, int64), ff))

         hh_temp = g
         g = f
         f = e
         e = int(iand(int(d, int64) + int(t1, int64), ff))
         d = c
         c = b
         b = a
         a = int(iand(int(t1, int64) + int(t2, int64), ff))
      end do

      h(1) = int(iand(int(h(1), int64) + int(a, int64), ff))
      h(2) = int(iand(int(h(2), int64) + int(b, int64), ff))
      h(3) = int(iand(int(h(3), int64) + int(c, int64), ff))
      h(4) = int(iand(int(h(4), int64) + int(d, int64), ff))
      h(5) = int(iand(int(h(5), int64) + int(e, int64), ff))
      h(6) = int(iand(int(h(6), int64) + int(f, int64), ff))
      h(7) = int(iand(int(h(7), int64) + int(g, int64), ff))
      h(8) = int(iand(int(h(8), int64) + int(hh_temp, int64), ff))

      sha256 = ''
      !      do i = 1, 8
      !         write(temp, '(z8.8)') h(i)
      !         sha256((i - 1) * 8 + 1:i * 8) = to_lower(temp)
      !      end do
      block
         integer :: i, j, nibble, pos
         do i = 1, 8
            pos = (i - 1) * 8
            do j = 0, 7
               ! shift word right by (7–j)*4 bits, mask lower 4 bits
               nibble = iand(ishft(h(i), -4 * (7 - j)), z'F')
               ! pick the hex character
               sha256(pos + j + 1:pos + j + 1) = hex(nibble + 1)
            end do
         end do
      end block
   end function sha256

   pure function int64_to_be(n) result(bytes_be)
      use iso_fortran_env
      integer, parameter :: kind_int = kind(iachar('A'))
      integer(kind=int64), intent(in) :: n
      character(len=8) :: bytes_be
      integer(kind=int8), dimension(8) :: raw_bytes

      ! 1) Reinterpret the 64-bit integer as 8 raw bytes (native endianness)
      raw_bytes = transfer(n, raw_bytes)

      ! 2) Reverse them to get big-endian ordering
      bytes_be(1:1) = achar(int(raw_bytes(8), kind=kind_int))
      bytes_be(2:2) = achar(int(raw_bytes(7), kind=kind_int))
      bytes_be(3:3) = achar(int(raw_bytes(6), kind=kind_int))
      bytes_be(4:4) = achar(int(raw_bytes(5), kind=kind_int))
      bytes_be(5:5) = achar(int(raw_bytes(4), kind=kind_int))
      bytes_be(6:6) = achar(int(raw_bytes(3), kind=kind_int))
      bytes_be(7:7) = achar(int(raw_bytes(2), kind=kind_int))
      bytes_be(8:8) = achar(int(raw_bytes(1), kind=kind_int))

   end function int64_to_be
   !
   pure elemental function char_to_int32(ch) result(res)
      character(len=4), intent(in) :: ch
      integer(kind=int32) :: res

      ! Extract each byte, shift it into position, then OR them together
      res = ior(ishft(int(iachar(ch(1:1)), kind=int32), 24), &
            ior(ishft(int(iachar(ch(2:2)), kind=int32), 16), &
            ior(ishft(int(iachar(ch(3:3)), kind=int32), 8), &
            int(iachar(ch(4:4)), kind=int32))))
   end function char_to_int32

end program brute_sha256
