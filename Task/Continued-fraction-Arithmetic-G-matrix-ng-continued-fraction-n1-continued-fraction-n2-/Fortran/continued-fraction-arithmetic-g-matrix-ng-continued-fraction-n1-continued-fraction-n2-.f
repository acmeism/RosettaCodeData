!---------------------------------------------------------------------

module big_integers             ! Big (but not very big) integers.

  ! NOTE: I assume that iachar and achar do not alter the most
  !       significant bit.

  use, intrinsic :: iso_fortran_env, only: int16
  implicit none
  private

  public :: big_integer
  public :: integer2big
  public :: string2big
  public :: big2string
  public :: big_sgn
  public :: big_cmp, big_cmpabs
  public :: big_neg, big_abs
  public :: big_addabs, big_add
  public :: big_subabs, big_sub
  public :: big_mul      ! One might also include a big_muladd.
  public :: big_divrem   ! One could also include big_div and big_rem.
  public :: operator(+)
  public :: operator(-)
  public :: operator(*)

  type :: big_integer
     ! The representation is sign-magnitude. The radix is 256, which
     ! is not speed-efficient, but which seemed relatively easy to
     ! work with if one were writing in standard Fortran (and assuming
     ! iachar and achar were "8-bit clean").
     logical :: sign = .false.  ! .false. => +sign, .true. => -sign.
     character, allocatable :: bytes(:)
  end type big_integer

  character, parameter :: zero = achar (0)
  character, parameter :: one = achar (1)

  ! An integer type capable of holding an unsigned 8-bit value.
  integer, parameter :: bytekind = int16

  interface operator(+)
     module procedure big_add
  end interface

  interface operator(-)
     module procedure big_neg
     module procedure big_sub
  end interface

  interface operator(*)
     module procedure big_mul
  end interface

