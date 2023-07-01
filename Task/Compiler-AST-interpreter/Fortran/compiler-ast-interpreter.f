!!!
!!! An implementation of the Rosetta Code interpreter task:
!!! https://rosettacode.org/wiki/Compiler/AST_interpreter
!!!
!!! The implementation is based on the published pseudocode.
!!!

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

  ! Synonyms for integers in the runtime code.
  integer, parameter, public :: runtime_int_kind = int64
  integer, parameter, public :: rik = runtime_int_kind
end module compiler_type_kinds

module helper_procedures
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck

  implicit none
  private

  public :: new_storage_size
  public :: next_power_of_two
  public :: isspace

  character(1, kind = ck), parameter :: horizontal_tab_char = char (9, kind = ck)
  character(1, kind = ck), parameter :: linefeed_char = char (10, kind = ck)
  character(1, kind = ck), parameter :: vertical_tab_char = char (11, kind = ck)
  character(1, kind = ck), parameter :: formfeed_char = char (12, kind = ck)
  character(1, kind = ck), parameter :: carriage_return_char = char (13, kind = ck)
  character(1, kind = ck), parameter :: space_char = ck_' '

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

  public :: symbol_table_t
  public :: interpreter_ast_node_t
  public :: interpreter_ast_t
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

  type :: symbol_table_element_t
     character(:, kind = ck), allocatable :: str
  end type symbol_table_element_t

  type :: symbol_table_t
     integer(kind = nk), private :: len = 0_nk
     type(symbol_table_element_t), allocatable, private :: symbols(:)
   contains
     procedure, pass, private :: ensure_storage => symbol_table_t_ensure_storage
     procedure, pass :: look_up_index => symbol_table_t_look_up_index
     procedure, pass :: look_up_name => symbol_table_t_look_up_name
     procedure, pass :: length => symbol_table_t_length
     generic :: look_up => look_up_index
     generic :: look_up => look_up_name
  end type symbol_table_t

  type :: interpreter_ast_node_t
     integer :: node_variety
     integer(kind = rik) :: int ! Runtime integer or symbol index.
     character(:, kind = ck), allocatable :: str ! String value.

     ! The left branch begins at the next node. The right branch
     ! begins at the address of the left branch, plus the following.
     integer(kind = nk) :: right_branch_offset
  end type interpreter_ast_node_t

  type :: interpreter_ast_t
     integer(kind = nk), private :: len = 0_nk
     type(interpreter_ast_node_t), allocatable, public :: nodes(:)
   contains
     procedure, pass, private :: ensure_storage => interpreter_ast_t_ensure_storage
  end type interpreter_ast_t

