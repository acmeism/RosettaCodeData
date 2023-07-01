module compiler_type_kinds
  use, intrinsic :: iso_fortran_env, only: int32
  use, intrinsic :: iso_fortran_env, only: int64

  implicit none
  private

  ! Synonyms.
  integer, parameter, public :: size_kind = int64
  integer, parameter, public :: length_kind = size_kind
  integer, parameter, public :: nk = size_kind

  ! Synonyms for character capable of storing a Unicode code point.
  integer, parameter, public :: unicode_char_kind = selected_char_kind ('ISO_10646')
  integer, parameter, public :: ck = unicode_char_kind

  ! Synonyms for integers capable of storing a Unicode code point.
  integer, parameter, public :: unicode_ichar_kind = int32
  integer, parameter, public :: ick = unicode_ichar_kind

  ! Synonyms for integers in the virtual machine or the interpreter’s
  ! runtime. (The Rosetta Code task says integers in the virtual
  ! machine are 32-bit, but there is nothing in the task that prevents
  ! us using 64-bit integers in the compiler and interpreter.)
  integer, parameter, public :: runtime_int_kind = int64
  integer, parameter, public :: rik = runtime_int_kind
end module compiler_type_kinds

module helpers
  use, non_intrinsic :: compiler_type_kinds, only: nk, rik, ck

  implicit none
  private

  public :: new_storage_size
  public :: next_power_of_two

  public :: isspace
  public :: quoted_string

  public :: int32_to_vm_bytes
  public :: uint32_to_vm_bytes
  public :: int32_from_vm_bytes
  public :: uint32_from_vm_bytes

  public :: bool2int

  character(1, kind = ck), parameter, public :: horizontal_tab_char = char (9, kind = ck)
  character(1, kind = ck), parameter, public :: linefeed_char = char (10, kind = ck)
  character(1, kind = ck), parameter, public :: vertical_tab_char = char (11, kind = ck)
  character(1, kind = ck), parameter, public :: formfeed_char = char (12, kind = ck)
  character(1, kind = ck), parameter, public :: carriage_return_char = char (13, kind = ck)
  character(1, kind = ck), parameter, public :: space_char = ck_' '

  ! The following is correct for Unix and its relatives.
  character(1, kind = ck), parameter, public :: newline_char = linefeed_char

  character(1, kind = ck), parameter, public :: backslash_char = char (92, kind = ck)