contains

  elemental function logical2byte (bool) result (byte)
    logical, intent(in) :: bool
    character :: byte
    if (bool) then
       byte = one
    else
       byte = zero
    end if
  end function logical2byte

  elemental function logical2i (bool) result (i)
    logical, intent(in) :: bool
    integer :: i
    if (bool) then
       i = 1
    else
       i = 0
    end if
  end function logical2i

  elemental function byte2i (c) result (i)
    character, intent(in) :: c
    integer :: i
    i = iachar (c)
  end function byte2i

  elemental function i2byte (i) result (c)
    integer, intent(in) :: i
    character :: c
    c = achar (i)
  end function i2byte

  elemental function byte2bk (c) result (i)
    character, intent(in) :: c
    integer(bytekind) :: i
    i = iachar (c, kind = bytekind)
  end function byte2bk

  elemental function bk2byte (i) result (c)
    integer(bytekind), intent(in) :: i
    character :: c
    c = achar (i)
  end function bk2byte

  elemental function bk2i (i) result (j)
    integer(bytekind), intent(in) :: i
    integer :: j
    j = int (i)
  end function bk2i

  elemental function i2bk (i) result (j)
    integer, intent(in) :: i
    integer(bytekind) :: j
    j = int (iand (i, 255), kind = bytekind)
  end function i2bk

  ! Left shift of the least significant 8 bits of a bytekind integer.
  elemental function lshftbk (a, i) result (c)
    integer(bytekind), intent(in) :: a
    integer, intent(in) :: i
    integer(bytekind) :: c
    c = ishft (ibits (a, 0, 8 - i), i)
  end function lshftbk

  ! Right shift of the least significant 8 bits of a bytekind integer.
  elemental function rshftbk (a, i) result (c)
    integer(bytekind), intent(in) :: a
    integer, intent(in) :: i
    integer(bytekind) :: c
    c = ibits (a, i, 8 - i)
  end function rshftbk

  ! Left shift an integer.
  elemental function lshfti (a, i) result (c)
    integer, intent(in) :: a
    integer, intent(in) :: i
    integer :: c
    c = ishft (a, i)
  end function lshfti

  ! Right shift an integer.
  elemental function rshfti (a, i) result (c)
    integer, intent(in) :: a
    integer, intent(in) :: i
    integer :: c
    c = ishft (a, -i)
  end function rshfti

  function integer2big (i) result (a)
    integer, intent(in) :: i
    type(big_integer), allocatable :: a

    !
    ! To write a more efficient implementation of this procedure is
    ! left as an exercise for the reader.
    !

    character(len = 100) :: buffer

    write (buffer, '(I0)') i
    a = string2big (trim (buffer))
  end function integer2big

  function string2big (s) result (a)
    character(len = *), intent(in) :: s
    type(big_integer), allocatable :: a

    integer :: n, i, istart, iend
    integer :: digit

    if ((s(1:1) == '-') .or. s(1:1) == '+') then
       istart = 2
    else
       istart = 1
    end if

    iend = len (s)

    n = (iend - istart + 2) / 2

    allocate (a)
    allocate (a%bytes(n))

    a%bytes = zero
    do i = istart, iend
       digit = ichar (s(i:i)) - ichar ('0')
       if (digit < 0 .or. 9 < digit) error stop
       a = short_multiplication (a, 10)
       a = short_addition (a, digit)
    end do
    a%sign = (s(1:1) == '-')
    call normalize (a)
  end function string2big

  function big2string (a) result (s)
    type(big_integer), intent(in) :: a
    character(len = :), allocatable :: s

    type(big_integer), allocatable :: q
    integer :: r
    integer :: sgn

    sgn = big_sgn (a)
    if (sgn == 0) then
       s = '0'
    else
       q = a
       s = ''
       do while (big_sgn (q) /= 0)
          call short_division (q, 10, q, r)
          s = achar (r + ichar ('0')) // s
       end do
       if (sgn < 0) s = '-' // s
    end if
  end function big2string

  function big_sgn (a) result (sgn)
    type(big_integer), intent(in) :: a
    integer :: sgn

    integer :: n, i

    n = size (a%bytes)
    i = 1
    sgn = 1234
    do while (sgn == 1234)
       if (i == n + 1) then
          sgn = 0
       else if (a%bytes(i) /= zero) then
          if (a%sign) then
             sgn = -1
          else
             sgn = 1
          end if
       else
          i = i + 1
       end if
    end do
  end function big_sgn

  function big_cmp (a, b) result (cmp)
    type(big_integer(*)), intent(in) :: a, b
    integer :: cmp

    if (a%sign) then
       if (b%sign) then
          cmp = -big_cmpabs (a, b)
       else
          cmp = -1
       end if
    else
       if (b%sign) then
          cmp = 1
       else
          cmp = big_cmpabs (a, b)
       end if
    end if
  end function big_cmp

  function big_cmpabs (a, b) result (cmp)
    type(big_integer(*)), intent(in) :: a, b
    integer :: cmp

    integer :: n, i
    integer :: ia, ib

    cmp = 1234
    n = max (size (a%bytes), size (b%bytes))
    i = n
    do while (cmp == 1234)
       if (i == 0) then
          cmp = 0
       else
          ia = byteval (a, i)
          ib = byteval (b, i)
          if (ia < ib) then
             cmp = -1
          else if (ia > ib) then
             cmp = 1
          else
             i = i - 1
          end if
       end if
    end do
  end function big_cmpabs

  function big_neg (a) result (c)
    type(big_integer), intent(in) :: a
    type(big_integer), allocatable :: c
    c = a
    c%sign = .not. c%sign
  end function big_neg

  function big_abs (a) result (c)
    type(big_integer), intent(in) :: a
    type(big_integer), allocatable :: c
    c = a
    c%sign = .false.
  end function big_abs

  function big_add (a, b) result (c)
    type(big_integer), intent(in) :: a
    type(big_integer), intent(in) :: b
    type(big_integer), allocatable :: c

    logical :: sign

    if (a%sign) then
       if (b%sign) then      ! a <= 0, b <= 0
          c = big_addabs (a, b)
          sign = .true.
       else                  ! a <= 0, b >= 0
          c = big_subabs (a, b)
          sign = .not. c%sign
       end if
    else
       if (b%sign) then      ! a >= 0, b <= 0
          c = big_subabs (a, b)
          sign = c%sign
       else                  ! a >= 0, b >= 0
          c = big_addabs (a, b)
          sign = .false.
       end if
    end if
    c%sign = sign
  end function big_add

  function big_sub (a, b) result (c)
    type(big_integer), intent(in) :: a
    type(big_integer), intent(in) :: b
    type(big_integer), allocatable :: c

    logical :: sign

    if (a%sign) then
       if (b%sign) then      ! a <= 0, b <= 0
          c = big_subabs (a, b)
          sign = .not. c%sign
       else                  ! a <= 0, b >= 0
          c = big_addabs (a, b)
          sign = .true.
       end if
    else
       if (b%sign) then      ! a >= 0, b <= 0
          c = big_addabs (a, b)
          sign = .false.
       else                  ! a >= 0, b >= 0
          c = big_subabs (a, b)
          sign = c%sign
       end if
    end if
    c%sign = sign
  end function big_sub

  function big_addabs (a, b) result (c)
    type(big_integer), intent(in) :: a, b
    type(big_integer), allocatable :: c

    ! Compute abs(a) + abs(b).

    integer :: n, nc, i
    logical :: carry
    type(big_integer), allocatable :: tmp

    n = max (size (a%bytes), size (b%bytes))
    nc = n + 1

    allocate(tmp)
    allocate(tmp%bytes(nc))

    call add_bytes (get_byte (a, 1), get_byte (b, 1), .false., tmp%bytes(1), carry)
    do i = 2, n
       call add_bytes (get_byte (a, i), get_byte (b, i), carry, tmp%bytes(i), carry)
    end do
    tmp%bytes(nc) = logical2byte (carry)
    call normalize (tmp)
    c = tmp
  end function big_addabs

  function big_subabs (a, b) result (c)
    type(big_integer), intent(in) :: a, b
    type(big_integer), allocatable :: c

    ! Compute abs(a) - abs(b). The result is signed.

    integer :: n, i
    logical :: carry
    type(big_integer), allocatable :: tmp

    n = max (size (a%bytes), size (b%bytes))
    allocate(tmp)
    allocate(tmp%bytes(n))

    if (big_cmpabs (a, b) >= 0) then
       tmp%sign = .false.
       call sub_bytes (get_byte (a, 1), get_byte (b, 1), .false., tmp%bytes(1), carry)
       do i = 2, n
          call sub_bytes (get_byte (a, i), get_byte (b, i), carry, tmp%bytes(i), carry)
       end do
    else
       tmp%sign = .true.
       call sub_bytes (get_byte (b, 1), get_byte (a, 1), .false., tmp%bytes(1), carry)
       do i = 2, n
          call sub_bytes (get_byte (b, i), get_byte (a, i), carry, tmp%bytes(i), carry)
       end do
    end if
    call normalize (tmp)
    c = tmp
  end function big_subabs

  function big_mul (a, b) result (c)
    type(big_integer), intent(in) :: a, b
    type(big_integer), allocatable :: c

    !
    ! This is Knuth, Volume 2, Algorithm 4.3.1M.
    !

    integer :: na, nb, nc
    integer :: i, j
    integer :: ia, ib, ic
    integer :: carry
    type(big_integer), allocatable :: tmp

    na = size (a%bytes)
    nb = size (b%bytes)
    nc = na + nb + 1

    allocate (tmp)
    allocate (tmp%bytes(nc))

    tmp%bytes = zero
    j = 1
    do j = 1, nb
       ib = byte2i (b%bytes(j))
       if (ib /= 0) then
          carry = 0
          do i = 1, na
             ia = byte2i (a%bytes(i))
             ic = byte2i (tmp%bytes(i + j - 1))
             ic = (ia * ib) + ic + carry
             tmp%bytes(i + j - 1) = i2byte (iand (ic, 255))
             carry = ishft (ic, -8)
          end do
          tmp%bytes(na + j) = i2byte (carry)
       end if
    end do
    tmp%sign = (a%sign .neqv. b%sign)
    call normalize (tmp)
    c = tmp
  end function big_mul

  subroutine big_divrem (a, b, q, r)
    type(big_integer), intent(in) :: a, b
    type(big_integer), allocatable, intent(inout) :: q, r

    !
    ! Division with a remainder that is never negative. Equivalently,
    ! this is floor division if the divisor is positive, and ceiling
    ! division if the divisor is negative.
    !
    ! See Raymond T. Boute, "The Euclidean definition of the functions
    ! div and mod", ACM Transactions on Programming Languages and
    ! Systems, Volume 14, Issue 2, pp. 127-144.
    ! https://doi.org/10.1145/128861.128862
    !

    call nonnegative_division (a, b, .true., .true., q, r)
    if (a%sign) then
       if (big_sgn (r) /= 0) then
          q = short_addition (q, 1)
          r = big_sub (big_abs (b), r)
       end if
       q%sign = .not. b%sign
    else
       q%sign = b%sign
    end if
  end subroutine big_divrem

  function short_addition (a, b) result (c)
    type(big_integer), intent(in) :: a
    integer, intent(in) :: b
    type(big_integer), allocatable :: c

    ! Compute abs(a) + b.

    integer :: na, nc, i
    logical :: carry
    type(big_integer), allocatable :: tmp

    na = size (a%bytes)
    nc = na + 1

    allocate(tmp)
    allocate(tmp%bytes(nc))

    call add_bytes (a%bytes(1), i2byte (b), .false., tmp%bytes(1), carry)
    do i = 2, na
       call add_bytes (a%bytes(i), zero, carry, tmp%bytes(i), carry)
    end do
    tmp%bytes(nc) = logical2byte (carry)
    call normalize (tmp)
    c = tmp
  end function short_addition

  function short_multiplication (a, b) result (c)
    type(big_integer), intent(in) :: a
    integer, intent(in) :: b
    type(big_integer), allocatable :: c

    integer :: i, na, nc
    integer :: ia, ic
    integer :: carry
    type(big_integer), allocatable :: tmp

    na = size (a%bytes)
    nc = na + 1

    allocate (tmp)
    allocate (tmp%bytes(nc))

    tmp%sign = a%sign
    carry = 0
    do i = 1, na
       ia = byte2i (a%bytes(i))
       ic = (ia * b) + carry
       tmp%bytes(i) = i2byte (iand (ic, 255))
       carry = ishft (ic, -8)
    end do
    tmp%bytes(nc) = i2byte (carry)
    call normalize (tmp)
    c = tmp
  end function short_multiplication

  ! Division without regard to signs.
  subroutine nonnegative_division (a, b, want_q, want_r, q, r)
    type(big_integer), intent(in) :: a, b
    logical, intent(in) :: want_q, want_r
    type(big_integer), intent(inout), allocatable :: q, r

    integer :: na, nb
    integer :: remainder

    na = size (a%bytes)
    nb = size (b%bytes)

    ! It is an error if b has "significant" zero-bytes or is equal to
    ! zero.
    if (b%bytes(nb) == zero) error stop

    if (nb == 1) then
       if (want_q) then
          call short_division (a, byte2i (b%bytes(1)), q, remainder)
       else
          block
            type(big_integer), allocatable :: bit_bucket
            call short_division (a, byte2i (b%bytes(1)), bit_bucket, remainder)
          end block
       end if
       if (want_r) then
          if (allocated (r)) deallocate (r)
          allocate (r)
          allocate (r%bytes(1))
          r%bytes(1) = i2byte (remainder)
       end if
    else
       if (na >= nb) then
          call long_division (a, b, want_q, want_r, q, r)
       else
          if (want_q) q = string2big ("0")
          if (want_r) r = a
       end if
    end if
  end subroutine nonnegative_division

  subroutine short_division (a, b, q, r)
    type(big_integer), intent(in) :: a
    integer, intent(in) :: b
    type(big_integer), intent(inout), allocatable :: q
    integer, intent(inout) :: r

    !
    ! This is Knuth, Volume 2, Exercise 4.3.1.16.
    !
    ! The divisor is assumed to be positive.
    !

    integer :: n, i
    integer :: ia, ib, iq
    type(big_integer), allocatable :: tmp

    ib = b
    n = size (a%bytes)

    allocate (tmp)
    allocate (tmp%bytes(n))

    r = 0
    do i = n, 1, -1
       ia = (256 * r) + byte2i (a%bytes(i))
       iq = ia / ib
       r = mod (ia, ib)
       tmp%bytes(i) = i2byte (iq)
    end do
    tmp%sign = a%sign
    call normalize (tmp)
    q = tmp
  end subroutine short_division

  subroutine long_division (a, b, want_quotient, want_remainder, quotient, remainder)
    type(big_integer), intent(in) :: a, b
    logical, intent(in) :: want_quotient, want_remainder
    type(big_integer), intent(inout), allocatable :: quotient
    type(big_integer), intent(inout), allocatable :: remainder

    !
    ! This is Knuth, Volume 2, Algorithm 4.3.1D.
    !
    ! We do not deal here with the signs of the inputs and outputs.
    !
    ! It is assumed size(a%bytes) >= size(b%bytes), and that b has no
    ! leading zero-bytes and is at least two bytes long. If b is one
    ! byte long and nonzero, use short division.
    !

    integer :: na, nb, m, n
    integer :: num_lz, num_nonlz
    integer :: j
    integer :: qhat
    logical :: carry

    !
    ! We will NOT be working with VERY large numbers, and so it will
    ! be safe to put temporary storage on the stack. (Note: your
    ! Fortran might put this storage in a heap instead of the stack.)
    !
    !    v = b, normalized to put its most significant 1-bit all the
    !           way left.
    !
    !    u = a, shifted left by the same amount as b.
    !
    !    q = the quotient.
    !
    ! The remainder, although shifted left, will end up in u.
    !
    integer(bytekind) :: u(0:size (a%bytes) + size (b%bytes))
    integer(bytekind) :: v(0:size (b%bytes) - 1)
    integer(bytekind) :: q(0:size (a%bytes) - size (b%bytes))

    na = size (a%bytes)
    nb = size (b%bytes)

    n = nb
    m = na - nb

    ! In the most significant byte of the divisor, find the number of
    ! leading zero bits, and the number of bits after that.
    block
      integer(bytekind) :: tmp
      tmp = byte2bk (b%bytes(n))
      num_nonlz = bit_size (tmp) - leadz (tmp)
      num_lz = 8 - num_nonlz
    end block

    call normalize_v (b%bytes) ! Make the most significant bit of v be one.
    call normalize_u (a%bytes) ! Shifted by the same amount as v.

    ! Assure ourselves that the most significant bit of v is a one.
    if (.not. btest (v(n - 1), 7)) error stop

    do j = m, 0, -1
       call calculate_qhat (qhat)
       call multiply_and_subtract (carry)
       q(j) = i2bk (qhat)
       if (carry) call add_back
    end do

    if (want_quotient) then
       if (allocated (quotient)) deallocate (quotient)
       allocate (quotient)
       allocate (quotient%bytes(m + 1))
       quotient%bytes = bk2byte (q)
       call normalize (quotient)
    end if

    if (want_remainder) then
       if (allocated (remainder)) deallocate (remainder)
       allocate (remainder)
       allocate (remainder%bytes(n))
       call unnormalize_u (remainder%bytes)
       call normalize (remainder)
    end if

  contains

    subroutine normalize_v (b_bytes)
      character, intent(in) :: b_bytes(n)

      !
      ! Normalize v so its most significant bit is a one. Any
      ! normalization factor that achieves this goal will suffice; we
      ! choose 2**num_lz. (Knuth uses (2**32) div (y[n-1] + 1).)
      !
      ! Strictly for readability, we use linear stack space for an
      ! intermediate result.
      !

      integer :: i
      integer(bytekind) :: btmp(0:n - 1)

      btmp = byte2bk (b_bytes)

      v(0) = lshftbk (btmp(0), num_lz)
      do i = 1, n - 1
         v(i) = ior (lshftbk (btmp(i), num_lz), &
              &      rshftbk (btmp(i - 1), num_nonlz))
      end do
    end subroutine normalize_v

    subroutine normalize_u (a_bytes)
      character, intent(in) :: a_bytes(m + n)

      !
      ! Shift a leftwards to get u. Shift by as much as b was shifted
      ! to get v.
      !
      ! Strictly for readability, we use linear stack space for an
      ! intermediate result.
      !

      integer :: i
      integer(bytekind) :: atmp(0:m + n - 1)

      atmp = byte2bk (a_bytes)

      u(0) = lshftbk (atmp(0), num_lz)
      do i = 1, m + n - 1
         u(i) = ior (lshftbk (atmp(i), num_lz), &
              &      rshftbk (atmp(i - 1), num_nonlz))
      end do
      u(m + n) = rshftbk (atmp(m + n - 1), num_nonlz)
    end subroutine normalize_u

    subroutine unnormalize_u (r_bytes)
      character, intent(out) :: r_bytes(n)

      !
      ! Strictly for readability, we use linear stack space for an
      ! intermediate result.
      !

      integer :: i
      integer(bytekind) :: rtmp(0:n - 1)

      do i = 0, n - 1
         rtmp(i) = ior (rshftbk (u(i), num_lz), &
              &         lshftbk (u(i + 1), num_nonlz))
      end do
      rtmp(n - 1) = rshftbk (u(n - 1), num_lz)

      r_bytes = bk2byte (rtmp)
    end subroutine unnormalize_u

    subroutine calculate_qhat (qhat)
      integer, intent(out) :: qhat

      integer :: itmp, rhat
      logical :: adjust

      itmp = ior (lshfti (bk2i (u(j + n)), 8), &
           &      bk2i (u(j + n - 1)))
      qhat = itmp / bk2i (v(n - 1))
      rhat = mod (itmp, bk2i (v(n - 1)))
      adjust = .true.
      do while (adjust)
         if (rshfti (qhat, 8) /= 0) then
            continue
         else if (qhat * bk2i (v(n - 2)) &
              &     > ior (lshfti (rhat, 8), &
              &            bk2i (u(j + n - 2)))) then
            continue
         else
            adjust = .false.
         end if
         if (adjust) then
            qhat = qhat - 1
            rhat = rhat + bk2i (v(n - 1))
            if (rshfti (rhat, 8) == 0) then
               adjust = .false.
            end if
         end if
      end do
    end subroutine calculate_qhat

    subroutine multiply_and_subtract (carry)
      logical, intent(out) :: carry

      integer :: i
      integer :: qhat_v
      integer :: mul_carry, sub_carry
      integer :: diff

      mul_carry = 0
      sub_carry = 0
      do i = 0, n
         ! Multiplication.
         qhat_v = mul_carry
         if (i /= n) qhat_v = qhat_v + (qhat * bk2i (v(i)))
         mul_carry = rshfti (qhat_v, 8)
         qhat_v = iand (qhat_v, 255)

         ! Subtraction.
         diff = bk2i (u(j + i)) - qhat_v + sub_carry
         sub_carry = -(logical2i (diff < 0)) ! Carry 0 or -1.
         u(j + i) = i2bk (diff)
      end do
      carry = (sub_carry /= 0)
    end subroutine multiply_and_subtract

    subroutine add_back
      integer :: i, carry, sum

      q(j) = q(j) - 1_bytekind
      carry = 0
      do i = 0, n - 1
         sum = bk2i (u(j + i)) + bk2i (v(i)) + carry
         carry = ishft (sum, -8)
         u(j + i) = i2bk (sum)
      end do
    end subroutine add_back

  end subroutine long_division

  subroutine add_bytes (a, b, carry_in, c, carry_out)
    character, intent(in) :: a, b
    logical, value :: carry_in
    character, intent(inout) :: c
    logical, intent(inout) :: carry_out

    integer :: ia, ib, ic

    ia = byte2i (a)
    if (carry_in) ia = ia + 1
    ib = byte2i (b)
    ic = ia + ib
    c = i2byte (iand (ic, 255))
    carry_out = (ic >= 256)
  end subroutine add_bytes

  subroutine sub_bytes (a, b, carry_in, c, carry_out)
    character, intent(in) :: a, b
    logical, value :: carry_in
    character, intent(inout) :: c
    logical, intent(inout) :: carry_out

    integer :: ia, ib, ic

    ia = byte2i (a)
    ib = byte2i (b)
    if (carry_in) ib = ib + 1
    ic = ia - ib
    carry_out = (ic < 0)
    if (carry_out) ic = ic + 256
    c = i2byte (iand (ic, 255))
  end subroutine sub_bytes

  function get_byte (a, i) result (byte)
    type(big_integer), intent(in) :: a
    integer, intent(in) :: i
    character :: byte

    if (size (a%bytes) < i) then
       byte = zero
    else
       byte = a%bytes(i)
    end if
  end function get_byte

  function byteval (a, i) result (v)
    type(big_integer), intent(in) :: a
    integer, intent(in) :: i
    integer :: v

    if (size (a%bytes) < i) then
       v = 0
    else
       v = byte2i (a%bytes(i))
    end if
  end function byteval

  subroutine normalize (a)
    type(big_integer), intent(inout) :: a

    logical :: done
    integer :: i
    character, allocatable :: fewer_bytes(:)

    ! Shorten to the minimum number of bytes.
    i = size (a%bytes)
    done = .false.
    do while (.not. done)
       if (i == 1) then
          done = .true.
       else if (a%bytes(i) /= zero) then
          done = .true.
       else
          i = i - 1
       end if
    end do
    if (i /= size (a%bytes)) then
       allocate (fewer_bytes (i))
       fewer_bytes = a%bytes(1:i)
       call move_alloc (fewer_bytes, a%bytes)
    end if

    ! If the magnitude is zero, then clear the sign bit.
    if (size (a%bytes) == 1) then
       if (a%bytes(1) == zero) then
          a%sign = .false.
       end if
    end if
  end subroutine normalize

