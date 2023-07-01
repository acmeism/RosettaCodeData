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

module helper_procedures
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

  character(1, kind = ck), parameter :: horizontal_tab_char = char (9, kind = ck)
  character(1, kind = ck), parameter :: linefeed_char = char (10, kind = ck)
  character(1, kind = ck), parameter :: vertical_tab_char = char (11, kind = ck)
  character(1, kind = ck), parameter :: formfeed_char = char (12, kind = ck)
  character(1, kind = ck), parameter :: carriage_return_char = char (13, kind = ck)
  character(1, kind = ck), parameter :: space_char = ck_' '

  ! The following is correct for Unix and its relatives.
  character(1, kind = ck), parameter :: newline_char = linefeed_char

  character(1, kind = ck), parameter :: backslash_char = char (92, kind = ck)

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

end module helper_procedures

module string_buffers
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, intrinsic :: iso_fortran_env, only: int64
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck, ick
  use, non_intrinsic :: helper_procedures

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

module ast_reader

  !
  ! The AST will be read into an array. Perhaps that will improve
  ! locality, compared to storing the AST as many linked heap nodes.
  !
  ! In any case, implementing the AST this way is an interesting
  ! problem.
  !

  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck, ick, rik
  use, non_intrinsic :: helper_procedures, only: next_power_of_two
  use, non_intrinsic :: helper_procedures, only: new_storage_size
  use, non_intrinsic :: string_buffers
  use, non_intrinsic :: reading_one_line_from_a_stream

  implicit none
  private

  public :: string_table_t
  public :: ast_node_t
  public :: ast_t
  public :: read_ast

  integer, parameter, public :: node_Nil = 0
  integer, parameter, public :: node_Identifier = 1
  integer, parameter, public :: node_String = 2
  integer, parameter, public :: node_Integer = 3
  integer, parameter, public :: node_Sequence = 4
  integer, parameter, public :: node_If = 5
  integer, parameter, public :: node_Prtc = 6
  integer, parameter, public :: node_Prts = 7
  integer, parameter, public :: node_Prti = 8
  integer, parameter, public :: node_While = 9
  integer, parameter, public :: node_Assign = 10
  integer, parameter, public :: node_Negate = 11
  integer, parameter, public :: node_Not = 12
  integer, parameter, public :: node_Multiply = 13
  integer, parameter, public :: node_Divide = 14
  integer, parameter, public :: node_Mod = 15
  integer, parameter, public :: node_Add = 16
  integer, parameter, public :: node_Subtract = 17
  integer, parameter, public :: node_Less = 18
  integer, parameter, public :: node_LessEqual = 19
  integer, parameter, public :: node_Greater = 20
  integer, parameter, public :: node_GreaterEqual = 21
  integer, parameter, public :: node_Equal = 22
  integer, parameter, public :: node_NotEqual = 23
  integer, parameter, public :: node_And = 24
  integer, parameter, public :: node_Or = 25

  type :: string_table_element_t
     character(:, kind = ck), allocatable :: str
  end type string_table_element_t

  type :: string_table_t
     integer(kind = nk), private :: len = 0_nk
     type(string_table_element_t), allocatable, private :: strings(:)
   contains
     procedure, pass, private :: ensure_storage => string_table_t_ensure_storage
     procedure, pass :: look_up_index => string_table_t_look_up_index
     procedure, pass :: look_up_string => string_table_t_look_up_string
     procedure, pass :: length => string_table_t_length
     generic :: look_up => look_up_index
     generic :: look_up => look_up_string
  end type string_table_t

  type :: ast_node_t
     integer :: node_variety

     ! Runtime integer, symbol index, or string index.
     integer(kind = rik) :: int

     ! The left branch begins at the next node. The right branch
     ! begins at the address of the left branch, plus the following.
     integer(kind = nk) :: right_branch_offset
  end type ast_node_t

  type :: ast_t
     integer(kind = nk), private :: len = 0_nk
     type(ast_node_t), allocatable, public :: nodes(:)
   contains
     procedure, pass, private :: ensure_storage => ast_t_ensure_storage
  end type ast_t

