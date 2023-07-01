module big_integers             ! Big (but not very big) integers.

  !
  ! A very primitive multiple precision module, using the classical
  ! algorithms (long multiplication, long division) and a mere 8-bit
  ! "digit" size. Some procedures might assume integers are in a
  ! two's-complement representation. This module is good enough for us
  ! to fulfill the task.
  !

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
  public :: big_pow
  public :: operator(+)
  public :: operator(-)
  public :: operator(*)
  public :: operator(**)

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

  interface operator(**)
     module procedure big_pow
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

  function big_pow (a, i) result (c)
    type(big_integer), intent(in) :: a
    integer, intent(in) :: i
    type(big_integer), allocatable :: c

    type(big_integer), allocatable :: base
    integer :: exponent, exponent_halved
    integer :: j, last_set

    if (i < 0) error stop

    if (i == 0) then
       c = integer2big (1)
    else
       last_set = bit_size (i) - leadz (i)
       base = a
       exponent = i
       c = integer2big (1)
       do j = 0, last_set - 1
          exponent_halved = exponent / 2
          if (2 * exponent_halved /= exponent) then
             c = c * base
          end if
          exponent = exponent_halved
          base = base * base
       end do
    end if
  end function big_pow

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

program modular_exponentiation_task
  use, non_intrinsic :: big_integers
  implicit none

  type(big_integer), allocatable :: zero, one, two
  type(big_integer), allocatable :: a, b, modulus

  zero = integer2big (0)
  one = integer2big (1)
  two = integer2big (2)

  a = string2big ("2988348162058574136915891421498819466320163312926952423791023078876139")
  b = string2big ("2351399303373464486466122544523690094744975233415544072992656881240319")
  modulus = string2big ("10") ** 40
  write (*,*) big2string (modular_pow (a, b, modulus))

contains

  ! The right-to-left binary method,
  ! https://en.wikipedia.org/w/index.php?title=Modular_exponentiation&oldid=1136216610#Right-to-left_binary_method
  function modular_pow (base, exponent, modulus) result (retval)
    type(big_integer), intent(in) :: base, exponent, modulus
    type(big_integer), allocatable :: retval

    type(big_integer), allocatable :: bas, expnt, remainder, bit_bucket

    if (big_sgn (modulus - one) == 0) then
       retval = zero
    else
       retval = one
       bas = base
       expnt = exponent
       do while (big_sgn (expnt) /= 0)
          call big_divrem (expnt, two, expnt, remainder)
          if (big_sgn (remainder) /= 0) then
             call big_divrem (retval * bas, modulus, bit_bucket, retval)
          end if
          call big_divrem (bas * bas, modulus, bit_bucket, bas)
       end do
    end if
  end function modular_pow

end program modular_exponentiation_task