end module big_integers

!---------------------------------------------------------------------

module continued_fractions

  use, non_intrinsic :: big_integers
  implicit none
  private

  public :: continued_fraction

  public :: term_generator
  public :: term_generator_procedure

  public :: make_continued_fraction

  public :: i2cf
  public :: make_integer_continued_fraction
  public :: make_integer_continued_fraction_from_integer

  public :: constant_term_cf
  public :: make_constant_term_continued_fraction
  public :: make_constant_term_continued_fraction_from_integer

  public :: apply_ng8
  public :: apply_ng8_big_integers
  public :: apply_ng8_integers
  public :: ng8_coefficient_threshold
  public :: ng8_term_threshold

  public :: add_continued_fractions
  public :: subtract_continued_fractions
  public :: multiply_continued_fractions
  public :: divide_continued_fractions

  public :: cf2string
  public :: continued_fraction_to_string_given_max_terms
  public :: continued_fraction_to_string_with_default_max_terms
  public :: default_continued_fraction_max_terms

  type :: continued_fraction

     class(continued_fraction_record), pointer, private :: p => null ()

   contains

     procedure, pass :: get_term => get_continued_fraction_term
     procedure, pass :: term_exists => continued_fraction_term_exists
     procedure, pass :: term => continued_fraction_term

     procedure, pass :: to_string => continued_fraction_to_string_with_default_max_terms

     procedure, pass :: add => add_continued_fractions
     generic :: operator(+) => add

     procedure, pass :: subtract => subtract_continued_fractions
     generic :: operator(-) => subtract

     procedure, pass :: multiply => multiply_continued_fractions
     generic :: operator(*) => multiply

     procedure, pass :: divide => divide_continued_fractions
     generic :: operator(/) => divide

     procedure, pass, private :: continued_fraction_make_new_ref
     generic :: assignment(=) => continued_fraction_make_new_ref

     final :: continued_fraction_final

  end type continued_fraction

  type :: continued_fraction_record
     logical, private :: terminated = .false. ! No more terms?
     integer, private :: m = 0                ! No. of terms memoized.
     type(big_integer), private, allocatable :: memo(:) ! Memoized terms.
     class(term_generator), pointer :: gen ! Where terms come from.
     integer :: refcount = 0
   contains
     procedure, pass :: get_term => get_continued_fraction_record_term
     procedure, pass :: term_exists => continued_fraction_record_term_exists
     procedure, pass :: term => continued_fraction_record_term
     final :: continued_fraction_record_final
  end type continued_fraction_record

  type, abstract :: term_generator
   contains
     procedure(term_generator_procedure), pass, deferred :: generate
  end type term_generator

  interface
     subroutine term_generator_procedure (gen, term_exists, term)
       import term_generator
       import big_integer
       class(term_generator), intent(inout) :: gen
       logical, intent(out) :: term_exists
       type(big_integer), allocatable, intent(out) :: term
     end subroutine term_generator_procedure
  end interface

  type, extends (term_generator) :: integer_term_generator
     type(big_integer), allocatable :: term
     logical :: no_more_terms = .false.
   contains
     procedure, pass :: generate => integer_term_generator_generate
  end type integer_term_generator

  type, extends (term_generator) :: constant_term_generator
     type(big_integer), allocatable :: term
   contains
     procedure, pass :: generate => constant_term_generator_generate
  end type constant_term_generator

  type, extends (term_generator) :: ng8_term_generator
     type(big_integer), allocatable :: a12, a1, a2, a
     type(big_integer), allocatable :: b12, b1, b2, b
     type(continued_fraction) :: x, y
     integer :: ix = 0
     integer :: iy = 0
     logical :: x_overflow = .false.
     logical :: y_overflow = .false.
   contains
     procedure, pass :: generate => ng8_term_generator_generate
  end type ng8_term_generator

  interface i2cf
     module procedure make_integer_continued_fraction
     module procedure make_integer_continued_fraction_from_integer
  end interface i2cf

  interface constant_term_cf
     module procedure make_constant_term_continued_fraction
     module procedure make_constant_term_continued_fraction_from_integer
  end interface constant_term_cf

  interface apply_ng8
     module procedure apply_ng8_big_integers
     module procedure apply_ng8_integers
  end interface apply_ng8

  interface cf2string
    module procedure continued_fraction_to_string_given_max_terms
    module procedure continued_fraction_to_string_with_default_max_terms
  end interface cf2string

  integer :: default_continued_fraction_max_terms = 20

  type(big_integer), allocatable :: ng8_coefficient_threshold
  type(big_integer), allocatable :: ng8_term_threshold