contains

  subroutine string_table_t_ensure_storage (table, length_needed)
    class(string_table_t), intent(inout) :: table
    integer(kind = nk), intent(in) :: length_needed

    integer(kind = nk) :: len_needed
    integer(kind = nk) :: new_size
    type(string_table_t) :: new_table

    len_needed = max (length_needed, 1_nk)

    if (.not. allocated (table%strings)) then
       ! Initialize a new table%strings array.
       new_size = new_storage_size (len_needed)
       allocate (table%strings(1:new_size))
    else if (ubound (table%strings, 1) < len_needed) then
       ! Allocate a new table%strings array, larger than the current
       ! one, but containing the same strings.
       new_size = new_storage_size (len_needed)
       allocate (new_table%strings(1:new_size))
       new_table%strings(1:table%len) = table%strings(1:table%len)
       call move_alloc (new_table%strings, table%strings)
    end if
  end subroutine string_table_t_ensure_storage

  elemental function string_table_t_length (table) result (len)
    class(string_table_t), intent(in) :: table
    integer(kind = nk) :: len

    len = table%len
  end function string_table_t_length

  function string_table_t_look_up_index (table, str) result (index)
    class(string_table_t), intent(inout) :: table
    character(*, kind = ck), intent(in) :: str
    integer(kind = rik) :: index

    !
    ! This implementation simply stores the strings sequentially into
    ! an array. Obviously, for large numbers of strings, one might
    ! wish to do something more complex.
    !
    ! Standard Fortran does not come, out of the box, with a massive
    ! runtime library for doing such things. They are, however, no
    ! longer nearly as challenging to implement in Fortran as they
    ! used to be.
    !

    integer(kind = nk) :: i

    i = 1
    index = 0
    do while (index == 0)
       if (i == table%len + 1) then
          ! The string is new and must be added to the table.
          i = table%len + 1
          if (huge (1_rik) < i) then
             ! String indices are assumed to be storable as runtime
             ! integers.
             write (error_unit, '("string_table_t capacity exceeded")')
             stop 1
          end if
          call table%ensure_storage(i)
          table%len = i
          allocate (table%strings(i)%str, source = str)
          index = int (i, kind = rik)
       else if (table%strings(i)%str == str) then
          index = int (i, kind = rik)
       else
          i = i + 1
       end if
    end do
  end function string_table_t_look_up_index

  function string_table_t_look_up_string (table, index) result (str)
    class(string_table_t), intent(inout) :: table
    integer(kind = rik), intent(in) :: index
    character(:, kind = ck), allocatable :: str

    !
    ! This is the reverse of string_table_t_look_up_index: given an
    ! index, find the string.
    !

    if (index < 1 .or. table%len < index) then
       ! In correct code, this branch should never be reached.
       error stop
    else
       allocate (str, source = table%strings(index)%str)
    end if
  end function string_table_t_look_up_string

  subroutine ast_t_ensure_storage (ast, length_needed)
    class(ast_t), intent(inout) :: ast
    integer(kind = nk), intent(in) :: length_needed

    integer(kind = nk) :: len_needed
    integer(kind = nk) :: new_size
    type(ast_t) :: new_ast

    len_needed = max (length_needed, 1_nk)

    if (.not. allocated (ast%nodes)) then
       ! Initialize a new ast%nodes array.
       new_size = new_storage_size (len_needed)
       allocate (ast%nodes(1:new_size))
    else if (ubound (ast%nodes, 1) < len_needed) then
       ! Allocate a new ast%nodes array, larger than the current one,
       ! but containing the same nodes.
       new_size = new_storage_size (len_needed)
       allocate (new_ast%nodes(1:new_size))
       new_ast%nodes(1:ast%len) = ast%nodes(1:ast%len)
       call move_alloc (new_ast%nodes, ast%nodes)
    end if
  end subroutine ast_t_ensure_storage

  subroutine read_ast (unit_no, strbuf, ast, symtab, strtab)
    integer, intent(in) :: unit_no
    type(strbuf_t), intent(inout) :: strbuf
    type(ast_t), intent(inout) :: ast
    type(string_table_t), intent(inout) :: symtab
    type(string_table_t), intent(inout) :: strtab

    logical :: eof
    logical :: no_newline
    integer(kind = nk) :: after_ast_address

    ast%len = 0
    symtab%len = 0
    strtab%len = 0
    call build_subtree (1_nk, after_ast_address)

  contains

    recursive subroutine build_subtree (here_address, after_subtree_address)
      integer(kind = nk), value :: here_address
      integer(kind = nk), intent(out) :: after_subtree_address

      integer :: node_variety
      integer(kind = nk) :: i, j
      integer(kind = nk) :: left_branch_address
      integer(kind = nk) :: right_branch_address

      ! Get a line from the parser output.
      call get_line_from_stream (unit_no, eof, no_newline, strbuf)

      if (eof) then
         call ast_error
      else
         ! Prepare to store a new node.
         call ast%ensure_storage(here_address)
         ast%len = here_address

         ! What sort of node is it?
         i = skip_whitespace (strbuf, 1_nk)
         j = skip_non_whitespace (strbuf, i)
         node_variety = strbuf_to_node_variety (strbuf, i, j - 1)

         ast%nodes(here_address)%node_variety = node_variety

         select case (node_variety)
         case (node_Nil)
            after_subtree_address = here_address + 1
         case (node_Identifier)
            i = skip_whitespace (strbuf, j)
            j = skip_non_whitespace (strbuf, i)
            ast%nodes(here_address)%int = &
                 &   strbuf_to_symbol_index (strbuf, i, j - 1, symtab)
            after_subtree_address = here_address + 1
         case (node_String)
            i = skip_whitespace (strbuf, j)
            j = skip_whitespace_backwards (strbuf, strbuf%length())
            ast%nodes(here_address)%int = &
                 &   strbuf_to_string_index (strbuf, i, j, strtab)
            after_subtree_address = here_address + 1
         case (node_Integer)
            i = skip_whitespace (strbuf, j)
            j = skip_non_whitespace (strbuf, i)
            ast%nodes(here_address)%int = strbuf_to_int (strbuf, i, j - 1)
            after_subtree_address = here_address + 1
         case default
            ! The node is internal, and has left and right branches.
            ! The left branch will start at left_branch_address; the
            ! right branch will start at left_branch_address +
            ! right_side_offset.
            left_branch_address = here_address + 1
            ! Build the left branch.
            call build_subtree (left_branch_address, right_branch_address)
            ! Build the right_branch.
            call build_subtree (right_branch_address, after_subtree_address)
            ast%nodes(here_address)%right_branch_offset = &
                 &   right_branch_address - left_branch_address
         end select

      end if
    end subroutine build_subtree

  end subroutine read_ast

  function strbuf_to_node_variety (strbuf, i, j) result (node_variety)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i, j
    integer :: node_variety

    !
    ! This function has not been optimized in any way, unless the
    ! Fortran compiler can optimize it.
    !
    ! Something like a ‘radix tree search’ could be done on the
    ! characters of the strbuf. Or a perfect hash function. Or a
    ! binary search. Etc.
    !

    if (j == i - 1) then
       call ast_error
    else
       select case (strbuf%to_unicode(i, j))
       case (ck_";")
          node_variety = node_Nil
       case (ck_"Identifier")
          node_variety = node_Identifier
       case (ck_"String")
          node_variety = node_String
       case (ck_"Integer")
          node_variety = node_Integer
       case (ck_"Sequence")
          node_variety = node_Sequence
       case (ck_"If")
          node_variety = node_If
       case (ck_"Prtc")
          node_variety = node_Prtc
       case (ck_"Prts")
          node_variety = node_Prts
       case (ck_"Prti")
          node_variety = node_Prti
       case (ck_"While")
          node_variety = node_While
       case (ck_"Assign")
          node_variety = node_Assign
       case (ck_"Negate")
          node_variety = node_Negate
       case (ck_"Not")
          node_variety = node_Not
       case (ck_"Multiply")
          node_variety = node_Multiply
       case (ck_"Divide")
          node_variety = node_Divide
       case (ck_"Mod")
          node_variety = node_Mod
       case (ck_"Add")
          node_variety = node_Add
       case (ck_"Subtract")
          node_variety = node_Subtract
       case (ck_"Less")
          node_variety = node_Less
       case (ck_"LessEqual")
          node_variety = node_LessEqual
       case (ck_"Greater")
          node_variety = node_Greater
       case (ck_"GreaterEqual")
          node_variety = node_GreaterEqual
       case (ck_"Equal")
          node_variety = node_Equal
       case (ck_"NotEqual")
          node_variety = node_NotEqual
       case (ck_"And")
          node_variety = node_And
       case (ck_"Or")
          node_variety = node_Or
       case default
          call ast_error
       end select
    end if
  end function strbuf_to_node_variety

  function strbuf_to_symbol_index (strbuf, i, j, symtab) result (int)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i, j
    type(string_table_t), intent(inout) :: symtab
    integer(kind = rik) :: int

    if (j == i - 1) then
       call ast_error
    else
       int = symtab%look_up(strbuf%to_unicode (i, j))
    end if
  end function strbuf_to_symbol_index

  function strbuf_to_int (strbuf, i, j) result (int)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i, j
    integer(kind = rik) :: int

    integer :: stat
    character(:, kind = ck), allocatable :: str

    if (j < i) then
       call ast_error
    else
       allocate (character(len = (j - i) + 1_nk, kind = ck) :: str)
       str = strbuf%to_unicode (i, j)
       read (str, *, iostat = stat) int
       if (stat /= 0) then
          call ast_error
       end if
    end if
  end function strbuf_to_int

  function strbuf_to_string_index (strbuf, i, j, strtab) result (int)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i, j
    type(string_table_t), intent(inout) :: strtab
    integer(kind = rik) :: int

    if (j == i - 1) then
       call ast_error
    else
       int = strtab%look_up(strbuf_to_string (strbuf, i, j))
    end if
  end function strbuf_to_string_index

  function strbuf_to_string (strbuf, i, j) result (str)
    class(strbuf_t), intent(in) :: strbuf
    integer(kind = nk), intent(in) :: i, j
    character(:, kind = ck), allocatable :: str

    character(1, kind = ck), parameter :: linefeed_char = char (10, kind = ck)
    character(1, kind = ck), parameter :: backslash_char = char (92, kind = ck)

    ! The following is correct for Unix and its relatives.
    character(1, kind = ck), parameter :: newline_char = linefeed_char

    integer(kind = nk) :: k
    integer(kind = nk) :: count

    if (strbuf%chars(i) /= ck_'"' .or. strbuf%chars(j) /= ck_'"') then
       call ast_error
    else
       ! Count how many characters are needed.
       count = 0
       k = i + 1
       do while (k < j)
          count = count + 1
          if (strbuf%chars(k) == backslash_char) then
             k = k + 2
          else
             k = k + 1
          end if
       end do

       allocate (character(len = count, kind = ck) :: str)

       count = 0
       k = i + 1
       do while (k < j)
          if (strbuf%chars(k) == backslash_char) then
             if (k == j - 1) then
                call ast_error
             else
                select case (strbuf%chars(k + 1))
                case (ck_'n')
                   count = count + 1
                   str(count:count) = newline_char
                case (backslash_char)
                   count = count + 1
                   str(count:count) = backslash_char
                case default
                   call ast_error
                end select
                k = k + 2
             end if
          else
             count = count + 1
             str(count:count) = strbuf%chars(k)
             k = k + 1
          end if
       end do
    end if
  end function strbuf_to_string

  subroutine ast_error
    !
    ! It might be desirable to give more detail.
    !
    write (error_unit, '("The AST input seems corrupted.")')
    stop 1
  end subroutine ast_error