contains

  subroutine symbol_table_t_ensure_storage (symtab, length_needed)
    class(symbol_table_t), intent(inout) :: symtab
    integer(kind = nk), intent(in) :: length_needed

    integer(kind = nk) :: len_needed
    integer(kind = nk) :: new_size
    type(symbol_table_t) :: new_symtab

    len_needed = max (length_needed, 1_nk)

    if (.not. allocated (symtab%symbols)) then
       ! Initialize a new symtab%symbols array.
       new_size = new_storage_size (len_needed)
       allocate (symtab%symbols(1:new_size))
    else if (ubound (symtab%symbols, 1) < len_needed) then
       ! Allocate a new symtab%symbols array, larger than the current
       ! one, but containing the same symbols.
       new_size = new_storage_size (len_needed)
       allocate (new_symtab%symbols(1:new_size))
       new_symtab%symbols(1:symtab%len) = symtab%symbols(1:symtab%len)
       call move_alloc (new_symtab%symbols, symtab%symbols)
    end if
  end subroutine symbol_table_t_ensure_storage

  elemental function symbol_table_t_length (symtab) result (len)
    class(symbol_table_t), intent(in) :: symtab
    integer(kind = nk) :: len

    len = symtab%len
  end function symbol_table_t_length

  function symbol_table_t_look_up_index (symtab, symbol_name) result (index)
    class(symbol_table_t), intent(inout) :: symtab
    character(*, kind = ck), intent(in) :: symbol_name
    integer(kind = rik) :: index

    !
    ! This implementation simply stores the symbols sequentially into
    ! an array. Obviously, for large numbers of symbols, one might
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
       if (i == symtab%len + 1) then
          ! The symbol is new and must be added to the table.
          i = symtab%len + 1
          if (huge (1_rik) < i) then
             ! Symbol indices are assumed to be storable as runtime
             ! integers.
             write (error_unit, '("There are more symbols than can be handled.")')
             stop 1
          end if
          call symtab%ensure_storage(i)
          symtab%len = i
          allocate (symtab%symbols(i)%str, source = symbol_name)
          index = int (i, kind = rik)
       else if (symtab%symbols(i)%str == symbol_name) then
          index = int (i, kind = rik)
       else
          i = i + 1
       end if
    end do
  end function symbol_table_t_look_up_index

  function symbol_table_t_look_up_name (symtab, index) result (symbol_name)
    class(symbol_table_t), intent(inout) :: symtab
    integer(kind = rik), intent(in) :: index
    character(:, kind = ck), allocatable :: symbol_name

    !
    ! This is the reverse of symbol_table_t_look_up_index: given an
    ! index, it finds the symbol’s name.
    !

    if (index < 1 .or. symtab%len < index) then
       ! In correct code, this branch should never be reached.
       error stop
    else
       allocate (symbol_name, source = symtab%symbols(index)%str)
    end if
  end function symbol_table_t_look_up_name

  subroutine interpreter_ast_t_ensure_storage (ast, length_needed)
    class(interpreter_ast_t), intent(inout) :: ast
    integer(kind = nk), intent(in) :: length_needed

    integer(kind = nk) :: len_needed
    integer(kind = nk) :: new_size
    type(interpreter_ast_t) :: new_ast

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
  end subroutine interpreter_ast_t_ensure_storage

  subroutine read_ast (unit_no, strbuf, ast, symtab)
    integer, intent(in) :: unit_no
    type(strbuf_t), intent(inout) :: strbuf
    type(interpreter_ast_t), intent(inout) :: ast
    type(symbol_table_t), intent(inout) :: symtab

    logical :: eof
    logical :: no_newline
    integer(kind = nk) :: after_ast_address

    symtab%len = 0
    ast%len = 0
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
            ast%nodes(here_address)%str = strbuf_to_string (strbuf, i, j)
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
    type(symbol_table_t), intent(inout) :: symtab
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

module ast_interpreter
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds
  use, non_intrinsic :: ast_reader

  implicit none
  private

  public :: value_t
  public :: variable_table_t
  public :: nil_value
  public :: interpret_ast_node

  integer, parameter, public :: v_Nil = 0
  integer, parameter, public :: v_Integer = 1
  integer, parameter, public :: v_String = 2

  type :: value_t
     integer :: tag = v_Nil
     integer(kind = rik) :: int_val = -(huge (1_rik))
     character(:, kind = ck), allocatable :: str_val
  end type value_t

  type :: variable_table_t
     type(value_t), allocatable :: vals(:)
   contains
     procedure, pass :: initialize => variable_table_t_initialize
  end type variable_table_t

  ! The canonical nil value.
  type(value_t), parameter :: nil_value = value_t ()