contains

  elemental function new_storage_size (length_needed) result (size)
    integer(kind = nk), intent(in) :: length_needed
    integer(kind = nk) :: size

    ! Increase storage by orders of magnitude.

    if (2_nk**32 < length_needed) then
       size = huge (1_nk)
    else
       size = next_power_of_two (length_needed)
    end if
  end function new_storage_size

  elemental function next_power_of_two (x) result (y)
    integer(kind = nk), intent(in) :: x
    integer(kind = nk) :: y

    !
    ! It is assumed that no more than 64 bits are used.
    !
    ! The branch-free algorithm is that of
    ! https://archive.is/nKxAc#RoundUpPowerOf2
    !
    ! Fill in bits until one less than the desired power of two is
    ! reached, and then add one.
    !

    y = x - 1
    y = ior (y, ishft (y, -1))
    y = ior (y, ishft (y, -2))
    y = ior (y, ishft (y, -4))
    y = ior (y, ishft (y, -8))
    y = ior (y, ishft (y, -16))
    y = ior (y, ishft (y, -32))
    y = y + 1
  end function next_power_of_two

  elemental function isspace (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    bool = (ch == horizontal_tab_char) .or.  &
         & (ch == linefeed_char) .or.        &
         & (ch == vertical_tab_char) .or.    &
         & (ch == formfeed_char) .or.        &
         & (ch == carriage_return_char) .or. &
         & (ch == space_char)
  end function isspace

  function quoted_string (str) result (qstr)
    character(*, kind = ck), intent(in) :: str
    character(:, kind = ck), allocatable :: qstr

    integer(kind = nk) :: n, i, j

    ! Compute n = the size of qstr.
    n = 2_nk
    do i = 1_nk, len (str, kind = nk)
       select case (str(i:i))
       case (newline_char, backslash_char)
          n = n + 2
       case default
          n = n + 1
       end select
    end do

    allocate (character(n, kind = ck) :: qstr)

    ! Quote the string.
    qstr(1:1) = ck_'"'
    j = 2_nk
    do i = 1_nk, len (str, kind = nk)
       select case (str(i:i))
       case (newline_char)
          qstr(j:j) = backslash_char
          qstr((j + 1):(j + 1)) = ck_'n'
          j = j + 2
       case (backslash_char)
          qstr(j:j) = backslash_char
          qstr((j + 1):(j + 1)) = backslash_char
          j = j + 2
       case default
          qstr(j:j) = str(i:i)
          j = j + 1
       end select
    end do
    if (j /= n) error stop      ! Check code correctness.
    qstr(n:n) = ck_'"'
  end function quoted_string

  subroutine int32_to_vm_bytes (n, bytes, i)
    integer(kind = rik), intent(in) :: n
    character(1), intent(inout) :: bytes(0:*)
    integer(kind = rik), intent(in) :: i

    !
    ! The virtual machine is presumed to be little-endian. Because I
    ! slightly prefer little-endian.
    !

    bytes(i) = achar (ibits (n, 0, 8))
    bytes(i + 1) = achar (ibits (n, 8, 8))
    bytes(i + 2) = achar (ibits (n, 16, 8))
    bytes(i + 3) = achar (ibits (n, 24, 8))
  end subroutine int32_to_vm_bytes

  subroutine uint32_to_vm_bytes (n, bytes, i)
    integer(kind = rik), intent(in) :: n
    character(1), intent(inout) :: bytes(0:*)
    integer(kind = rik), intent(in) :: i

    call int32_to_vm_bytes (n, bytes, i)
  end subroutine uint32_to_vm_bytes

  subroutine int32_from_vm_bytes (n, bytes, i)
    integer(kind = rik), intent(out) :: n
    character(1), intent(in) :: bytes(0:*)
    integer(kind = rik), intent(in) :: i

    !
    ! The virtual machine is presumed to be little-endian. Because I
    ! slightly prefer little-endian.
    !

    call uint32_from_vm_bytes (n, bytes, i)
    if (ibits (n, 31, 1) == 1) then
       ! Extend the sign bit.
       n = ior (n, not ((2_rik ** 32) - 1))
    end if
  end subroutine int32_from_vm_bytes

  subroutine uint32_from_vm_bytes (n, bytes, i)
    integer(kind = rik), intent(out) :: n
    character(1), intent(in) :: bytes(0:*)
    integer(kind = rik), intent(in) :: i

    !
    ! The virtual machine is presumed to be little-endian. Because I
    ! slightly prefer little-endian.
    !

    integer(kind = rik) :: n0, n1, n2, n3

    n0 = iachar (bytes(i), kind = rik)
    n1 = ishft (iachar (bytes(i + 1), kind = rik), 8)
    n2 = ishft (iachar (bytes(i + 2), kind = rik), 16)
    n3 = ishft (iachar (bytes(i + 3), kind = rik), 24)
    n = ior (n0, ior (n1, ior (n2, n3)))
  end subroutine uint32_from_vm_bytes

  elemental function bool2int (bool) result (int)
    logical, intent(in) :: bool
    integer(kind = rik) :: int

    if (bool) then
       int = 1_rik
    else
       int = 0_rik
    end if
  end function bool2int

end module helpers

module string_buffers
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, intrinsic :: iso_fortran_env, only: int64
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck, ick
  use, non_intrinsic :: helpers

  implicit none
  private

  public :: strbuf_t
  public :: skip_whitespace
  public :: skip_non_whitespace
  public :: skip_whitespace_backwards
  public :: at_end_of_line

  type :: strbuf_t
     integer(kind = nk), private :: len = 0
     !
     ! ‘chars’ is made public for efficient access to the individual
     ! characters.
     !
     character(1, kind = ck), allocatable, public :: chars(:)
   contains
     procedure, pass, private :: ensure_storage => strbuf_t_ensure_storage
     procedure, pass :: to_unicode_full_string => strbuf_t_to_unicode_full_string
     procedure, pass :: to_unicode_substring => strbuf_t_to_unicode_substring
     procedure, pass :: length => strbuf_t_length
     procedure, pass :: set => strbuf_t_set
     procedure, pass :: append => strbuf_t_append
     generic :: to_unicode => to_unicode_full_string
     generic :: to_unicode => to_unicode_substring
     generic :: assignment(=) => set
  end type strbuf_t

contains

  function strbuf_t_to_unicode_full_string (strbuf) result (s)
    class(strbuf_t), intent(in) :: strbuf
    character(:, kind = ck), allocatable :: s

    !
    ! This does not actually ensure that the string is valid Unicode;
    ! any 31-bit ‘character’ is supported.
    !

    integer(kind = nk) :: i

    allocate (character(len = strbuf%len, kind = ck) :: s)
    do i = 1, strbuf%len
       s(i:i) = strbuf%chars(i)
    end do
  end function strbuf_t_to_unicode_full_string

  function strbuf_t_to_unicode_substring (strbuf, i, j) result (s)
    !
    ! ‘Extreme’ values of i and j are allowed, as shortcuts for ‘from
    ! the beginning’, ‘up to the end’, or ‘empty substring’.
    !
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i, j
    character(:, kind = ck), allocatable :: s

    !
    ! This does not actually ensure that the string is valid Unicode;
    ! any 31-bit ‘character’ is supported.
    !

    integer(kind = nk) :: i1, j1
    integer(kind = nk) :: n
    integer(kind = nk) :: k

    i1 = max (1_nk, i)
    j1 = min (strbuf%len, j)
    n = max (0_nk, (j1 - i1) + 1_nk)

    allocate (character(n, kind = ck) :: s)
    do k = 1, n
       s(k:k) = strbuf%chars(i1 + (k - 1_nk))
    end do
  end function strbuf_t_to_unicode_substring

  elemental function strbuf_t_length (strbuf) result (n)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk) :: n

    n = strbuf%len
  end function strbuf_t_length

  subroutine strbuf_t_ensure_storage (strbuf, length_needed)
    class(strbuf_t), intent(inout) :: strbuf
    integer(kind = nk), intent(in) :: length_needed

    integer(kind = nk) :: len_needed
    integer(kind = nk) :: new_size
    type(strbuf_t) :: new_strbuf

    len_needed = max (length_needed, 1_nk)

    if (.not. allocated (strbuf%chars)) then
       ! Initialize a new strbuf%chars array.
       new_size = new_storage_size (len_needed)
       allocate (strbuf%chars(1:new_size))
    else if (ubound (strbuf%chars, 1) < len_needed) then
       ! Allocate a new strbuf%chars array, larger than the current
       ! one, but containing the same characters.
       new_size = new_storage_size (len_needed)
       allocate (new_strbuf%chars(1:new_size))
       new_strbuf%chars(1:strbuf%len) = strbuf%chars(1:strbuf%len)
       call move_alloc (new_strbuf%chars, strbuf%chars)
    end if
  end subroutine strbuf_t_ensure_storage

  subroutine strbuf_t_set (dst, src)
    class(strbuf_t), intent(inout) :: dst
    class(*), intent(in) :: src

    integer(kind = nk) :: n
    integer(kind = nk) :: i

    select type (src)
    type is (character(*, kind = ck))
       n = len (src, kind = nk)
       call dst%ensure_storage(n)
       do i = 1, n
          dst%chars(i) = src(i:i)
       end do
       dst%len = n
    type is (character(*))
       n = len (src, kind = nk)
       call dst%ensure_storage(n)
       do i = 1, n
          dst%chars(i) = src(i:i)
       end do
       dst%len = n
    class is (strbuf_t)
       n = src%len
       call dst%ensure_storage(n)
       dst%chars(1:n) = src%chars(1:n)
       dst%len = n
    class default
       error stop
    end select
  end subroutine strbuf_t_set

  subroutine strbuf_t_append (dst, src)
    class(strbuf_t), intent(inout) :: dst
    class(*), intent(in) :: src

    integer(kind = nk) :: n_dst, n_src, n
    integer(kind = nk) :: i

    select type (src)
    type is (character(*, kind = ck))
       n_dst = dst%len
       n_src = len (src, kind = nk)
       n = n_dst + n_src
       call dst%ensure_storage(n)
       do i = 1, n_src
          dst%chars(n_dst + i) = src(i:i)
       end do
       dst%len = n
    type is (character(*))
       n_dst = dst%len
       n_src = len (src, kind = nk)
       n = n_dst + n_src
       call dst%ensure_storage(n)
       do i = 1, n_src
          dst%chars(n_dst + i) = src(i:i)
       end do
       dst%len = n
    class is (strbuf_t)
       n_dst = dst%len
       n_src = src%len
       n = n_dst + n_src
       call dst%ensure_storage(n)
       dst%chars((n_dst + 1):n) = src%chars(1:n_src)
       dst%len = n
    class default
       error stop
    end select
  end subroutine strbuf_t_append

  function skip_whitespace (strbuf, i) result (j)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i
    integer(kind = nk) :: j

    logical :: done

    j = i
    done = .false.
    do while (.not. done)
       if (at_end_of_line (strbuf, j)) then
          done = .true.
       else if (.not. isspace (strbuf%chars(j))) then
          done = .true.
       else
          j = j + 1
       end if
    end do
  end function skip_whitespace

  function skip_non_whitespace (strbuf, i) result (j)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i
    integer(kind = nk) :: j

    logical :: done

    j = i
    done = .false.
    do while (.not. done)
       if (at_end_of_line (strbuf, j)) then
          done = .true.
       else if (isspace (strbuf%chars(j))) then
          done = .true.
       else
          j = j + 1
       end if
    end do
  end function skip_non_whitespace

  function skip_whitespace_backwards (strbuf, i) result (j)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i
    integer(kind = nk) :: j

    logical :: done

    j = i
    done = .false.
    do while (.not. done)
       if (j == -1) then
          done = .true.
       else if (.not. isspace (strbuf%chars(j))) then
          done = .true.
       else
          j = j - 1
       end if
    end do
  end function skip_whitespace_backwards

  function at_end_of_line (strbuf, i) result (bool)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i
    logical :: bool

    bool = (strbuf%length() < i)
  end function at_end_of_line