end module ast_reader

module code_generation

  !
  ! First we generate code as if the virtual machine itself were part
  ! of this program. Then we disassemble the generated code.
  !
  ! Because we are targeting only the one output language, this seems
  ! an easy way to perform the task.
  !
  !
  ! A point worth noting: the virtual machine is a stack
  ! architecture.
  !
  ! Stack architectures have a long history. Burroughs famously
  ! preferred stack architectures for running Algol programs. See, for
  ! instance,
  ! https://en.wikipedia.org/w/index.php?title=Burroughs_large_systems&oldid=1068076420
  !

  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds
  use, non_intrinsic :: helper_procedures
  use, non_intrinsic :: ast_reader

  implicit none
  private

  public :: generate_and_output_code
  public :: generate_code
  public :: output_code

  ! The virtual machine cannot handle integers of more than 32 bits,
  ! two’s-complement.
  integer(kind = rik), parameter :: vm_huge_negint = -(2_rik ** 31_rik)
  integer(kind = rik), parameter :: vm_huge_posint = (2_rik ** 31_rik) - 1_rik

  ! Arbitrarily chosen opcodes.
  integer, parameter :: opcode_nop = 0 ! I think there should be a nop
                                       ! opcode, to reserve space for
                                       ! later hand-patching. :)
  integer, parameter :: opcode_halt = 1 ! Does the ‘halt’ instruction
                                        ! apply brakes to the drum?
  integer, parameter :: opcode_add = 2
  integer, parameter :: opcode_sub = 3
  integer, parameter :: opcode_mul = 4
  integer, parameter :: opcode_div = 5
  integer, parameter :: opcode_mod = 6
  integer, parameter :: opcode_lt = 7
  integer, parameter :: opcode_gt = 8
  integer, parameter :: opcode_le = 9
  integer, parameter :: opcode_ge = 10
  integer, parameter :: opcode_eq = 11
  integer, parameter :: opcode_ne = 12
  integer, parameter :: opcode_and = 13
  integer, parameter :: opcode_or = 14
  integer, parameter :: opcode_neg = 15
  integer, parameter :: opcode_not = 16
  integer, parameter :: opcode_prtc = 17
  integer, parameter :: opcode_prti = 18
  integer, parameter :: opcode_prts = 19
  integer, parameter :: opcode_fetch = 20
  integer, parameter :: opcode_store = 21
  integer, parameter :: opcode_push = 22
  integer, parameter :: opcode_jmp = 23
  integer, parameter :: opcode_jz = 24

  character(8, kind = ck), parameter :: opcode_names(0:24) = &
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

  subroutine generate_and_output_code (outp, ast, symtab, strtab)
    integer, intent(in) :: outp ! The unit to write the output to.
    type(ast_t), intent(in) :: ast
    type(string_table_t), intent(inout) :: symtab
    type(string_table_t), intent(inout) :: strtab

    type(vm_code_t) :: code
    integer(kind = rik) :: i_vm

    code%len = 0
    i_vm = 0_rik
    call generate_code (ast, 1_nk, i_vm, code)
    call output_code (outp, symtab, strtab, code)
  end subroutine generate_and_output_code

  subroutine generate_code (ast, i_ast, i_vm, code)
    type(ast_t), intent(in) :: ast
    integer(kind = nk), intent(in) :: i_ast ! Index in the ast array.
    integer(kind = rik), intent(inout) :: i_vm ! Address in the virtual machine.
    type(vm_code_t), intent(inout) :: code

    call traverse (i_ast)

    ! Generate a halt instruction.
    call code%ensure_storage(i_vm + 1)
    code%bytes(i_vm) = achar (opcode_halt)
    i_vm = i_vm + 1

    code%len = i_vm

  contains

    recursive subroutine traverse (i_ast)
      integer(kind = nk), intent(in) :: i_ast ! Index in the ast array.

      select case (ast%nodes(i_ast)%node_variety)

      case (node_Nil)
         continue

      case (node_Integer)
         block
           integer(kind = rik) :: int_value

           int_value = ast%nodes(i_ast)%int
           call ensure_integer_is_vm_compatible (int_value)
           call code%ensure_storage(i_vm + 5)
           code%bytes(i_vm) = achar (opcode_push)
           call int32_to_vm_bytes (int_value, code%bytes, i_vm + 1)
           i_vm = i_vm + 5
         end block

      case (node_Identifier)
         block
           integer(kind = rik) :: variable_index

           ! In the best Fortran tradition, we indexed the variables
           ! starting at one; however, the virtual machine starts them
           ! at zero. So subtract 1.
           variable_index = ast%nodes(i_ast)%int - 1

           call ensure_integer_is_vm_compatible (variable_index)
           call code%ensure_storage(i_vm + 5)
           code%bytes(i_vm) = achar (opcode_fetch)
           call uint32_to_vm_bytes (variable_index, code%bytes, i_vm + 1)
           i_vm = i_vm + 5
         end block

      case (node_String)
         block
           integer(kind = rik) :: string_index

           ! In the best Fortran tradition, we indexed the strings
           ! starting at one; however, the virtual machine starts them
           ! at zero. So subtract 1.
           string_index = ast%nodes(i_ast)%int - 1

           call ensure_integer_is_vm_compatible (string_index)
           call code%ensure_storage(i_vm + 5)
           code%bytes(i_vm) = achar (opcode_push)
           call uint32_to_vm_bytes (string_index, code%bytes, i_vm + 1)
           i_vm = i_vm + 5
         end block

      case (node_Assign)
         block
           integer(kind = nk) :: i_left, i_right
           integer(kind = rik) :: variable_index

           i_left = left_branch (i_ast)
           i_right = right_branch (i_ast)

           ! In the best Fortran tradition, we indexed the variables
           ! starting at one; however, the virtual machine starts them
           ! at zero. So subtract 1.
           variable_index = ast%nodes(i_left)%int - 1

           ! Create code to push the right side onto the stack
           call traverse (i_right)

           ! Create code to store that result into the variable on the
           ! left side.
           call ensure_node_variety (node_Identifier, ast%nodes(i_left)%node_variety)
           call ensure_integer_is_vm_compatible (variable_index)
           call code%ensure_storage(i_vm + 5)
           code%bytes(i_vm) = achar (opcode_store)
           call uint32_to_vm_bytes (variable_index, code%bytes, i_vm + 1)
           i_vm = i_vm + 5
         end block

      case (node_Multiply)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_mul)
         i_vm = i_vm + 1

      case (node_Divide)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_div)
         i_vm = i_vm + 1

      case (node_Mod)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_mod)
         i_vm = i_vm + 1

      case (node_Add)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_add)
         i_vm = i_vm + 1

      case (node_Subtract)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_sub)
         i_vm = i_vm + 1

      case (node_Less)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_lt)
         i_vm = i_vm + 1

      case (node_LessEqual)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_le)
         i_vm = i_vm + 1

      case (node_Greater)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_gt)
         i_vm = i_vm + 1

      case (node_GreaterEqual)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_ge)
         i_vm = i_vm + 1

      case (node_Equal)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_eq)
         i_vm = i_vm + 1

      case (node_NotEqual)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_ne)
         i_vm = i_vm + 1

      case (node_Negate)
         call ensure_node_variety (node_Nil, &
              &  ast%nodes(right_branch (i_ast))%node_variety)
         call traverse (left_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_neg)
         i_vm = i_vm + 1

      case (node_Not)
         call ensure_node_variety (node_Nil, &
              &  ast%nodes(right_branch (i_ast))%node_variety)
         call traverse (left_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_not)
         i_vm = i_vm + 1

      case (node_And)
         !
         ! This is not a short-circuiting AND and so differs from
         ! C. One would not notice the difference, except in side
         ! effects that (I believe) are not possible in our tiny
         ! language.
         !
         ! Even in a language such as Fortran that has actual AND and
         ! OR operators, an optimizer may generate short-circuiting
         ! code and so spoil one’s expectations for side
         ! effects. (Therefore gfortran may issue a warning if you
         ! call an unpure function within an .AND. or
         ! .OR. expression.)
         !
         ! A C equivalent to what we have our code generator doing
         ! (and to Fortran’s .AND. operator) might be something like
         !
         !    #define AND(a, b) ((!!(a)) * (!!(b)))
         !
         ! This macro takes advantage of the equivalence of AND to
         ! multiplication modulo 2. The ‘!!’ notations are a C idiom
         ! for converting values to 0 and 1.
         !
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_and)
         i_vm = i_vm + 1

      case (node_Or)
         !
         ! This is not a short-circuiting OR and so differs from
         ! C. One would not notice the difference, except in side
         ! effects that (I believe) are not possible in our tiny
         ! language.
         !
         ! Even in a language such as Fortran that has actual AND and
         ! OR operators, an optimizer may generate short-circuiting
         ! code and so spoil one’s expectations for side
         ! effects. (Therefore gfortran may issue a warning if you
         ! call an unpure function within an .AND. or
         ! .OR. expression.)
         !
         ! A C equivalent to what we have our code generator doing
         ! (and to Fortran’s .OR. operator) might be something like
         !
         !    #define OR(a, b) (!( (!(a)) * (!(b)) ))
         !
         ! This macro takes advantage of the equivalence of AND to
         ! multiplication modulo 2, and the equivalence of OR(a,b) to
         ! !AND(!a,!b). One could instead take advantage of the
         ! equivalence of OR to addition modulo 2:
         !
         !    #define OR(a, b) ( ( (!!(a)) + (!!(b)) ) & 1 )
         !
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_or)
         i_vm = i_vm + 1

      case (node_If)
         block
           integer(kind = nk) :: i_left, i_right
           integer(kind = nk) :: i_right_then_left, i_right_then_right
           logical :: there_is_an_else_clause
           integer(kind = rik) :: fixup_address1
           integer(kind = rik) :: fixup_address2
           integer(kind = rik) :: relative_address

           i_left = left_branch (i_ast)
           i_right = right_branch (i_ast)

           call ensure_node_variety (node_If, ast%nodes(i_right)%node_variety)

           i_right_then_left = left_branch (i_right)
           i_right_then_right = right_branch (i_right)

           there_is_an_else_clause = &
                & (ast%nodes(i_right_then_right)%node_variety /= node_Nil)

           ! Generate code for the predicate.
           call traverse (i_left)

           ! Generate a conditional jump over the predicate-true code.
           call code%ensure_storage(i_vm + 5)
           code%bytes(i_vm) = achar (opcode_jz)
           call int32_to_vm_bytes (0_rik, code%bytes, i_vm + 1)
           fixup_address1 = i_vm + 1
           i_vm = i_vm + 5

           ! Generate the predicate-true code.
           call traverse (i_right_then_left)

           if (there_is_an_else_clause) then
              ! Generate an unconditional jump over the predicate-true
              ! code.
              call code%ensure_storage(i_vm + 5)
              code%bytes(i_vm) = achar (opcode_jmp)
              call int32_to_vm_bytes (0_rik, code%bytes, i_vm + 1)
              fixup_address2 = i_vm + 1
              i_vm = i_vm + 5

              ! Fix up the conditional jump, so it jumps to the
              ! predicate-false code.
              relative_address = i_vm - fixup_address1
              call int32_to_vm_bytes (relative_address, code%bytes, fixup_address1)

              ! Generate the predicate-false code.
              call traverse (i_right_then_right)

              ! Fix up the unconditional jump, so it jumps past the
              ! predicate-false code.
              relative_address = i_vm - fixup_address2
              call int32_to_vm_bytes (relative_address, code%bytes, fixup_address2)
           else
              ! Fix up the conditional jump, so it jumps past the
              ! predicate-true code.
              relative_address = i_vm - fixup_address1
              call int32_to_vm_bytes (relative_address, code%bytes, fixup_address1)
           end if
         end block

      case (node_While)
         block

           !
           ! Note there is another common way to translate a
           ! while-loop which is to put (logically inverted) predicate
           ! code *after* the loop-body code, followed by a
           ! conditional jump to the start of the loop. You start the
           ! loop by unconditionally jumping to the predicate code.
           !
           ! If our VM had a ‘jnz’ instruction, that translation would
           ! almost certainly be slightly better than this one. Given
           ! that we do not have a ‘jnz’, the code would end up
           ! slightly enlarged; one would have to put ‘not’ before the
           ! ‘jz’ at the bottom of the loop.
           !

           integer(kind = nk) :: i_left, i_right
           integer(kind = rik) :: loop_address
           integer(kind = rik) :: fixup_address
           integer(kind = rik) :: relative_address

           i_left = left_branch (i_ast)
           i_right = right_branch (i_ast)

           ! Generate code for the predicate.
           loop_address = i_vm
           call traverse (i_left)

           ! Generate a conditional jump out of the loop.
           call code%ensure_storage(i_vm + 5)
           code%bytes(i_vm) = achar (opcode_jz)
           call int32_to_vm_bytes (0_rik, code%bytes, i_vm + 1)
           fixup_address = i_vm + 1
           i_vm = i_vm + 5

           ! Generate code for the loop body.
           call traverse (i_right)

           ! Generate an unconditional jump to the top of the loop.
           call code%ensure_storage(i_vm + 5)
           code%bytes(i_vm) = achar (opcode_jmp)
           relative_address = loop_address - (i_vm + 1)
           call int32_to_vm_bytes (relative_address, code%bytes, i_vm + 1)
           i_vm = i_vm + 5

           ! Fix up the conditional jump, so it jumps after the loop
           ! body.
           relative_address = i_vm - fixup_address
           call int32_to_vm_bytes (relative_address, code%bytes, fixup_address)
         end block

      case (node_Prtc)
         call ensure_node_variety (node_Nil, &
              &  ast%nodes(right_branch (i_ast))%node_variety)
         call traverse (left_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_prtc)
         i_vm = i_vm + 1

      case (node_Prti)
         call ensure_node_variety (node_Nil, &
              &  ast%nodes(right_branch (i_ast))%node_variety)
         call traverse (left_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_prti)
         i_vm = i_vm + 1

      case (node_Prts)
         call ensure_node_variety (node_Nil, &
              &  ast%nodes(right_branch (i_ast))%node_variety)
         call traverse (left_branch (i_ast))
         call code%ensure_storage(i_vm + 1)
         code%bytes(i_vm) = achar (opcode_prts)
         i_vm = i_vm + 1

      case (node_Sequence)
         call traverse (left_branch (i_ast))
         call traverse (right_branch (i_ast))

      case default
         call bad_ast

      end select

      code%len = i_vm

    end subroutine traverse

    elemental function left_branch (i_here) result (i_left)
      integer(kind = nk), intent(in) :: i_here
      integer(kind = nk) :: i_left

      i_left = i_here + 1
    end function left_branch

    elemental function right_branch (i_here) result (i_right)
      integer(kind = nk), intent(in) :: i_here
      integer(kind = nk) :: i_right

      i_right = i_here + 1 + ast%nodes(i_here)%right_branch_offset
    end function right_branch

    subroutine ensure_node_variety (expected_node_variety, found_node_variety)
      integer, intent(in) :: expected_node_variety
      integer, intent(in) :: found_node_variety
      if (expected_node_variety /= found_node_variety) call bad_ast
    end subroutine ensure_node_variety

    subroutine bad_ast
      call codegen_error_message
      write (error_unit, '("unexpected abstract syntax")')
      stop 1
    end subroutine bad_ast

  end subroutine generate_code

  subroutine output_code (outp, symtab, strtab, code)
    integer, intent(in) :: outp ! The unit to write the output to.
    type(string_table_t), intent(inout) :: symtab
    type(string_table_t), intent(inout) :: strtab
    type(vm_code_t), intent(in) :: code

    call write_header (outp, symtab%length(), strtab%length())
    call write_strings (outp, strtab)
    call disassemble_instructions (outp, code)
  end subroutine output_code

  subroutine write_header (outp, data_size, strings_size)
    integer, intent(in) :: outp
    integer(kind = rik) :: data_size
    integer(kind = rik) :: strings_size

    call ensure_integer_is_vm_compatible (data_size)
    call ensure_integer_is_vm_compatible (strings_size)
    write (outp, '("Datasize: ", I0, " Strings: ", I0)') data_size, strings_size
  end subroutine write_header

  subroutine write_strings (outp, strtab)
    integer, intent(in) :: outp
    type(string_table_t), intent(inout) :: strtab

    integer(kind = rik) :: i

    do i = 1_rik, strtab%length()
       write (outp, '(1A)') quoted_string (strtab%look_up(i))
    end do
  end subroutine write_strings

  subroutine disassemble_instructions (outp, code)
    integer, intent(in) :: outp
    type(vm_code_t), intent(in) :: code

    integer(kind = rik) :: i_vm
    integer :: opcode
    integer(kind = rik) :: n

    i_vm = 0_rik
    do while (i_vm /= code%length())
       call write_vm_code_address (outp, i_vm)
       opcode = iachar (code%bytes(i_vm))
       call write_vm_opcode (outp, opcode)
       select case (opcode)
       case (opcode_push)
          call int32_from_vm_bytes (n, code%bytes, i_vm + 1)
          call write_vm_int_literal (outp, n)
          i_vm = i_vm + 5
       case (opcode_fetch, opcode_store)
          call uint32_from_vm_bytes (n, code%bytes, i_vm + 1)
          call write_vm_data_address (outp, n)
          i_vm = i_vm + 5
       case (opcode_jmp, opcode_jz)
          call int32_from_vm_bytes (n, code%bytes, i_vm + 1)
          call write_vm_jump_address (outp, n, i_vm + 1)
          i_vm = i_vm + 5
       case default
          i_vm = i_vm + 1
       end select
       write (outp, '()', advance = 'yes')
    end do
  end subroutine disassemble_instructions

  subroutine write_vm_code_address (outp, i_vm)
    integer, intent(in) :: outp
    integer(kind = rik), intent(in) :: i_vm

    ! 10 characters is wide enough for any 32-bit unsigned number.
    write (outp, '(I10, 1X)', advance = 'no') i_vm
  end subroutine write_vm_code_address

  subroutine write_vm_opcode (outp, opcode)
    integer, intent(in) :: outp
    integer, intent(in) :: opcode

    character(8, kind = ck) :: opcode_name

    opcode_name = opcode_names(opcode)

    select case (opcode)
    case (opcode_push, opcode_fetch, opcode_store, opcode_jz, opcode_jmp)
       write (outp, '(1A)', advance = 'no') opcode_name(1:6)
    case default
       write (outp, '(1A)', advance = 'no') trim (opcode_name)
    end select
  end subroutine write_vm_opcode

  subroutine write_vm_int_literal (outp, n)
    integer, intent(in) :: outp
    integer(kind = rik), intent(in) :: n

    write (outp, '(I0)', advance = 'no') n
  end subroutine write_vm_int_literal

  subroutine write_vm_data_address (outp, i)
    integer, intent(in) :: outp
    integer(kind = rik), intent(in) :: i

    write (outp, '("[", I0, "]")', advance = 'no') i
  end subroutine write_vm_data_address

  subroutine write_vm_jump_address (outp, relative_address, i_vm)
    integer, intent(in) :: outp
    integer(kind = rik), intent(in) :: relative_address
    integer(kind = rik), intent(in) :: i_vm

    write (outp, '(" (", I0, ") ", I0)', advance = 'no') &
         &    relative_address, i_vm + relative_address
  end subroutine write_vm_jump_address

  subroutine ensure_integer_is_vm_compatible (n)
    integer(kind = rik), intent(in) :: n
    !
    ! It would seem desirable to check this in the syntax analyzer,
    ! instead, so line and column numbers can be given. But checking
    ! here will not hurt.
    !
    if (n < vm_huge_negint .or. vm_huge_posint < n) then
       call codegen_error_message
       write (error_unit, '("integer is too large for the virtual machine: ", I0)') n
       stop 1
    end if
  end subroutine ensure_integer_is_vm_compatible

  subroutine codegen_error_message
    write (error_unit, '("Code generation error: ")', advance = 'no')
  end subroutine codegen_error_message

end module code_generation

program gen
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds
  use, non_intrinsic :: string_buffers
  use, non_intrinsic :: ast_reader
  use, non_intrinsic :: code_generation

  implicit none

  integer, parameter :: inp_unit_no = 100
  integer, parameter :: outp_unit_no = 101

  integer :: arg_count
  character(200) :: arg
  integer :: inp
  integer :: outp

  type(strbuf_t) :: strbuf
  type(ast_t) :: ast
  type(string_table_t) :: symtab
  type(string_table_t) :: strtab

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

     call read_ast (inp, strbuf, ast, symtab, strtab)
     call generate_and_output_code (outp, ast, symtab, strtab)
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

end program gen