contains

  subroutine continued_fraction_make_new_ref (dst, src)
    class(continued_fraction), intent(inout) :: dst
    class(continued_fraction), intent(in) :: src

    if (associated (dst%p)) deallocate (dst%p)
    dst%p => src%p
    dst%p%refcount = dst%p%refcount + 1
  end subroutine continued_fraction_make_new_ref

  subroutine continued_fraction_final (cf)
    type(continued_fraction), intent(inout) :: cf
    cf%p%refcount = cf%p%refcount - 1
    if (cf%p%refcount == 0) deallocate (cf%p)
  end subroutine continued_fraction_final

  function make_continued_fraction (gen) result (cf)
    class(term_generator), pointer, intent(in) :: gen
    type(continued_fraction) :: cf

    allocate (cf%p)
    allocate (cf%p%memo(0:31))  ! The starting size is arbitrary.
    cf%p%gen => gen
    cf%p%refcount = cf%p%refcount + 1
  end function make_continued_fraction

  subroutine continued_fraction_record_final (cfrec)
    type(continued_fraction_record), intent(inout) :: cfrec
    deallocate (cfrec%gen)
  end subroutine continued_fraction_record_final

  function make_integer_continued_fraction (bigint) result (cf)
    type(big_integer), intent(in) :: bigint
    type(continued_fraction) :: cf

    class(integer_term_generator), pointer :: gen

    allocate (gen)
    gen%term = bigint
    cf = make_continued_fraction (gen)
  end function make_integer_continued_fraction

  function make_integer_continued_fraction_from_integer (i) result (cf)
    integer, intent(in) :: i
    type(continued_fraction) :: cf
    cf = make_integer_continued_fraction (integer2big (i))
  end function make_integer_continued_fraction_from_integer

  subroutine integer_term_generator_generate (gen, term_exists, term)
    class(integer_term_generator), intent(inout) :: gen
    logical, intent(out) :: term_exists
    type(big_integer), allocatable, intent(out) :: term

    term_exists = (.not. gen%no_more_terms)
    if (term_exists) term = gen%term
    gen%no_more_terms = .true.
  end subroutine integer_term_generator_generate

  function make_constant_term_continued_fraction (bigint) result (cf)
    type(big_integer), intent(in) :: bigint
    type(continued_fraction) :: cf

    class(constant_term_generator), pointer :: gen

    allocate (gen)
    gen%term = bigint
    cf = make_continued_fraction (gen)
  end function make_constant_term_continued_fraction

  function make_constant_term_continued_fraction_from_integer (i) result (cf)
    integer, intent(in) :: i
    type(continued_fraction) :: cf
    cf = make_constant_term_continued_fraction (integer2big (i))
  end function make_constant_term_continued_fraction_from_integer

  subroutine constant_term_generator_generate (gen, term_exists, term)
    class(constant_term_generator), intent(inout) :: gen
    logical, intent(out) :: term_exists
    type(big_integer), allocatable, intent(out) :: term

    term_exists = .true.
    if (term_exists) term = gen%term
  end subroutine constant_term_generator_generate

  function apply_ng8_big_integers (a12, a1, a2, a, &
       &                           b12, b1, b2, b, x, y) result (cf)
    type(big_integer), intent(in) :: a12, a1, a2, a
    type(big_integer), intent(in) :: b12, b1, b2, b
    class(continued_fraction), intent(in) :: x, y
    type(continued_fraction) :: cf

    class(ng8_term_generator), pointer :: gen

    allocate (gen)
    gen%a12 = a12;  gen%a1 = a1;  gen%a2 = a2;  gen%a = a
    gen%b12 = b12;  gen%b1 = b1;  gen%b2 = b2;  gen%b = b
    gen%x = x
    gen%y = y
    cf = make_continued_fraction (gen)
  end function apply_ng8_big_integers

  function apply_ng8_integers (a12, a1, a2, a, &
       &                       b12, b1, b2, b, x, y) result (cf)
    integer, intent(in) :: a12, a1, a2, a
    integer, intent(in) :: b12, b1, b2, b
    class(continued_fraction), intent(in) :: x, y
    type(continued_fraction) :: cf

    cf = apply_ng8_big_integers (integer2big (a12), &
         &                       integer2big (a1),  &
         &                       integer2big (a2),  &
         &                       integer2big (a),   &
         &                       integer2big (b12), &
         &                       integer2big (b1),  &
         &                       integer2big (b2),  &
         &                       integer2big (b), x, y)
  end function apply_ng8_integers

  subroutine ng8_term_generator_generate (gen, term_exists, term)
    class(ng8_term_generator), intent(inout) :: gen
    logical, intent(out) :: term_exists
    type(big_integer), allocatable, intent(out) :: term

    logical :: done
    logical :: b12z, b1z, b2z, bz
    type(big_integer), allocatable :: q12, r12
    type(big_integer), allocatable :: q1, r1
    type(big_integer), allocatable :: q2, r2
    type(big_integer), allocatable :: q, r
    logical :: absorb_x, absorb_y, compare_fracs

    done = .false.
    do while (.not. done)
       absorb_x = .false.
       absorb_y = .false.
       compare_fracs = .false.

       b12z = (big_sgn (gen%b12) == 0)
       b1z = (big_sgn (gen%b1) == 0)
       b2z = (big_sgn (gen%b2) == 0)
       bz = (big_sgn (gen%b) == 0)

       if (b12z .and. b1z .and. b2z .and. bz) then
          ! There are no more terms.
          term_exists = .false.
          done = .true.
       else if (b2z .and. bz) then
          absorb_x = .true.
       else if (b2z .or. bz) then
          absorb_y = .true.
       else if (b1z) then
          absorb_x = .true.
       else
          call big_divrem (gen%a1, gen%b1, q1, r1)
          call big_divrem (gen%a2, gen%b2, q2, r2)
          call big_divrem (gen%a, gen%b, q, r)
          if (.not. b12z) then
             call big_divrem (gen%a12, gen%b12, q12, r12)
             if (big_cmp (q, q1) /= 0) then
                compare_fracs = .true.
             else if (big_cmp (q, q2) /= 0) then
                compare_fracs = .true.
             else if (big_cmp (q, q12) /= 0) then
                compare_fracs = .true.
             else
                call output_term
                done = .true.
             end if
          end if
       end if

       if (compare_fracs) call compare_fractions (absorb_x, absorb_y)
       if (absorb_x) call absorb_x_term
       if (absorb_y) call absorb_y_term
    end do

  contains

    subroutine output_term
      gen%a12 = gen%b12;  gen%a1 = gen%b1;  gen%a2 = gen%b2;  gen%a = gen%b
      gen%b12 = r12;      gen%b1 = r1;      gen%b2 = r2;      gen%b = r
      term_exists = (.not. treat_as_infinite (q))
      if (term_exists) term = q
    end subroutine output_term

    subroutine compare_fractions (absorb_x, absorb_y)
      logical, intent(inout) :: absorb_x, absorb_y

      ! Rather than compare fractions, we will put the numerators over
      ! a common denominator of b1*b2*b, and then compare the new
      ! numerators.

      type(big_integer), allocatable :: n1, n2, n

      n1 = gen%a1 * gen%b2 * gen%b
      n2 = gen%a2 * gen%b1 * gen%b
      n  = gen%a  * gen%b1 * gen%b2
      if (big_cmpabs (n1 - n, n2 - n) > 0) then
         absorb_x = .true.
      else
         absorb_y = .true.
      end if
    end subroutine compare_fractions

    subroutine absorb_x_term
      logical :: term_exists
      type(big_integer), allocatable :: term
      type(big_integer), allocatable :: new_a12, new_a1, new_a2, new_a
      type(big_integer), allocatable :: new_b12, new_b1, new_b2, new_b

      if (gen%x_overflow) then
         term_exists = .false.
      else
         term_exists = gen%x%term_exists(gen%ix)
      end if
      new_a2 = gen%a12
      new_a  = gen%a1
      new_b2 = gen%b12
      new_b  = gen%b1
      if (term_exists) then
         term = gen%x%term(gen%ix)
         new_a12 = gen%a2 + (gen%a12 * term)
         new_a1  = gen%a  + (gen%a1  * term)
         new_b12 = gen%b2 + (gen%b12 * term)
         new_b1  = gen%b  + (gen%b1  * term)
         if (any_too_big (new_a12, new_a1, new_a2, new_a, &
              &           new_b12, new_b1, new_b2, new_b)) then
            gen%x_overflow = .true.
            new_a12 = gen%a12
            new_a1  = gen%a1
            new_b12 = gen%b12
            new_b1  = gen%b1
         end if
      else
         new_a12 = gen%a12
         new_a1  = gen%a1
         new_b12 = gen%b12
         new_b1  = gen%b1
      end if
      gen%a12 = new_a12;  gen%a1 = new_a1;  gen%a2 = new_a2;  gen%a = new_a
      gen%b12 = new_b12;  gen%b1 = new_b1;  gen%b2 = new_b2;  gen%b = new_b
      gen%ix = gen%ix + 1
    end subroutine absorb_x_term

    subroutine absorb_y_term
      logical :: term_exists
      type(big_integer), allocatable :: term
      type(big_integer), allocatable :: new_a12, new_a1, new_a2, new_a
      type(big_integer), allocatable :: new_b12, new_b1, new_b2, new_b

      if (gen%y_overflow) then
         term_exists = .false.
      else
         term_exists = gen%y%term_exists(gen%iy)
      end if
      new_a1 = gen%a12
      new_a  = gen%a2
      new_b1 = gen%b12
      new_b  = gen%b2
      if (term_exists) then
         term = gen%y%term(gen%iy)
         new_a12 = gen%a1 + (gen%a12 * term)
         new_a2  = gen%a  + (gen%a2  * term)
         new_b12 = gen%b1 + (gen%b12 * term)
         new_b2  = gen%b  + (gen%b2  * term)
         if (any_too_big (new_a12, new_a1, new_a2, new_a, &
              &           new_b12, new_b1, new_b2, new_b)) then
            gen%y_overflow = .true.
            new_a12 = gen%a12
            new_a2  = gen%a2
            new_b12 = gen%b12
            new_b2  = gen%b2
         end if
      else
         new_a12 = gen%a12
         new_a2  = gen%a2
         new_b12 = gen%b12
         new_b2  = gen%b2
      end if
      gen%a12 = new_a12;  gen%a1 = new_a1;  gen%a2 = new_a2;  gen%a = new_a
      gen%b12 = new_b12;  gen%b1 = new_b1;  gen%b2 = new_b2;  gen%b = new_b
      gen%iy = gen%iy + 1
    end subroutine absorb_y_term

    function any_too_big (a, b, c, d, e, f, g, h) result (yes)
      type(big_integer), intent(in) :: a, b, c, d, e, f, g, h
      logical :: yes

      if (too_big (a)) then
         yes = .true.
      else if (too_big (b)) then
         yes = .true.
      else if (too_big (c)) then
         yes = .true.
      else if (too_big (d)) then
         yes = .true.
      else if (too_big (e)) then
         yes = .true.
      else if (too_big (f)) then
         yes = .true.
      else if (too_big (g)) then
         yes = .true.
      else if (too_big (h)) then
         yes = .true.
      else
         yes = .false.
      end if
    end function any_too_big

    function too_big (coef) result (yes)
      type(big_integer), intent(in) :: coef
      logical :: yes

      if (.not. allocated (ng8_coefficient_threshold)) then
         ! 2**512
         ng8_coefficient_threshold = string2big ('1340780792994259709957&
              &402499820584612747936582059239337772356144372176403007354&
              &697680187429816690342769003185818648605085375388281194656&
              &9946433649006084096')
      end if

      yes = (big_cmpabs (coef, ng8_coefficient_threshold) >= 0)
    end function too_big

    function treat_as_infinite (term) result (yes)
      type(big_integer), intent(in) :: term
      logical :: yes

      if (.not. allocated (ng8_term_threshold)) then
         ! 2**64
         ng8_term_threshold = string2big ('18446744073709551616')
      end if

      yes = (big_cmpabs (term, ng8_term_threshold) >= 0)
    end function treat_as_infinite

  end subroutine ng8_term_generator_generate

  function add_continued_fractions (x, y) result (cf)
    class(continued_fraction), intent(in) :: x, y
    type(continued_fraction) :: cf
    cf = apply_ng8 (0, 1, 1, 0, 0, 0, 0, 1, x, y)
  end function add_continued_fractions

  function subtract_continued_fractions (x, y) result (cf)
    class(continued_fraction), intent(in) :: x, y
    type(continued_fraction) :: cf
    cf = apply_ng8 (0, 1, -1, 0, 0, 0, 0, 1, x, y)
  end function subtract_continued_fractions

  function multiply_continued_fractions (x, y) result (cf)
    class(continued_fraction), intent(in) :: x, y
    type(continued_fraction) :: cf
    cf = apply_ng8 (1, 0, 0, 0, 0, 0, 0, 1, x, y)
  end function multiply_continued_fractions

  function divide_continued_fractions (x, y) result (cf)
    class(continued_fraction), intent(in) :: x, y
    type(continued_fraction) :: cf
    cf = apply_ng8 (0, 1, 0, 0, 0, 0, 1, 0, x, y)
  end function divide_continued_fractions

  subroutine get_continued_fraction_term (cf, i, term_exists, term)
    class(continued_fraction), intent(in) :: cf
    integer, intent(in) :: i
    logical, intent(out) :: term_exists
    type(big_integer), allocatable, intent(out) :: term

    call get_continued_fraction_record_term (cf%p, i, term_exists, term)
  end subroutine get_continued_fraction_term

  subroutine get_continued_fraction_record_term (cfrec, i, term_exists, term)
    class(continued_fraction_record), intent(inout) :: cfrec
    integer, intent(in) :: i
    logical, intent(out) :: term_exists
    type(big_integer), allocatable, intent(out) :: term

    if (i < 0) error stop

    call update (i + 1)
    term_exists = (i < cfrec%m)
    if (term_exists) term = cfrec%memo(i)

  contains

    subroutine update (needed)
      integer :: needed
      logical :: term_exists1
      type(big_integer), allocatable :: term1

      if (.not. cfrec%terminated .and. cfrec%m < needed) then
         if (size (cfrec%memo) < needed) then
            block               ! Allocate more storage.
              type(big_integer), allocatable :: memo1(:)
              allocate (memo1(0 : (2 * needed) - 1))
              memo1(0:cfrec%m - 1) = cfrec%memo(0:cfrec%m - 1)
              call move_alloc (memo1, cfrec%memo)
            end block
         end if
         do while (.not. cfrec%terminated .and. cfrec%m < needed)
            call cfrec%gen%generate (term_exists1, term1)
            if (term_exists1) then
               cfrec%memo(cfrec%m) = term1
               cfrec%m = cfrec%m + 1
            else
               cfrec%terminated = .true.
            end if
         end do
      end if
    end subroutine update

  end subroutine get_continued_fraction_record_term

  function continued_fraction_term_exists (cf, i) result (term_exists)
    class(continued_fraction), intent(in) :: cf
    integer, intent(in) :: i
    logical :: term_exists
    term_exists = continued_fraction_record_term_exists (cf%p, i)
  end function continued_fraction_term_exists

  function continued_fraction_record_term_exists (cfrec, i) result (term_exists)
    class(continued_fraction_record), intent(inout) :: cfrec
    integer, intent(in) :: i
    logical :: term_exists

    type(big_integer), allocatable :: term

    call get_continued_fraction_record_term (cfrec, i, term_exists, term)
  end function continued_fraction_record_term_exists

  function continued_fraction_term (cf, i) result (term)
    class(continued_fraction), intent(in) :: cf
    integer, intent(in) :: i
    type(big_integer), allocatable :: term
    term = continued_fraction_record_term (cf%p, i)
  end function continued_fraction_term

  function continued_fraction_record_term (cfrec, i) result (term)
    class(continued_fraction_record), intent(inout) :: cfrec
    integer, intent(in) :: i
    type(big_integer), allocatable :: term

    logical :: term_exists

    call get_continued_fraction_record_term (cfrec, i, term_exists, term)
    if (.not. term_exists) error stop
  end function continued_fraction_record_term

  function continued_fraction_to_string_given_max_terms (cf, max_terms) result (s)
    class(continued_fraction), intent(in) :: cf
    integer, intent(in) :: max_terms
    character(len = :), allocatable :: s
    s = continued_fraction_record_to_string_given_max_terms (cf%p, max_terms)
  end function continued_fraction_to_string_given_max_terms

  function continued_fraction_record_to_string_given_max_terms (cfrec, max_terms) result (s)
    class(continued_fraction_record), intent(inout) :: cfrec
    integer, intent(in) :: max_terms
    character(len = :), allocatable :: s

    integer :: i
    logical :: done

    i = 0
    s = '['
    done = .false.
    do while (.not. done)
       if (.not. cfrec%term_exists(i)) then
          s = s // "]"
          done = .true.
       else if (i == max_terms) then
          s = s // ",...]"
          done = .true.
       else
          select case (i)
          case (0);      continue
          case (1);      s = s // ";"
          case default;  s = s // ","
          end select
          s = s // big2string (cfrec%term(i))
          i = i + 1
       end if
    end do
  end function continued_fraction_record_to_string_given_max_terms

  function continued_fraction_to_string_with_default_max_terms (cf) result (s)
    class(continued_fraction), intent(in) :: cf
    character(len = :), allocatable :: s
    s = continued_fraction_record_to_string_with_default_max_terms (cf%p)
  end function continued_fraction_to_string_with_default_max_terms

  function continued_fraction_record_to_string_with_default_max_terms (cfrec) result (s)
    class(continued_fraction_record), intent(inout) :: cfrec
    character(len = :), allocatable :: s

    integer :: max_terms

    max_terms = max (default_continued_fraction_max_terms, 1)
    s = continued_fraction_record_to_string_given_max_terms (cfrec, max_terms)
  end function continued_fraction_record_to_string_with_default_max_terms

end module continued_fractions

!---------------------------------------------------------------------

program bivariate_continued_fraction_task

  use, non_intrinsic :: big_integers
  use, non_intrinsic :: continued_fractions
  implicit none

  type(continued_fraction) :: golden_ratio
  type(continued_fraction) :: silver_ratio
  type(continued_fraction) :: sqrt2
  type(continued_fraction) :: one
  type(continued_fraction) :: two
  type(continued_fraction) :: three
  type(continued_fraction) :: four
  type(continued_fraction) :: method1
  type(continued_fraction) :: method2
  type(continued_fraction) :: method3

  block

    !
    ! Let us start with a test of the long division routine, with some
    ! numbers known to trigger a bug in the first version I
    ! posted. That version had a buggy "add_back" routine.
    !
    ! (How I found such numbers is easy: I used random search.)
    !

    type(big_integer), allocatable :: a, b, q, r

    a = string2big ("95292350834616415707142739736356097545484658215015733475&
         &690528634954280668802285176284181482202905629004984123564335019024318905")
    b = string2big ("63677949970178275389170357551071104191609722674550547056511830750")
    call big_divrem (a, b, q, r)
    if (big_sgn (((b * q) + r) - a) /= 0) error stop

    a = string2big ("5286200801181288750950358142425694618335361315503743069535407838&
         &1104411448878793976933118436177295215313131557463887718741957154")
    b = string2big ("54401097470188014066128968444633185848791550678521")
    call big_divrem (a, b, q, r)
    if (big_sgn (((b * q) + r) - a) /= 0) error stop

    a = string2big ("74352827755975214935544861176217106447734695144315262422&
         &288346418457330023596489437154599028318030933202302606937951415862696330")
    b = string2big ("291979433784649910583546698460221489986784915256036707914578&
         &892106828527219639012712")
    call big_divrem (a, b, q, r)
    if (big_sgn (((b * q) + r) - a) /= 0) error stop

    a = string2big ("7515839498480018152556264500298705705667515770181724145893&
         &9544448656273749453586884931339958104923411455488844854494605760712247")
    b = string2big ("8600698996698965932302079501896131441135807557744554902970070&
         &402964318496325075877027770784963001")
    call big_divrem (a, b, q, r)
    if (big_sgn (((b * q) + r) - a) /= 0) error stop

    a = string2big ("13370595927769020368832742717678609885835798503146654175875&
         &149837801359758893206045930442389897206420586502996797614097489470778")
    b = string2big ("871343613388")
    call big_divrem (a, b, q, r)
    if (big_sgn (((b * q) + r) - a) /= 0) error stop

  end block

  golden_ratio = constant_term_cf (1)
  silver_ratio = constant_term_cf (2)
  one = i2cf (1)
  two = i2cf (2)
  three = i2cf (3)
  four = i2cf (4)
  sqrt2 = silver_ratio - one

  method1 = apply_ng8 (0, 1, 0, 0, 0, 0, 2, 0, silver_ratio, sqrt2)
  method2 = apply_ng8 (1, 0, 0, 1, 0, 0, 0, 8, silver_ratio, silver_ratio)
  method3 = (one / two) * (one + (one / sqrt2))

  call show ("golden ratio", golden_ratio, "(1 + sqrt(5))/2")
  call show ("silver ratio", silver_ratio, "(1 + sqrt(2))")
  call show ("sqrt(2)", sqrt2, "silver ratio minus 1")
  call show ("13/11", i2cf (13) / i2cf (11), "")
  call show ("22/7", i2cf (22) / i2cf (7), "")
  call show ("1", one, "")
  call show ("2", two, "")
  call show ("3", three, "")
  call show ("4", four, "")
  call show ("(1 + 1/sqrt(2))/2", method1, "method 1")
  call show ("(1 + 1/sqrt(2))/2", method2, "method 2")
  call show ("(1 + 1/sqrt(2))/2", method3, "method 3")
  call show ("sqrt(2) + sqrt(2)", sqrt2 + sqrt2, "")
  call show ("sqrt(2) - sqrt(2)", sqrt2 - sqrt2, "")
  call show ("sqrt(2) * sqrt(2)", sqrt2 * sqrt2, "")
  call show ("sqrt(2) / sqrt(2)", sqrt2 / sqrt2, "")

contains

  subroutine show (expression, cf, note)
    character(len = *), intent(in) :: expression
    class(continued_fraction), intent(in) :: cf
    character(len = *), intent(in) :: note

    write (*, '(A19, " =>  ", A, T73, A)') &
         & expression, cf%to_string(), note
  end subroutine show

end program bivariate_continued_fraction_task

!---------------------------------------------------------------------