contains

  elemental function int_value (int_val) result (val)
    integer(kind = rik), intent(in) :: int_val
    type(value_t) :: val

    val%tag = v_Integer
    val%int_val = int_val
  end function int_value

  elemental function str_value (str_val) result (val)
    character(*, kind = ck), intent(in) :: str_val
    type(value_t) :: val

    val%tag = v_String
    allocate (val%str_val, source = str_val)
  end function str_value

  subroutine variable_table_t_initialize (vartab, symtab)
    class(variable_table_t), intent(inout) :: vartab
    type(symbol_table_t), intent(in) :: symtab

    allocate (vartab%vals(1:symtab%length()), source = nil_value)
  end subroutine variable_table_t_initialize

  recursive subroutine interpret_ast_node (outp, ast, symtab, vartab, address, retval)
    integer, intent(in) :: outp
    type(interpreter_ast_t), intent(in) :: ast
    type(symbol_table_t), intent(in) :: symtab
    type(variable_table_t), intent(inout) :: vartab
    integer(kind = nk) :: address
    type(value_t), intent(inout) :: retval

    integer(kind = rik) :: variable_index
    type(value_t) :: val1, val2, val3

    select case (ast%nodes(address)%node_variety)

    case (node_Nil)
       retval = nil_value

    case (node_Integer)
       retval = int_value (ast%nodes(address)%int)

    case (node_Identifier)
       variable_index = ast%nodes(address)%int
       retval = vartab%vals(variable_index)

    case (node_String)
       retval = str_value (ast%nodes(address)%str)

    case (node_Assign)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val1)
       variable_index = ast%nodes(left_branch (address))%int
       vartab%vals(variable_index) = val1
       retval = nil_value

    case (node_Multiply)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call multiply (val1, val2, val3)
       retval = val3

    case (node_Divide)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call divide (val1, val2, val3)
       retval = val3

    case (node_Mod)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call pseudo_remainder (val1, val2, val3)
       retval = val3

    case (node_Add)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call add (val1, val2, val3)
       retval = val3

    case (node_Subtract)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call subtract (val1, val2, val3)
       retval = val3

    case (node_Less)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call less_than (val1, val2, val3)
       retval = val3

    case (node_LessEqual)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call less_than_or_equal_to (val1, val2, val3)
       retval = val3

    case (node_Greater)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call greater_than (val1, val2, val3)
       retval = val3

    case (node_GreaterEqual)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call greater_than_or_equal_to (val1, val2, val3)
       retval = val3

    case (node_Equal)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call equal_to (val1, val2, val3)
       retval = val3

    case (node_NotEqual)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       call not_equal_to (val1, val2, val3)
       retval = val3

    case (node_Negate)
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      retval = int_value (-(rik_cast (val1, ck_'unary ''-''')))

    case (node_Not)
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      retval = int_value (bool2int (rik_cast (val1, ck_'unary ''!''') == 0_rik))

    case (node_And)
      ! For similarity to C, we make this a ‘short-circuiting AND’,
      ! which is really a branching construct rather than a binary
      ! operation.
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      if (rik_cast (val1, ck_'''&&''') == 0_rik) then
         retval = int_value (0_rik)
      else
         call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
         retval = int_value (bool2int (rik_cast (val2, ck_'''&&''') /= 0_rik))
      end if

    case (node_Or)
      ! For similarity to C, we make this a ‘short-circuiting OR’,
      ! which is really a branching construct rather than a binary
      ! operation.
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      if (rik_cast (val1, ck_'''||''') /= 0_rik) then
         retval = int_value (1_rik)
      else
         call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
         retval = int_value (bool2int (rik_cast (val2, ck_'''||''') /= 0_rik))
      end if

    case (node_If)
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      if (rik_cast (val1, ck_'''if-else'' construct') /= 0_rik) then
         call interpret_ast_node (outp, ast, symtab, vartab, &
              &                   left_branch (right_branch (address)), &
              &                   val2)
      else
         call interpret_ast_node (outp, ast, symtab, vartab, &
              &                   right_branch (right_branch (address)), &
              &                   val2)
      end if
      retval = nil_value

    case (node_While)
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      do while (rik_cast (val1, ck_'''while'' construct') /= 0_rik)
         call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
         call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      end do
      retval = nil_value

    case (node_Prtc)
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      write (outp, '(A1)', advance = 'no') &
           &    char (rik_cast (val1, ck_'''putc'''), kind = ck)
      retval = nil_value

    case (node_Prti, node_Prts)
      call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
      select case (val1%tag)
      case (v_Integer)
         write (outp, '(I0)', advance = 'no') val1%int_val
      case (v_String)
         write (outp, '(A)', advance = 'no') val1%str_val
      case (v_Nil)
         write (outp, '("(no value)")', advance = 'no')
      case default
         error stop
      end select
      retval = nil_value

    case (node_Sequence)
       call interpret_ast_node (outp, ast, symtab, vartab, left_branch (address), val1)
       call interpret_ast_node (outp, ast, symtab, vartab, right_branch (address), val2)
       retval = nil_value

    case default
       write (error_unit, '("unknown node type")')
       stop 1

    end select

  contains

    elemental function left_branch (here_addr) result (left_addr)
      integer(kind = nk), intent(in) :: here_addr
      integer(kind = nk) :: left_addr

      left_addr = here_addr + 1
    end function left_branch

    elemental function right_branch (here_addr) result (right_addr)
      integer(kind = nk), intent(in) :: here_addr
      integer(kind = nk) :: right_addr

      right_addr = here_addr + 1 + ast%nodes(here_addr)%right_branch_offset
    end function right_branch

  end subroutine interpret_ast_node

  subroutine multiply (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'*'

    z = int_value (rik_cast (x, op) * rik_cast (y, op))
  end subroutine multiply

  subroutine divide (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'/'

    ! Fortran integer division truncates towards zero, as C’s does.
    z = int_value (rik_cast (x, op) / rik_cast (y, op))
  end subroutine divide

  subroutine pseudo_remainder (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    !
    ! I call this ‘pseudo-remainder’ because I consider ‘remainder’ to
    ! mean the *non-negative* remainder in A = (B * Quotient) +
    ! Remainder. See https://doi.org/10.1145%2F128861.128862
    !
    ! The pseudo-remainder gives the actual remainder, if both
    ! operands are positive.
    !

    character(*, kind = ck), parameter :: op = ck_'binary ''%'''

    ! Fortran’s MOD intrinsic, when given integer arguments, works
    ! like C ‘%’.
    z = int_value (mod (rik_cast (x, op), rik_cast (y, op)))
  end subroutine pseudo_remainder

  subroutine add (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''+'''

    z = int_value (rik_cast (x, op) + rik_cast (y, op))
  end subroutine add

  subroutine subtract (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''-'''

    z = int_value (rik_cast (x, op) - rik_cast (y, op))
  end subroutine subtract

  subroutine less_than (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''<'''

    z = int_value (bool2int (rik_cast (x, op) < rik_cast (y, op)))
  end subroutine less_than

  subroutine less_than_or_equal_to (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''<='''

    z = int_value (bool2int (rik_cast (x, op) <= rik_cast (y, op)))
  end subroutine less_than_or_equal_to

  subroutine greater_than (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''>'''

    z = int_value (bool2int (rik_cast (x, op) > rik_cast (y, op)))
  end subroutine greater_than

  subroutine greater_than_or_equal_to (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''>='''

    z = int_value (bool2int (rik_cast (x, op) >= rik_cast (y, op)))
  end subroutine greater_than_or_equal_to

  subroutine equal_to (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''=='''

    z = int_value (bool2int (rik_cast (x, op) == rik_cast (y, op)))
  end subroutine equal_to

  subroutine not_equal_to (x, y, z)
    type(value_t), intent(in) :: x, y
    type(value_t), intent(out) :: z

    character(*, kind = ck), parameter :: op = ck_'binary ''!='''

    z = int_value (bool2int (rik_cast (x, op) /= rik_cast (y, op)))
  end subroutine not_equal_to

  function rik_cast (val, operation_name) result (i_val)
    class(*), intent(in) :: val
    character(*, kind = ck), intent(in) :: operation_name
    integer(kind = rik) :: i_val

    select type (val)
    class is (value_t)
       if (val%tag == v_Integer) then
          i_val = val%int_val
       else
          call type_error (operation_name)
       end if
    type is (integer(kind = rik))
       i_val = val
    class default
       call type_error (operation_name)
    end select
  end function rik_cast

  elemental function bool2int (bool) result (int)
    logical, intent(in) :: bool
    integer(kind = rik) :: int

    if (bool) then
       int = 1_rik
    else
       int = 0_rik
    end if
  end function bool2int

  subroutine type_error (operation_name)
    character(*, kind = ck), intent(in) :: operation_name

    write (error_unit, '("type error in ", A)') operation_name
    stop 1
  end subroutine type_error

end module ast_interpreter

program Interp
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds
  use, non_intrinsic :: string_buffers
  use, non_intrinsic :: ast_reader
  use, non_intrinsic :: ast_interpreter

  implicit none

  integer, parameter :: inp_unit_no = 100
  integer, parameter :: outp_unit_no = 101

  integer :: arg_count
  character(200) :: arg
  integer :: inp
  integer :: outp

  type(strbuf_t) :: strbuf
  type(interpreter_ast_t) :: ast
  type(symbol_table_t) :: symtab
  type(variable_table_t) :: vartab
  type(value_t) :: retval

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

     call read_ast (inp, strbuf, ast, symtab)
     if (1 <= ubound (ast%nodes, 1)) then
        call vartab%initialize(symtab)
        call interpret_ast_node (outp, ast, symtab, vartab, 1_nk, retval)
     end if
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

end program Interp
