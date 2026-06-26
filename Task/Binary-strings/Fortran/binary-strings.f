! ==============================================================================
module binary_string_mod
  implicit none
  private

  type, public :: bstring
    character(len=1), allocatable :: data(:)
    integer :: length = 0
  end type bstring

  public :: bs_create, bs_destroy
  public :: bs_assign_from_str, bs_assign_from_bs
  public :: bs_compare, bs_clone
  public :: bs_is_empty, bs_append_byte
  public :: bs_substring, bs_replace, bs_join
  public :: bs_to_str, bs_print_hex

contains

  ! --- Creation / Destruction ---

  subroutine bs_create(bs, str)
    type(bstring), intent(out) :: bs
    character(len=*), intent(in), optional :: str
    integer :: n, i
    if (present(str)) then
      n = len(str)
      allocate(bs%data(max(n, 1)))
      do i = 1, n
        bs%data(i) = str(i:i)
      end do
      bs%length = n
    else
      allocate(bs%data(1))
      bs%length = 0
    end if
  end subroutine bs_create

  subroutine bs_destroy(bs)
    type(bstring), intent(inout) :: bs
    if (allocated(bs%data)) deallocate(bs%data)
    bs%length = 0
  end subroutine bs_destroy

  ! --- Assignment ---

  subroutine bs_assign_from_str(bs, str)
    type(bstring), intent(inout) :: bs
    character(len=*), intent(in) :: str
    integer :: n, i
    call bs_destroy(bs)
    n = len(str)
    allocate(bs%data(max(n, 1)))
    do i = 1, n
      bs%data(i) = str(i:i)
    end do
    bs%length = n
  end subroutine bs_assign_from_str

  subroutine bs_assign_from_bs(dest, src)
    type(bstring), intent(inout) :: dest
    type(bstring), intent(in) :: src
    call bs_destroy(dest)
    allocate(dest%data(max(src%length, 1)))
    if (src%length > 0) dest%data(1:src%length) = src%data(1:src%length)
    dest%length = src%length
  end subroutine bs_assign_from_bs

  ! --- Comparison ---
  ! Returns -1 if a < b, 0 if equal, 1 if a > b (lexicographic by byte value)

  integer function bs_compare(a, b)
    type(bstring), intent(in) :: a, b
    integer :: i, minlen
    minlen = min(a%length, b%length)
    do i = 1, minlen
      if (ichar(a%data(i)) < ichar(b%data(i))) then
        bs_compare = -1; return
      else if (ichar(a%data(i)) > ichar(b%data(i))) then
        bs_compare = 1; return
      end if
    end do
    if (a%length < b%length) then
      bs_compare = -1
    else if (a%length > b%length) then
      bs_compare = 1
    else
      bs_compare = 0
    end if
  end function bs_compare

  ! --- Clone (deep copy) ---

  function bs_clone(src) result(dest)
    type(bstring), intent(in) :: src
    type(bstring) :: dest
    allocate(dest%data(max(src%length, 1)))
    if (src%length > 0) dest%data(1:src%length) = src%data(1:src%length)
    dest%length = src%length
  end function bs_clone

  ! --- Empty check ---

  logical function bs_is_empty(bs)
    type(bstring), intent(in) :: bs
    bs_is_empty = (bs%length == 0)
  end function bs_is_empty

  ! --- Append a single byte ---

  subroutine bs_append_byte(bs, byte)
    type(bstring), intent(inout) :: bs
    character(len=1), intent(in) :: byte
    character(len=1), allocatable :: tmp(:)
    integer :: n
    n = bs%length
    allocate(tmp(n + 1))
    if (n > 0) tmp(1:n) = bs%data(1:n)
    tmp(n + 1) = byte
    call move_alloc(tmp, bs%data)
    bs%length = n + 1
  end subroutine bs_append_byte

  ! --- Substring [start .. start+sub_len-1], 1-based, clipped to bounds ---

  function bs_substring(bs, start, sub_len) result(sub)
    type(bstring), intent(in) :: bs
    integer, intent(in) :: start, sub_len
    type(bstring) :: sub
    integer :: alen, ep

    if (start < 1 .or. start > bs%length .or. sub_len <= 0) then
      allocate(sub%data(1))
      sub%length = 0
      return
    end if
    ep = min(start + sub_len - 1, bs%length)
    alen = ep - start + 1
    allocate(sub%data(max(alen, 1)))
    sub%data(1:alen) = bs%data(start:ep)
    sub%length = alen
  end function bs_substring

  ! --- Internal: append src bytes onto dest ---

  subroutine bs_cat(dest, src)
    type(bstring), intent(inout) :: dest
    type(bstring), intent(in) :: src
    character(len=1), allocatable :: tmp(:)
    integer :: n, m
    n = dest%length
    m = src%length
    if (m == 0) return
    allocate(tmp(n + m))
    if (n > 0) tmp(1:n) = dest%data(1:n)
    tmp(n + 1:n + m) = src%data(1:m)
    call move_alloc(tmp, dest%data)
    dest%length = n + m
  end subroutine bs_cat

  ! --- Replace all occurrences of pattern with replacement ---

  function bs_replace(bs, pattern, replacement) result(res)
    type(bstring), intent(in) :: bs, pattern, replacement
    type(bstring) :: res
    integer :: i, j, plen, blen
    logical :: match

    plen = pattern%length
    blen = bs%length
    allocate(res%data(1))
    res%length = 0

    if (plen == 0 .or. blen == 0) then
      call bs_assign_from_bs(res, bs)
      return
    end if

    i = 1
    do while (i <= blen)
      if (i + plen - 1 <= blen) then
        match = .true.
        do j = 1, plen
          if (bs%data(i + j - 1) /= pattern%data(j)) then
            match = .false.
            exit
          end if
        end do
        if (match) then
          call bs_cat(res, replacement)
          i = i + plen
          cycle
        end if
      end if
      call bs_append_byte(res, bs%data(i))
      i = i + 1
    end do
  end function bs_replace

  ! --- Join an array of strings with a separator ---

  function bs_join(strings, n, sep) result(res)
    type(bstring), intent(in) :: strings(:)
    integer, intent(in) :: n
    type(bstring), intent(in) :: sep
    type(bstring) :: res
    integer :: i
    allocate(res%data(1))
    res%length = 0
    do i = 1, n
      if (i > 1) call bs_cat(res, sep)
      call bs_cat(res, strings(i))
    end do
  end function bs_join

  ! --- Helpers ---

  ! Convert to Fortran allocatable character string (binary-safe only for printable bytes)
  function bs_to_str(bs) result(str)
    type(bstring), intent(in) :: bs
    character(len=:), allocatable :: str
    integer :: i
    allocate(character(len=bs%length) :: str)
    do i = 1, bs%length
      str(i:i) = bs%data(i)
    end do
  end function bs_to_str

  ! Print bytes as space-separated hex values
  subroutine bs_print_hex(bs, label)
    type(bstring), intent(in) :: bs
    character(len=*), intent(in), optional :: label
    integer :: i
    if (present(label)) write(*, '(A,A)', advance='no') label, ': '
    write(*, '(A)', advance='no') '['
    do i = 1, bs%length
      if (i > 1) write(*, '(A)', advance='no') ' '
      write(*, '(Z2.2)', advance='no') ichar(bs%data(i))
    end do
    write(*, '(A)') ']'
  end subroutine bs_print_hex