end module string_buffers

module reading_one_line_from_a_stream
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck, ick
  use, non_intrinsic :: string_buffers

  implicit none
  private

  ! get_line_from_stream: read an entire input line from a stream into
  ! a strbuf_t.
  public :: get_line_from_stream

  character(1, kind = ck), parameter :: linefeed_char = char (10, kind = ck)

  ! The following is correct for Unix and its relatives.
  character(1, kind = ck), parameter :: newline_char = linefeed_char

contains

  subroutine get_line_from_stream (unit_no, eof, no_newline, strbuf)
    integer, intent(in) :: unit_no
    logical, intent(out) :: eof ! End of file?
    logical, intent(out) :: no_newline ! There is a line but it has no
                                       ! newline? (Thus eof also must
                                       ! be .true.)
    class(strbuf_t), intent(inout) :: strbuf

    character(1, kind = ck) :: ch

    strbuf = ''
    call get_ch (unit_no, eof, ch)
    do while (.not. eof .and. ch /= newline_char)
       call strbuf%append (ch)
       call get_ch (unit_no, eof, ch)
    end do
    no_newline = eof .and. (strbuf%length() /= 0)
  end subroutine get_line_from_stream

  subroutine get_ch (unit_no, eof, ch)
    !
    ! Read a single code point from the stream.
    !
    ! Currently this procedure simply inputs ‘ASCII’ bytes rather than
    ! Unicode code points.
    !
    integer, intent(in) :: unit_no
    logical, intent(out) :: eof
    character(1, kind = ck), intent(out) :: ch

    integer :: stat
    character(1) :: c = '*'

    eof = .false.

    if (unit_no == input_unit) then
       call get_input_unit_char (c, stat)
    else
       read (unit = unit_no, iostat = stat) c
    end if

    if (stat < 0) then
       ch = ck_'*'
       eof = .true.
    else if (0 < stat) then
       write (error_unit, '("Input error with status code ", I0)') stat
       stop 1
    else
       ch = char (ichar (c, kind = ick), kind = ck)
    end if
  end subroutine get_ch

!!!
!!! If you tell gfortran you want -std=f2008 or -std=f2018, you likely
!!! will need to add also -fall-intrinsics or -U__GFORTRAN__
!!!
!!! The first way, you get the FGETC intrinsic. The latter way, you
!!! get the C interface code that uses getchar(3).
!!!
#ifdef __GFORTRAN__

  subroutine get_input_unit_char (c, stat)
    !
    ! The following works if you are using gfortran.
    !
    ! (FGETC is considered a feature for backwards compatibility with
    ! g77. However, I know of no way to reconfigure input_unit as a
    ! Fortran 2003 stream, for use with ordinary ‘read’.)
    !
    character, intent(inout) :: c
    integer, intent(out) :: stat

    call fgetc (input_unit, c, stat)
  end subroutine get_input_unit_char

#else

  subroutine get_input_unit_char (c, stat)
    !
    ! An alternative implementation of get_input_unit_char. This
    ! actually reads input from the C standard input, which might not
    ! be the same as input_unit.
    !
    use, intrinsic :: iso_c_binding, only: c_int
    character, intent(inout) :: c
    integer, intent(out) :: stat

    interface
       !
       ! Use getchar(3) to read characters from standard input. This
       ! assumes there is actually such a function available, and that
       ! getchar(3) does not exist solely as a macro. (One could write
       ! one’s own getchar() if necessary, of course.)
       !
       function getchar () result (c) bind (c, name = 'getchar')
         use, intrinsic :: iso_c_binding, only: c_int
         integer(kind = c_int) :: c
       end function getchar
    end interface

    integer(kind = c_int) :: i_char

    i_char = getchar ()
    !
    ! The C standard requires that EOF have a negative value. If the
    ! value returned by getchar(3) is not EOF, then it will be
    ! representable as an unsigned char. Therefore, to check for end
    ! of file, one need only test whether i_char is negative.
    !
    if (i_char < 0) then
       stat = -1
    else
       stat = 0
       c = char (i_char)
    end if
  end subroutine get_input_unit_char

#endif

end module reading_one_line_from_a_stream

module vm_reader
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds
  use, non_intrinsic :: helpers
  use, non_intrinsic :: string_buffers
  use, non_intrinsic :: reading_one_line_from_a_stream

  implicit none
  private

  public :: vm_code_t
  public :: vm_t
  public :: read_vm

  !
  ! Arbitrarily chosen opcodes.
  !
  ! I think there should be a no-operation ‘nop’ opcode, to reserve
  ! space for later hand-patching. :)
  !
  integer, parameter, public :: opcode_nop = 0
  integer, parameter, public :: opcode_halt = 1
  integer, parameter, public :: opcode_add = 2
  integer, parameter, public :: opcode_sub = 3
  integer, parameter, public :: opcode_mul = 4
  integer, parameter, public :: opcode_div = 5
  integer, parameter, public :: opcode_mod = 6
  integer, parameter, public :: opcode_lt = 7
  integer, parameter, public :: opcode_gt = 8
  integer, parameter, public :: opcode_le = 9
  integer, parameter, public :: opcode_ge = 10
  integer, parameter, public :: opcode_eq = 11
  integer, parameter, public :: opcode_ne = 12
  integer, parameter, public :: opcode_and = 13
  integer, parameter, public :: opcode_or = 14
  integer, parameter, public :: opcode_neg = 15
  integer, parameter, public :: opcode_not = 16
  integer, parameter, public :: opcode_prtc = 17
  integer, parameter, public :: opcode_prti = 18
  integer, parameter, public :: opcode_prts = 19
  integer, parameter, public :: opcode_fetch = 20
  integer, parameter, public :: opcode_store = 21
  integer, parameter, public :: opcode_push = 22
  integer, parameter, public :: opcode_jmp = 23
  integer, parameter, public :: opcode_jz = 24

  character(8, kind = ck), parameter, public :: opcode_names(0:24) = &
       & (/ "nop     ",   &
       &    "halt    ",   &
       &    "add     ",   &
       &    "sub     ",   &
       &    "mul     ",   &
       &    "div     ",   &
       &    "mod     ",   &
       &    "lt      ",   &
       &    "gt      ",   &
       &    "le      ",   &
       &    "ge      ",   &
       &    "eq      ",   &
       &    "ne      ",   &
       &    "and     ",   &
       &    "or      ",   &
       &    "neg     ",   &
       &    "not     ",   &
       &    "prtc    ",   &
       &    "prti    ",   &
       &    "prts    ",   &
       &    "fetch   ",   &
       &    "store   ",   &
       &    "push    ",   &
       &    "jmp     ",   &
       &    "jz      " /)

  type :: vm_code_t
     integer(kind = rik), private :: len = 0_rik
     character(1), allocatable :: bytes(:)
   contains
     procedure, pass, private :: ensure_storage => vm_code_t_ensure_storage
     procedure, pass :: length => vm_code_t_length
  end type vm_code_t

  type :: vm_t
     integer(kind = rik), allocatable :: string_boundaries(:)
     character(:, kind = ck), allocatable :: strings
     character(1), allocatable :: data(:)
     character(1), allocatable :: stack(:)
     type(vm_code_t) :: code
     integer(kind = rik) :: sp = 0_rik
     integer(kind = rik) :: pc = 0_rik
  end type vm_t