end module binary_string_mod

program test_binary_string
  use binary_string_mod
  implicit none

  integer :: pass_count, fail_count
  pass_count = 0
  fail_count = 0

  write(*, '(A)') '=== Binary String Test Harness ==='
  write(*, *)

  call test_create_destroy()
  call test_assign()
  call test_compare()
  call test_clone()
  call test_is_empty()
  call test_append_byte()
  call test_substring()
  call test_replace()
  call test_join()

  write(*, *)
  write(*, '(A)') '==================================='
  write(*, '(A,I0,A,I0,A)') 'Total: ', pass_count + fail_count, &
    ' tests | PASS: ', pass_count, ' | FAIL: ', fail_count
  if (fail_count > 0) then
    write(*, '(A)') 'SOME TESTS FAILED.'
    stop 1
  else
    write(*, '(A)') 'All tests passed.'
  end if

contains

  subroutine check(label, condition)
    character(len=*), intent(in) :: label
    logical, intent(in) :: condition
    if (condition) then
      write(*, '(A,A)') '  [PASS] ', label
      pass_count = pass_count + 1
    else
      write(*, '(A,A)') '  [FAIL] ', label
      fail_count = fail_count + 1
    end if
  end subroutine check

  ! -----------------------------------------------------------------------
  subroutine test_create_destroy()
    type(bstring) :: bs
    write(*, '(A)') '--- Create / Destroy ---'

    ! Empty create
    call bs_create(bs)
    call check('create(): length == 0',    bs%length == 0)
    call check('create(): is_empty',        bs_is_empty(bs))
    call bs_destroy(bs)
    call check('destroy(): length == 0',   bs%length == 0)
    call check('destroy(): not allocated', .not. allocated(bs%data))

    ! Create from string
    call bs_create(bs, 'Hello')
    call check('create(str): length == 5',  bs%length == 5)
    call check('create(str): content ok',   bs_to_str(bs) == 'Hello')
    call bs_destroy(bs)

    ! Create from string with binary byte embedded via char()
    call bs_create(bs, 'A'//char(0)//'B')
    call check('create(bin str): length == 3',    bs%length == 3)
    call check('create(bin str): byte 1 == A',    bs%data(1) == 'A')
    call check('create(bin str): byte 2 == 0x00', ichar(bs%data(2)) == 0)
    call check('create(bin str): byte 3 == B',    bs%data(3) == 'B')
    call bs_destroy(bs)
  end subroutine test_create_destroy

  ! -----------------------------------------------------------------------
  subroutine test_assign()
    type(bstring) :: a, b
    write(*, '(A)') '--- Assignment ---'

    call bs_create(a)
    call bs_assign_from_str(a, 'world')
    call check('assign_from_str: length == 5',  a%length == 5)
    call check('assign_from_str: content ok',   bs_to_str(a) == 'world')

    ! Re-assign to shorter string (tests dealloc + realloc)
    call bs_assign_from_str(a, 'hi')
    call check('re-assign_from_str: length == 2', a%length == 2)
    call check('re-assign_from_str: content ok',  bs_to_str(a) == 'hi')

    call bs_create(b)
    call bs_assign_from_bs(b, a)
    call check('assign_from_bs: length == 2',    b%length == 2)
    call check('assign_from_bs: content ok',     bs_to_str(b) == 'hi')

    ! Verify deep copy: mutate a, b must be unchanged
    call bs_assign_from_str(a, 'changed')
    call check('assign_from_bs: a mutated',      bs_to_str(a) == 'changed')
    call check('assign_from_bs: b unchanged',    bs_to_str(b) == 'hi')

    call bs_destroy(a)
    call bs_destroy(b)
  end subroutine test_assign

  ! -----------------------------------------------------------------------
  subroutine test_compare()
    type(bstring) :: a, b
    write(*, '(A)') '--- Comparison ---'

    call bs_create(a, 'abc')
    call bs_create(b, 'abc')
    call check('compare equal strings == 0',     bs_compare(a, b) == 0)
    call bs_destroy(b)

    call bs_create(b, 'abd')
    call check('compare a<b returns -1',         bs_compare(a, b) == -1)
    call check('compare a>b returns  1',         bs_compare(b, a) ==  1)
    call bs_destroy(b)

    ! Length difference
    call bs_create(b, 'ab')
    call check('compare shorter < longer',       bs_compare(b, a) == -1)
    call check('compare longer  > shorter',      bs_compare(a, b) ==  1)
    call bs_destroy(b)

    ! Binary bytes: 0x00 vs 0xFF
    call bs_destroy(a)
    call bs_create(a)
    call bs_append_byte(a, char(0))
    call bs_create(b)
    call bs_append_byte(b, char(255))
    call check('compare 0x00 < 0xFF',            bs_compare(a, b) == -1)
    call check('compare 0xFF > 0x00',            bs_compare(b, a) ==  1)

    ! Both 0xFF
    call bs_destroy(a)
    call bs_create(a)
    call bs_append_byte(a, char(255))
    call check('compare 0xFF == 0xFF',           bs_compare(a, b) == 0)

    call bs_destroy(a)
    call bs_destroy(b)
  end subroutine test_compare

  ! -----------------------------------------------------------------------
  subroutine test_clone()
    type(bstring) :: orig, cloned
    write(*, '(A)') '--- Clone ---'

    call bs_create(orig, 'clone_me')
    cloned = bs_clone(orig)
    call check('clone: content equal',          bs_compare(orig, cloned) == 0)

    ! Mutate original; clone must be independent
    call bs_assign_from_str(orig, 'mutated')
    call check('clone: orig mutated',           bs_to_str(orig) == 'mutated')
    call check('clone: clone unchanged',        bs_to_str(cloned) == 'clone_me')

    ! Clone of empty string
    call bs_destroy(orig)
    call bs_create(orig)
    call bs_destroy(cloned)
    cloned = bs_clone(orig)
    call check('clone: empty clone is empty',   bs_is_empty(cloned))

    call bs_destroy(orig)
    call bs_destroy(cloned)
  end subroutine test_clone

  ! -----------------------------------------------------------------------
  subroutine test_is_empty()
    type(bstring) :: bs
    write(*, '(A)') '--- Is Empty ---'

    call bs_create(bs)
    call check('is_empty: newly created',        bs_is_empty(bs))

    call bs_append_byte(bs, 'x')
    call check('is_empty: after append',         .not. bs_is_empty(bs))

    call bs_assign_from_str(bs, '')
    call check('is_empty: assigned empty str',   bs_is_empty(bs))

    call bs_destroy(bs)
  end subroutine test_is_empty

  ! -----------------------------------------------------------------------
  subroutine test_append_byte()
    type(bstring) :: bs
    write(*, '(A)') '--- Append Byte ---'

    call bs_create(bs)
    call bs_append_byte(bs, 'H')
    call bs_append_byte(bs, 'i')
    call check('append: length == 2',            bs%length == 2)
    call check('append: content Hi',             bs_to_str(bs) == 'Hi')

    ! Binary bytes
    call bs_append_byte(bs, char(0))
    call bs_append_byte(bs, char(255))
    call check('append binary: length == 4',     bs%length == 4)
    call check('append binary: byte 3 == 0x00',  ichar(bs%data(3)) == 0)
    call check('append binary: byte 4 == 0xFF',  ichar(bs%data(4)) == 255)

    ! Verify preceding bytes are untouched
    call check('append binary: byte 1 still H',  bs%data(1) == 'H')
    call check('append binary: byte 2 still i',  bs%data(2) == 'i')

    call bs_destroy(bs)
  end subroutine test_append_byte

  ! -----------------------------------------------------------------------
  subroutine test_substring()
    type(bstring) :: bs, sub
    write(*, '(A)') '--- Substring ---'

    call bs_create(bs, 'Hello, World!')   ! length 13

    sub = bs_substring(bs, 1, 5)
    call check('sub from start',           bs_to_str(sub) == 'Hello')
    call bs_destroy(sub)

    sub = bs_substring(bs, 8, 5)
    call check('sub middle',               bs_to_str(sub) == 'World')
    call bs_destroy(sub)

    sub = bs_substring(bs, 8, 100)        ! extends past end
    call check('sub clipped to end',       bs_to_str(sub) == 'World!')
    call bs_destroy(sub)

    sub = bs_substring(bs, 1, 13)
    call check('sub full string',          bs_to_str(sub) == 'Hello, World!')
    call bs_destroy(sub)

    sub = bs_substring(bs, 13, 1)         ! last byte
    call check('sub single last byte',     bs_to_str(sub) == '!')
    call bs_destroy(sub)

    sub = bs_substring(bs, 14, 1)         ! out of bounds
    call check('sub out-of-bounds empty',  bs_is_empty(sub))
    call bs_destroy(sub)

    sub = bs_substring(bs, 1, 0)          ! zero length
    call check('sub zero length empty',    bs_is_empty(sub))
    call bs_destroy(sub)

    ! Substring containing binary byte
    call bs_destroy(bs)
    call bs_create(bs, 'AB'//char(200)//'CD')
    sub = bs_substring(bs, 2, 3)          ! 'B', 0xC8, 'C'
    call check('sub binary: length == 3',  sub%length == 3)
    call check('sub binary: byte 1 == B',  sub%data(1) == 'B')
    call check('sub binary: byte 2 ==200', ichar(sub%data(2)) == 200)
    call check('sub binary: byte 3 == C',  sub%data(3) == 'C')
    call bs_destroy(sub)

    call bs_destroy(bs)
  end subroutine test_substring

  ! -----------------------------------------------------------------------
  subroutine test_replace()
    type(bstring) :: bs, pat, rep, res
    write(*, '(A)') '--- Replace ---'

    ! Multi-byte pattern, non-overlapping greedy left-to-right
    call bs_create(bs,  'aababcabc')
    call bs_create(pat, 'ab')
    call bs_create(rep, 'X')
    res = bs_replace(bs, pat, rep)
    call check('replace ab->X in aababcabc',   bs_to_str(res) == 'aXXcXc')
    call bs_destroy(res); call bs_destroy(bs)
    call bs_destroy(pat); call bs_destroy(rep)

    ! Single-byte pattern, expansion
    call bs_create(bs,  'hello world')
    call bs_create(pat, 'l')
    call bs_create(rep, 'LL')
    res = bs_replace(bs, pat, rep)
    call check('replace l->LL expansion',      bs_to_str(res) == 'heLLLLo worLLd')
    call bs_destroy(res); call bs_destroy(bs)
    call bs_destroy(pat); call bs_destroy(rep)

    ! Pattern not present
    call bs_create(bs,  'hello')
    call bs_create(pat, 'xyz')
    call bs_create(rep, 'ABC')
    res = bs_replace(bs, pat, rep)
    call check('replace no match: unchanged',  bs_to_str(res) == 'hello')
    call bs_destroy(res); call bs_destroy(bs)
    call bs_destroy(pat); call bs_destroy(rep)

    ! Replace with empty string (deletion)
    call bs_create(bs,  'abracadabra')
    call bs_create(pat, 'a')
    call bs_create(rep)      ! empty
    res = bs_replace(bs, pat, rep)
    call check('replace a->empty (delete)',    bs_to_str(res) == 'brcdbr')
    call bs_destroy(res); call bs_destroy(bs)
    call bs_destroy(pat); call bs_destroy(rep)

    ! Source is empty
    call bs_create(bs)
    call bs_create(pat, 'x')
    call bs_create(rep, 'y')
    res = bs_replace(bs, pat, rep)
    call check('replace on empty source',      bs_is_empty(res))
    call bs_destroy(res); call bs_destroy(bs)
    call bs_destroy(pat); call bs_destroy(rep)

    ! Replace binary null byte
    call bs_create(bs)
    call bs_append_byte(bs, char(0))
    call bs_append_byte(bs, 'A')
    call bs_append_byte(bs, char(0))
    call bs_create(pat)
    call bs_append_byte(pat, char(0))
    call bs_create(rep, 'NUL')
    res = bs_replace(bs, pat, rep)
    call check('replace binary 0x00->NUL',     bs_to_str(res) == 'NULANUL')
    call bs_destroy(res); call bs_destroy(bs)
    call bs_destroy(pat); call bs_destroy(rep)

    ! Full-string pattern match
    call bs_create(bs,  'abc')
    call bs_create(pat, 'abc')
    call bs_create(rep, 'XYZ')
    res = bs_replace(bs, pat, rep)
    call check('replace full-string match',    bs_to_str(res) == 'XYZ')
    call bs_destroy(res); call bs_destroy(bs)
    call bs_destroy(pat); call bs_destroy(rep)

  end subroutine test_replace

  ! -----------------------------------------------------------------------
  subroutine test_join()
    type(bstring) :: sep, res
    type(bstring) :: parts(4)
    write(*, '(A)') '--- Join ---'

    call bs_create(parts(1), 'foo')
    call bs_create(parts(2), 'bar')
    call bs_create(parts(3), 'baz')

    call bs_create(sep, ', ')
    res = bs_join(parts, 3, sep)
    call check('join 3 items with ", "',       bs_to_str(res) == 'foo, bar, baz')
    call bs_destroy(res)

    call bs_destroy(sep)
    call bs_create(sep)   ! empty separator
    res = bs_join(parts, 3, sep)
    call check('join 3 items empty sep',       bs_to_str(res) == 'foobarbaz')
    call bs_destroy(res)

    ! Single item
    res = bs_join(parts, 1, sep)
    call check('join 1 item',                  bs_to_str(res) == 'foo')
    call bs_destroy(res)

    ! Zero items
    res = bs_join(parts, 0, sep)
    call check('join 0 items is empty',        bs_is_empty(res))
    call bs_destroy(res)

    ! Binary separator (byte 0xFF between items)
    call bs_destroy(sep)
    call bs_create(sep)
    call bs_append_byte(sep, char(255))
    res = bs_join(parts, 3, sep)
    call check('join binary sep: length == 11', res%length == 11)   ! 3+1+3+1+3
    call check('join binary sep: byte 4 == 0xFF', ichar(res%data(4)) == 255)
    call check('join binary sep: byte 8 == 0xFF', ichar(res%data(8)) == 255)
    call bs_destroy(res)

    ! String items with binary content
    call bs_destroy(parts(1))
    call bs_destroy(parts(2))
    call bs_destroy(parts(3))
    call bs_create(parts(1))
    call bs_append_byte(parts(1), char(1))
    call bs_create(parts(2))
    call bs_append_byte(parts(2), char(3))
    call bs_create(sep, '-')
    res = bs_join(parts, 2, sep)
    call check('join binary content: length == 3', res%length == 3)
    call check('join binary content: byte 1 == 1', ichar(res%data(1)) == 1)
    call check('join binary content: byte 2 == -', res%data(2) == '-')
    call check('join binary content: byte 3 == 3', ichar(res%data(3)) == 3)
    call bs_destroy(res)

    call bs_destroy(parts(1))
    call bs_destroy(parts(2))
    call bs_destroy(sep)
  end subroutine test_join

end program test_binary_string