contains

  subroutine vm_code_t_ensure_storage (code, length_needed)
    class(vm_code_t), intent(inout) :: code
    integer(kind = nk), intent(in) :: length_needed

    integer(kind = nk) :: len_needed
    integer(kind = nk) :: new_size
    type(vm_code_t) :: new_code

    len_needed = max (length_needed, 1_nk)

    if (.not. allocated (code%bytes)) then
       ! Initialize a new code%bytes array.
       new_size = new_storage_size (len_needed)
       allocate (code%bytes(0:(new_size - 1)))
    else if (ubound (code%bytes, 1) < len_needed - 1) then
       ! Allocate a new code%bytes array, larger than the current one,
       ! but containing the same bytes.
       new_size = new_storage_size (len_needed)
       allocate (new_code%bytes(0:(new_size - 1)))
       new_code%bytes(0:(code%len - 1)) = code%bytes(0:(code%len - 1))
       call move_alloc (new_code%bytes, code%bytes)
    end if
  end subroutine vm_code_t_ensure_storage

  elemental function vm_code_t_length (code) result (len)
    class(vm_code_t), intent(in) :: code
    integer(kind = rik) :: len

    len = code%len
  end function vm_code_t_length

  subroutine read_vm (inp, strbuf, vm)
    integer, intent(in) :: inp
    type(strbuf_t), intent(inout) :: strbuf
    type(vm_t), intent(out) :: vm

    integer(kind = rik) :: data_size
    integer(kind = rik) :: number_of_strings

    ! Read the header.
    call read_datasize_and_number_of_strings (inp, strbuf, data_size, number_of_strings)

    ! Allocate storage for data_size 32-bit numbers. Initialize them
    ! to zero, for no better reason than that C initializes global
    ! variables to zero.
    allocate (vm%data(0_rik:(4_rik * (data_size - 1))), source = achar (0))

    ! Allocate storage for indices/bounds of the strings to be loaded
    ! into the string storage space.
    allocate (vm%string_boundaries(0_rik:number_of_strings))

    ! Fill the strings storage and the string boundaries array.
    call read_strings (inp, strbuf, number_of_strings, vm)

    ! Read the program instructions.
    call read_code (inp, strbuf, vm)

    ! Allocate a stack. Let us say that the stack size must be a
    ! multiple of 4, and is fixed at 65536 = 4**8 bytes. Pushing a
    ! 32-bit integer increases the stack pointer by 4, popping
    ! decreases it by 4.
    allocate (vm%stack(0_rik:(4_rik ** 8)))
  end subroutine read_vm

  subroutine read_datasize_and_number_of_strings (inp, strbuf, data_size, number_of_strings)
    integer, intent(in) :: inp
    type(strbuf_t), intent(inout) :: strbuf
    integer(kind = rik), intent(out) :: data_size
    integer(kind = rik), intent(out) :: number_of_strings

    logical :: eof
    logical :: no_newline
    integer(kind = nk) :: i, j
    character(:, kind = ck), allocatable :: data_size_str
    character(:, kind = ck), allocatable :: number_of_strings_str
    integer :: stat

    call get_line_from_stream (inp, eof, no_newline, strbuf)
    if (eof) call bad_vm_assembly

    i = skip_whitespace (strbuf, 1_nk)
    i = skip_datasize_keyword (strbuf, i)
    i = skip_whitespace (strbuf, i)
    i = skip_specific_character (strbuf, i, ck_':')
    i = skip_whitespace (strbuf, i)
    j = skip_non_whitespace (strbuf, i)
    if (j == i) call bad_vm_assembly
    allocate (data_size_str, source = strbuf%to_unicode (i, j - 1))

    i = skip_whitespace(strbuf, j)
    i = skip_strings_keyword (strbuf, i)
    i = skip_whitespace (strbuf, i)
    i = skip_specific_character (strbuf, i, ck_':')
    i = skip_whitespace (strbuf, i)
    j = skip_non_whitespace (strbuf, i)
    if (j == i) call bad_vm_assembly
    allocate (number_of_strings_str, source = strbuf%to_unicode (i, j - 1))

    read (data_size_str, *, iostat = stat) data_size
    if (stat /= 0) call bad_vm_assembly
    read (number_of_strings_str, *, iostat = stat) number_of_strings
    if (stat /= 0) call bad_vm_assembly
  end subroutine read_datasize_and_number_of_strings

  subroutine read_strings (inp, strbuf, number_of_strings, vm)
    integer, intent(in) :: inp
    type(strbuf_t), intent(inout) :: strbuf
    integer(kind = rik), intent(in) :: number_of_strings
    type(vm_t), intent(inout) :: vm

    type(strbuf_t) :: strings_temporary
    integer(kind = rik) :: i

    vm%string_boundaries(0) = 0_rik
    do i = 0_rik, number_of_strings - 1
       call read_one_string (inp, strbuf, strings_temporary)
       vm%string_boundaries(i + 1) = strings_temporary%length()
    end do
    allocate (vm%strings, source = strings_temporary%to_unicode())
  end subroutine read_strings

  subroutine read_one_string (inp, strbuf, strings_temporary)
    integer, intent(in) :: inp
    type(strbuf_t), intent(inout) :: strbuf
    type(strbuf_t), intent(inout) :: strings_temporary

    logical :: eof
    logical :: no_newline
    integer(kind = nk) :: i
    logical :: done

    call get_line_from_stream (inp, eof, no_newline, strbuf)
    if (eof) call bad_vm_assembly
    i = skip_whitespace (strbuf, 1_nk)
    i = skip_specific_character (strbuf, i, ck_'"')
    done = .false.
    do while (.not. done)
       if (i == strbuf%length() + 1) call bad_vm_assembly
       if (strbuf%chars(i) == ck_'"') then
          done = .true.
       else if (strbuf%chars(i) == backslash_char) then
          if (i == strbuf%length()) call bad_vm_assembly
          select case (strbuf%chars(i + 1))
          case (ck_'n')
             call strings_temporary%append(newline_char)
          case (backslash_char)
             call strings_temporary%append(backslash_char)
          case default
             call bad_vm_assembly
          end select
          i = i + 2
       else
          call strings_temporary%append(strbuf%chars(i))
          i = i + 1
       end if
    end do
  end subroutine read_one_string

  subroutine read_code (inp, strbuf, vm)
    integer, intent(in) :: inp
    type(strbuf_t), intent(inout) :: strbuf
    type(vm_t), intent(inout) :: vm

    logical :: eof
    logical :: no_newline

    call get_line_from_stream (inp, eof, no_newline, strbuf)
    do while (.not. eof)
       call parse_instruction (strbuf, vm%code)
       call get_line_from_stream (inp, eof, no_newline, strbuf)
    end do
  end subroutine read_code

  subroutine parse_instruction (strbuf, code)
    type(strbuf_t), intent(in) :: strbuf
    type(vm_code_t), intent(inout) :: code

    integer(kind = nk) :: i, j
    integer :: stat

    integer :: opcode
    integer(kind = rik) :: i_vm
    integer(kind = rik) :: arg

    character(8, kind = ck) :: opcode_name_str
    character(:, kind = ck), allocatable :: i_vm_str
    character(:, kind = ck), allocatable :: arg_str

    i = skip_whitespace (strbuf, 1_nk)
    j = skip_non_whitespace (strbuf, i)
    if (j == i) call bad_vm_assembly
    allocate (i_vm_str, source = strbuf%to_unicode(i, j - 1))
    read (i_vm_str, *, iostat = stat) i_vm
    if (stat /= 0) call bad_vm_assembly

    i = skip_whitespace (strbuf, j)
    j = skip_non_whitespace (strbuf, i)
    opcode_name_str = ck_'        '
    opcode_name_str(1:(j - i)) = strbuf%to_unicode(i, j - 1)
    opcode = findloc (opcode_names, opcode_name_str, 1) - 1
    if (opcode == -1) call bad_vm_assembly

    select case (opcode)

    case (opcode_push)
       call code%ensure_storage(i_vm + 5)
       code%bytes(i_vm) = achar (opcode)
       i = skip_whitespace (strbuf, j)
       j = skip_non_whitespace (strbuf, i)
       if (j == i) call bad_vm_assembly
       allocate (arg_str, source = strbuf%to_unicode(i, j - 1))
       read (arg_str, *, iostat = stat) arg
       if (stat /= 0) call bad_vm_assembly
       call int32_to_vm_bytes (arg, code%bytes, i_vm + 1)
       code%len = max (code%len, i_vm + 5)

    case (opcode_fetch, opcode_store)
       call code%ensure_storage(i_vm + 5)
       code%bytes(i_vm) = achar (opcode)
       i = skip_whitespace (strbuf, j)
       i = skip_specific_character (strbuf, i, ck_'[')
       i = skip_whitespace (strbuf, i)
       j = skip_non_whitespace (strbuf, i)
       if (j == i) call bad_vm_assembly
       if (strbuf%chars(j - 1) == ck_']') j = j - 1
       allocate (arg_str, source = strbuf%to_unicode(i, j - 1))
       read (arg_str, *, iostat = stat) arg
       if (stat /= 0) call bad_vm_assembly
       call uint32_to_vm_bytes (arg, code%bytes, i_vm + 1)
       code%len = max (code%len, i_vm + 5)

    case (opcode_jmp, opcode_jz)
       call code%ensure_storage(i_vm + 5)
       code%bytes(i_vm) = achar (opcode)
       call code%ensure_storage(i_vm + 5)
       code%bytes(i_vm) = achar (opcode)
       i = skip_whitespace (strbuf, j)
       i = skip_specific_character (strbuf, i, ck_'(')
       i = skip_whitespace (strbuf, i)
       j = skip_non_whitespace (strbuf, i)
       if (j == i) call bad_vm_assembly
       if (strbuf%chars(j - 1) == ck_')') j = j - 1
       allocate (arg_str, source = strbuf%to_unicode(i, j - 1))
       read (arg_str, *, iostat = stat) arg
       if (stat /= 0) call bad_vm_assembly
       call int32_to_vm_bytes (arg, code%bytes, i_vm + 1)
       code%len = max (code%len, i_vm + 5)

    case default
       call code%ensure_storage(i_vm + 1)
       code%bytes(i_vm) = achar (opcode)
       code%len = max (code%len, i_vm + 1)
    end select

  end subroutine parse_instruction

  function skip_datasize_keyword (strbuf, i) result (j)
    type(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i
    integer(kind = nk) :: j

    j = skip_specific_character (strbuf, i, ck_'D')
    j = skip_specific_character (strbuf, j, ck_'a')
    j = skip_specific_character (strbuf, j, ck_'t')
    j = skip_specific_character (strbuf, j, ck_'a')
    j = skip_specific_character (strbuf, j, ck_'s')
    j = skip_specific_character (strbuf, j, ck_'i')
    j = skip_specific_character (strbuf, j, ck_'z')
    j = skip_specific_character (strbuf, j, ck_'e')
  end function skip_datasize_keyword

  function skip_strings_keyword (strbuf, i) result (j)
    type(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i
    integer(kind = nk) :: j

    j = skip_specific_character (strbuf, i, ck_'S')
    j = skip_specific_character (strbuf, j, ck_'t')
    j = skip_specific_character (strbuf, j, ck_'r')
    j = skip_specific_character (strbuf, j, ck_'i')
    j = skip_specific_character (strbuf, j, ck_'n')
    j = skip_specific_character (strbuf, j, ck_'g')
    j = skip_specific_character (strbuf, j, ck_'s')
  end function skip_strings_keyword

  function skip_specific_character (strbuf, i, ch) result (j)
    type(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i
    character(1, kind = ck), intent(in) :: ch
    integer(kind = nk) :: j

    if (strbuf%length() < i) call bad_vm_assembly
    if (strbuf%chars(i) /= ch) call bad_vm_assembly
    j = i + 1
  end function skip_specific_character

  subroutine bad_vm_assembly
    write (error_unit, '("The input is not a correct virtual machine program.")')
    stop 1
  end subroutine bad_vm_assembly

end module vm_reader

module vm_runner
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds
  use, non_intrinsic :: helpers
  use, non_intrinsic :: vm_reader

  implicit none
  private

  public :: run_vm

contains

  subroutine run_vm (outp, vm)
    integer, intent(in) :: outp
    type(vm_t), intent(inout) :: vm

    logical :: done
    integer :: opcode

    vm%sp = 0
    vm%pc = 0
    done = .false.
    do while (.not. done)
       if (vm%pc < 0 .or. vm%code%length() <= vm%pc) call pc_error
       opcode = iachar (vm%code%bytes(vm%pc))
       vm%pc = vm%pc + 1
       select case (opcode)
       case (opcode_nop)
          continue
       case (opcode_halt)
          done = .true.
       case (opcode_add)
          call alu_add (vm)
       case (opcode_sub)
          call alu_sub (vm)
       case (opcode_mul)
          call alu_mul (vm)
       case (opcode_div)
          call alu_div (vm)
       case (opcode_mod)
          call alu_mod (vm)
       case (opcode_lt)
          call alu_lt (vm)
       case (opcode_gt)
          call alu_gt (vm)
       case (opcode_le)
          call alu_le (vm)
       case (opcode_ge)
          call alu_ge (vm)
       case (opcode_eq)
          call alu_eq (vm)
       case (opcode_ne)
          call alu_ne (vm)
       case (opcode_and)
          call alu_and (vm)
       case (opcode_or)
          call alu_or (vm)
       case (opcode_neg)
          call alu_neg (vm)
       case (opcode_not)
          call alu_not (vm)
       case (opcode_prtc)
          call prtc (outp, vm)
       case (opcode_prti)
          call prti (outp, vm)
       case (opcode_prts)
          call prts (outp, vm)
       case (opcode_fetch)
          call fetch_int32 (vm)
       case (opcode_store)
          call store_int32 (vm)
       case (opcode_push)
          call push_int32 (vm)
       case (opcode_jmp)
          call jmp (vm)
       case (opcode_jz)
          call jz (vm)
       case default
          write (error_unit, '("VM opcode unrecognized: ", I0)') opcode
          stop 1
       end select
    end do
  end subroutine run_vm

  subroutine push_int32 (vm)
    type(vm_t), intent(inout) :: vm

    !
    ! Push the 32-bit integer data at pc to the stack, then increment
    ! pc by 4.
    !

    if (ubound (vm%stack, 1) < vm%sp) then
       write (error_unit, '("VM stack overflow")')
       stop 1
    end if
    if (vm%code%length() <= vm%pc + 4) call pc_error
    vm%stack(vm%sp:(vm%sp + 3)) = vm%code%bytes(vm%pc:(vm%pc + 3))
    vm%sp = vm%sp + 4
    vm%pc = vm%pc + 4
  end subroutine push_int32

  subroutine fetch_int32 (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: i
    integer(kind = rik) :: x

    if (vm%code%length() <= vm%pc + 4) call pc_error
    call uint32_from_vm_bytes (i, vm%code%bytes, vm%pc)
    vm%pc = vm%pc + 4

    if (ubound (vm%data, 1) < i * 4) then
       write (error_unit, '("VM data access error")')
       stop 1
    end if
    call int32_from_vm_bytes (x, vm%data, i * 4)

    if (ubound (vm%stack, 1) < vm%sp) then
       write (error_unit, '("VM stack overflow")')
       stop 1
    end if
    call int32_to_vm_bytes (x, vm%stack, vm%sp)
    vm%sp = vm%sp + 4
  end subroutine fetch_int32

  subroutine store_int32 (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: i
    integer(kind = rik) :: x

    if (vm%code%length() <= vm%pc + 4) call pc_error
    call uint32_from_vm_bytes (i, vm%code%bytes, vm%pc)
    vm%pc = vm%pc + 4

    call ensure_there_is_enough_stack_data (vm, 4_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 4)
    vm%sp = vm%sp - 4

    if (ubound (vm%data, 1) < i * 4) then
       write (error_unit, '("VM data access error")')
       stop 1
    end if
    call int32_to_vm_bytes (x, vm%data, i * 4)
  end subroutine store_int32

  subroutine jmp (vm)
    type(vm_t), intent(inout) :: vm

    !
    ! Add the 32-bit data at pc to pc itself.
    !

    integer(kind = rik) :: x

    if (vm%code%length() <= vm%pc + 4) call pc_error
    call int32_from_vm_bytes (x, vm%code%bytes, vm%pc)
    vm%pc = vm%pc + x
  end subroutine jmp

  subroutine jz (vm)
    type(vm_t), intent(inout) :: vm

    !
    ! Conditionally add the 32-bit data at pc to pc itself.
    !

    integer(kind = rik) :: x

    call ensure_there_is_enough_stack_data (vm, 4_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 4)
    vm%sp = vm%sp - 4
    if (x == 0) then
       if (vm%code%length() <= vm%pc + 4) call pc_error
       call int32_from_vm_bytes (x, vm%code%bytes, vm%pc)
       vm%pc = vm%pc + x
    else
       vm%pc = vm%pc + 4
    end if
  end subroutine jz

  subroutine alu_neg (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x

    call ensure_there_is_enough_stack_data (vm, 4_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 4)
    x = -x
    call int32_to_vm_bytes (x, vm%stack, vm%sp - 4)
  end subroutine alu_neg

  subroutine alu_not (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x

    call ensure_there_is_enough_stack_data (vm, 4_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 4)
    x = bool2int (x == 0_rik)
    call int32_to_vm_bytes (x, vm%stack, vm%sp - 4)
  end subroutine alu_not

  subroutine alu_add (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = x + y
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_add

  subroutine alu_sub (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = x - y
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_sub

  subroutine alu_mul (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = x * y
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_mul

  subroutine alu_div (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = x / y                   ! This works like ‘/’ in C.
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_div

  subroutine alu_mod (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = mod (x, y)              ! This works like ‘%’ in C.
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_mod

  subroutine alu_lt (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x < y)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_lt

  subroutine alu_gt (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x > y)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_gt

  subroutine alu_le (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x <= y)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_le

  subroutine alu_ge (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x >= y)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_ge

  subroutine alu_eq (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x == y)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_eq

  subroutine alu_ne (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x /= y)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_ne

  subroutine alu_and (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x /= 0 .and. y /= 0)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_and

  subroutine alu_or (vm)
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x, y, z

    call ensure_there_is_enough_stack_data (vm, 8_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 8)
    call int32_from_vm_bytes (y, vm%stack, vm%sp - 4)
    z = bool2int (x /= 0 .or. y /= 0)
    call int32_to_vm_bytes (z, vm%stack, vm%sp - 8)
    vm%sp = vm%sp - 4
  end subroutine alu_or

  subroutine ensure_there_is_enough_stack_data (vm, n)
    type(vm_t), intent(in) :: vm
    integer(kind = rik), intent(in) :: n

    if (vm%sp < n) then
       write (error_unit, '("VM stack underflow")')
       stop 1
    end if
  end subroutine ensure_there_is_enough_stack_data

  subroutine prtc (outp, vm)
    integer, intent(in) :: outp
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x

    call ensure_there_is_enough_stack_data (vm, 4_rik)
    call uint32_from_vm_bytes (x, vm%stack, vm%sp - 4)
    write (outp, '(A1)', advance = 'no') char (x, kind = ck)
    vm%sp = vm%sp - 4
  end subroutine prtc

  subroutine prti (outp, vm)
    integer, intent(in) :: outp
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x

    call ensure_there_is_enough_stack_data (vm, 4_rik)
    call int32_from_vm_bytes (x, vm%stack, vm%sp - 4)
    write (outp, '(I0)', advance = 'no') x
    vm%sp = vm%sp - 4
  end subroutine prti

  subroutine prts (outp, vm)
    integer, intent(in) :: outp
    type(vm_t), intent(inout) :: vm

    integer(kind = rik) :: x
    integer(kind = rik) :: i, j

    call ensure_there_is_enough_stack_data (vm, 4_rik)
    call uint32_from_vm_bytes (x, vm%stack, vm%sp - 4)
    if (ubound (vm%string_boundaries, 1) - 1 < x) then
       write (error_unit, '("VM string boundary error")')
       stop 1
    end if
    i = vm%string_boundaries(x)
    j = vm%string_boundaries(x + 1)
    write (outp, '(A)', advance = 'no') vm%strings((i + 1):j)
    vm%sp = vm%sp - 4
  end subroutine prts

  subroutine pc_error
    write (error_unit, '("VM program counter error")')
    stop 1
  end subroutine pc_error

end module vm_runner

program vm
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds
  use, non_intrinsic :: string_buffers
  use, non_intrinsic :: vm_reader
  use, non_intrinsic :: vm_runner

  implicit none

  integer, parameter :: inp_unit_no = 100
  integer, parameter :: outp_unit_no = 101

  integer :: arg_count
  character(200) :: arg
  integer :: inp
  integer :: outp

  arg_count = command_argument_count ()
  if (3 <= arg_count) then
     call print_usage
  else
     if (arg_count == 0) then
        inp = input_unit
        outp = output_unit
     else if (arg_count == 1) then
        call get_command_argument (1, arg)
        inp = open_for_input (trim (arg))
        outp = output_unit
     else if (arg_count == 2) then
        call get_command_argument (1, arg)
        inp = open_for_input (trim (arg))
        call get_command_argument (2, arg)
        outp = open_for_output (trim (arg))
     end if

     block
       type(strbuf_t) :: strbuf
       type(vm_t) :: vm

       call read_vm (inp, strbuf, vm)
       call run_vm (outp, vm)
     end block
  end if

contains

  function open_for_input (filename) result (unit_no)
    character(*), intent(in) :: filename
    integer :: unit_no

    integer :: stat

    open (unit = inp_unit_no, file = filename, status = 'old', &
         & action = 'read', access = 'stream', form = 'unformatted',  &
         & iostat = stat)
    if (stat /= 0) then
       write (error_unit, '("Error: failed to open ", 1A, " for input")') filename
       stop 1
    end if
    unit_no = inp_unit_no
  end function open_for_input

  function open_for_output (filename) result (unit_no)
    character(*), intent(in) :: filename
    integer :: unit_no

    integer :: stat

    open (unit = outp_unit_no, file = filename, action = 'write', iostat = stat)
    if (stat /= 0) then
       write (error_unit, '("Error: failed to open ", 1A, " for output")') filename
       stop 1
    end if
    unit_no = outp_unit_no
  end function open_for_output

  subroutine print_usage
    character(200) :: progname

    call get_command_argument (0, progname)
    write (output_unit, '("Usage: ", 1A, " [INPUT_FILE [OUTPUT_FILE]]")') &
         &      trim (progname)
  end subroutine print_usage

end program vm
