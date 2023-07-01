!!!
!!! An implementation of the Rosetta Code parser task:
!!! https://rosettacode.org/wiki/Compiler/syntax_analyzer
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
end module compiler_type_kinds

module string_buffers
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, intrinsic :: iso_fortran_env, only: int64
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck, ick

  implicit none
  private

  public :: strbuf_t

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

  subroutine strbuf_t_ensure_storage (strbuf, length_needed)
    class(strbuf_t), intent(inout) :: strbuf
    integer(kind = nk), intent(in) :: length_needed

    integer(kind = nk) :: new_size
    type(strbuf_t) :: new_strbuf

    if (.not. allocated (strbuf%chars)) then
       ! Initialize a new strbuf%chars array.
       new_size = new_storage_size (length_needed)
       allocate (strbuf%chars(1:new_size))
    else if (ubound (strbuf%chars, 1) < length_needed) then
       ! Allocate a new strbuf%chars array, larger than the current
       ! one, but containing the same characters.
       new_size = new_storage_size (length_needed)
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

module lexer_token_facts
  implicit none
  private

  integer, parameter, public :: tk_EOI = 0
  integer, parameter, public :: tk_Mul = 1
  integer, parameter, public :: tk_Div = 2
  integer, parameter, public :: tk_Mod = 3
  integer, parameter, public :: tk_Add = 4
  integer, parameter, public :: tk_Sub = 5
  integer, parameter, public :: tk_Negate = 6
  integer, parameter, public :: tk_Not = 7
  integer, parameter, public :: tk_Lss = 8
  integer, parameter, public :: tk_Leq = 9
  integer, parameter, public :: tk_Gtr = 10
  integer, parameter, public :: tk_Geq = 11
  integer, parameter, public :: tk_Eq = 12
  integer, parameter, public :: tk_Neq = 13
  integer, parameter, public :: tk_Assign = 14
  integer, parameter, public :: tk_And = 15
  integer, parameter, public :: tk_Or = 16
  integer, parameter, public :: tk_If = 17
  integer, parameter, public :: tk_Else = 18
  integer, parameter, public :: tk_While = 19
  integer, parameter, public :: tk_Print = 20
  integer, parameter, public :: tk_Putc = 21
  integer, parameter, public :: tk_Lparen = 22
  integer, parameter, public :: tk_Rparen = 23
  integer, parameter, public :: tk_Lbrace = 24
  integer, parameter, public :: tk_Rbrace = 25
  integer, parameter, public :: tk_Semi = 26
  integer, parameter, public :: tk_Comma = 27
  integer, parameter, public :: tk_Ident = 28
  integer, parameter, public :: tk_Integer = 29
  integer, parameter, public :: tk_String = 30
  integer, parameter, public :: tk_Positive = 31

  character(16), parameter, public :: lexer_token_string(0:31) = &
       (/ "EOI             ",   &
       &  "*               ",   &
       &  "/               ",   &
       &  "%               ",   &
       &  "+               ",   &
       &  "-               ",   &
       &  "-               ",   &
       &  "!               ",   &
       &  "<               ",   &
       &  "<=              ",   &
       &  ">               ",   &
       &  ">=              ",   &
       &  "==              ",   &
       &  "!=              ",   &
       &  "=               ",   &
       &  "&&              ",   &
       &  "||              ",   &
       &  "if              ",   &
       &  "else            ",   &
       &  "while           ",   &
       &  "print           ",   &
       &  "putc            ",   &
       &  "(               ",   &
       &  ")               ",   &
       &  "{               ",   &
       &  "}               ",   &
       &  ";               ",   &
       &  ",               ",   &
       &  "Ident           ",   &
       &  "Integer literal ",   &
       &  "String literal  ",   &
       &  "+               " /)

  integer, parameter, public :: lexer_token_arity(0:31) = &
       & (/ -1,                   & ! EOI
       &    2, 2, 2, 2, 2,        & ! * / % + -
       &    1, 1,                 & ! negate !
       &    2, 2, 2, 2, 2, 2,     & ! < <= > >= == !=
       &    -1,                   & ! =
       &    2, 2,                 & ! && ||
       &    -1, -1, -1, -1, -1,   & !
       &    -1, -1, -1, -1, -1,   & !
       &    -1, -1, -1, -1,       & !
       &    1 /)                    ! positive

  integer, parameter, public :: lexer_token_precedence(0:31) = &
       & (/ -1,                   & ! EOI
       &    13, 13, 13,           & ! * / %
       &    12, 12,               & ! + -
       &    14, 14,               & ! negate !
       &    10, 10, 10, 10,       & ! < <= > >=
       &    9, 9,                 & ! == !=
       &    -1,                   & ! =
       &    5,                    & ! &&
       &    4,                    & ! ||
       &    -1, -1, -1, -1, -1,   & !
       &    -1, -1, -1, -1, -1,   & !
       &    -1, -1, -1, -1,       & !
       &    14 /)                   ! positive

  integer, parameter, public :: left_associative = 0
  integer, parameter, public :: right_associative = 1

  ! All current operators are left associative. (The values in the
  ! array for things that are not operators are unimportant.)
  integer, parameter, public :: lexer_token_associativity(0:31) = left_associative

end module lexer_token_facts

module reading_of_lexer_tokens
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck, ick
  use, non_intrinsic :: string_buffers
  use, non_intrinsic :: reading_one_line_from_a_stream
  use, non_intrinsic :: lexer_token_facts

  implicit none
  private

  public :: lexer_token_t
  public :: get_lexer_token

  character(1, kind = ck), parameter :: horizontal_tab_char = char (9, kind = ck)
  character(1, kind = ck), parameter :: linefeed_char = char (10, kind = ck)
  character(1, kind = ck), parameter :: vertical_tab_char = char (11, kind = ck)
  character(1, kind = ck), parameter :: formfeed_char = char (12, kind = ck)
  character(1, kind = ck), parameter :: carriage_return_char = char (13, kind = ck)
  character(1, kind = ck), parameter :: space_char = ck_' '

  type :: lexer_token_t
     integer :: token_no = -(huge (1))
     character(:, kind = ck), allocatable :: val
     integer(nk) :: line_no = -(huge (1_nk))
     integer(nk) :: column_no = -(huge (1_nk))
  end type lexer_token_t

contains

  subroutine get_lexer_token (unit_no, lex_line_no, eof, token)
    !
    ! Lines that are empty or contain only whitespace are tolerated.
    !
    ! Also tolerated are comment lines, whose first character is a
    ! '!'. It is convenient for debugging to be able to comment out
    ! lines.
    !
    ! A last line be without a newline is *not* tolerated, unless it
    ! contains only whitespace.
    !
    ! Letting there be some whitespace is partly for the sake of
    ! reading cut-and-paste from a browser display.
    !
    integer, intent(in) :: unit_no
    integer(kind = nk), intent(inout) :: lex_line_no
    logical, intent(out) :: eof
    type(lexer_token_t), intent(out) :: token

    type(strbuf_t) :: strbuf
    logical :: no_newline
    logical :: input_found

    ! Let a negative setting initialize the line number.
    lex_line_no = max (0_nk, lex_line_no)

    strbuf = ''
    eof = .false.
    input_found = .false.
    do while (.not. eof .and. .not. input_found)
       call get_line_from_stream (unit_no, eof, no_newline, strbuf)
       if (eof) then
          if (no_newline) then
             lex_line_no = lex_line_no + 1
             if (.not. strbuf_is_all_whitespace (strbuf)) then
                call start_error_message (lex_line_no)
                write (error_unit, '("lexer line ends without a newline")')
                stop 1
             end if
          end if
       else
          lex_line_no = lex_line_no + 1
          input_found = .true.
          if (strbuf_is_all_whitespace (strbuf)) then
             ! A blank line.
             input_found = .false.
          else if (0 < strbuf%length()) then
             if (strbuf%chars(1) == ck_'!') then
                ! A comment line.
                input_found = .false.
             end if
          end if
       end if
    end do

    token = lexer_token_t ()
    if (.not. eof) then
       token = strbuf_to_token (lex_line_no, strbuf)
    end if
  end subroutine get_lexer_token

  function strbuf_to_token (lex_line_no, strbuf) result (token)
    integer(kind = nk), intent(in) :: lex_line_no
    class(strbuf_t), intent(in) :: strbuf
    type(lexer_token_t) :: token

    character(:, kind = ck), allocatable :: line_no
    character(:, kind = ck), allocatable :: column_no
    character(:, kind = ck), allocatable :: token_name
    character(:, kind = ck), allocatable :: val_string
    integer :: stat
    integer(kind = nk) :: n

    call split_line (lex_line_no, strbuf, line_no, column_no, token_name, val_string)

    read (line_no, *, iostat = stat) token%line_no
    if (stat /= 0) then
       call start_error_message (lex_line_no)
       write (error_unit, '("line number field is unreadable or too large")')
       stop 1
    end if

    read (column_no, *, iostat = stat) token%column_no
    if (stat /= 0) then
       call start_error_message (lex_line_no)
       write (error_unit, '("column number field is unreadable or too large")')
       stop 1
    end if

    token%token_no = token_name_to_token_no (lex_line_no, token_name)

    select case (token%token_no)
    case (tk_Ident)
       ! I do no checking of identifier names.
       allocate (token%val, source = val_string)
    case (tk_Integer)
       call check_is_all_digits (lex_line_no, val_string)
       allocate (token%val, source = val_string)
    case (tk_String)
       n = len (val_string, kind = nk)
       if (n < 2) then
          call string_literal_missing_or_no_good
       else if (val_string(1:1) /= ck_'"' .or. val_string(n:n) /= ck_'"') then
          call string_literal_missing_or_no_good
       else
          allocate (token%val, source = val_string)
       end if
    case default
       if (len (val_string, kind = nk) /= 0) then
          call start_error_message (lex_line_no)
          write (error_unit, '("token should not have a value")')
          stop 1
       end if
    end select

  contains

    subroutine string_literal_missing_or_no_good
      call start_error_message (lex_line_no)
      write (error_unit, '("""String"" token requires a string literal")')
      stop 1
    end subroutine string_literal_missing_or_no_good

  end function strbuf_to_token

  subroutine split_line (lex_line_no, strbuf, line_no, column_no, token_name, val_string)
    integer(kind = nk), intent(in) :: lex_line_no
    class(strbuf_t), intent(in) :: strbuf
    character(:, kind = ck), allocatable, intent(out) :: line_no
    character(:, kind = ck), allocatable, intent(out) :: column_no
    character(:, kind = ck), allocatable, intent(out) :: token_name
    character(:, kind = ck), allocatable, intent(out) :: val_string

    integer(kind = nk) :: i, j

    i = skip_whitespace (strbuf, 1_nk)
    j = skip_non_whitespace (strbuf, i)
    line_no = strbuf%to_unicode(i, j - 1)
    call check_is_all_digits (lex_line_no, line_no)

    i = skip_whitespace (strbuf, j)
    j = skip_non_whitespace (strbuf, i)
    column_no = strbuf%to_unicode(i, j - 1)
    call check_is_all_digits (lex_line_no, column_no)

    i = skip_whitespace (strbuf, j)
    j = skip_non_whitespace (strbuf, i)
    token_name = strbuf%to_unicode(i, j - 1)

    i = skip_whitespace (strbuf, j)
    if (strbuf%length() < i) then
       val_string = ck_''
    else if (strbuf%chars(i) == ck_'"') then
       j = skip_whitespace_backwards (strbuf, strbuf%length())
       if (strbuf%chars(j) == ck_'"') then
          val_string = strbuf%to_unicode(i, j)
       else
          call start_error_message (lex_line_no)
          write (error_unit, '("string literal does not end in a double quote")')
          stop 1
       end if
    else
       j = skip_non_whitespace (strbuf, i)
       val_string = strbuf%to_unicode(i, j - 1)
       i = skip_whitespace (strbuf, j)
       if (i <= strbuf%length()) then
          call start_error_message (lex_line_no)
          write (error_unit, '("token line contains unexpected text")')
          stop 1
       end if
    end if
  end subroutine split_line

  function token_name_to_token_no (lex_line_no, token_name) result (token_no)
    integer(kind = nk), intent(in) :: lex_line_no
    character(*, kind = ck), intent(in) :: token_name
    integer :: token_no

    !!
    !! This implementation is not optimized in any way, unless the
    !! Fortran compiler can optimize the SELECT CASE.
    !!

    select case (token_name)
    case (ck_"End_of_input")
       token_no = tk_EOI
    case (ck_"Op_multiply")
       token_no = tk_Mul
    case (ck_"Op_divide")
       token_no = tk_Div
    case (ck_"Op_mod")
       token_no = tk_Mod
    case (ck_"Op_add")
       token_no = tk_Add
    case (ck_"Op_subtract")
       token_no = tk_Sub
    case (ck_"Op_negate")
       token_no = tk_Negate
    case (ck_"Op_not")
       token_no = tk_Not
    case (ck_"Op_less")
       token_no = tk_Lss
    case (ck_"Op_lessequal    ")
       token_no = tk_Leq
    case (ck_"Op_greater")
       token_no = tk_Gtr
    case (ck_"Op_greaterequal")
       token_no = tk_Geq
    case (ck_"Op_equal")
       token_no = tk_Eq
    case (ck_"Op_notequal")
       token_no = tk_Neq
    case (ck_"Op_assign")
       token_no = tk_Assign
    case (ck_"Op_and")
       token_no = tk_And
    case (ck_"Op_or")
       token_no = tk_Or
    case (ck_"Keyword_if")
       token_no = tk_If
    case (ck_"Keyword_else")
       token_no = tk_Else
    case (ck_"Keyword_while")
       token_no = tk_While
    case (ck_"Keyword_print")
       token_no = tk_Print
    case (ck_"Keyword_putc")
       token_no = tk_Putc
    case (ck_"LeftParen")
       token_no = tk_Lparen
    case (ck_"RightParen")
       token_no = tk_Rparen
    case (ck_"LeftBrace")
       token_no = tk_Lbrace
    case (ck_"RightBrace")
       token_no = tk_Rbrace
    case (ck_"Semicolon")
       token_no = tk_Semi
    case (ck_"Comma")
       token_no = tk_Comma
    case (ck_"Identifier")
       token_no = tk_Ident
    case (ck_"Integer")
       token_no = tk_Integer
    case (ck_"String")
       token_no = tk_String
    case default
       call start_error_message (lex_line_no)
       write (error_unit, '("unrecognized token name: ", A)') token_name
       stop 1
    end select
  end function token_name_to_token_no

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

  elemental function strbuf_is_all_whitespace (strbuf) result (bool)
    class(strbuf_t), intent(in) :: strbuf
    logical :: bool

    integer(kind = nk) :: n
    integer(kind = nk) :: i

    n = strbuf%length()
    if (n == 0) then
       bool = .true.
    else
       i = 1
       bool = .true.
       do while (bool .and. i /= n + 1)
          bool = isspace (strbuf%chars(i))
          i = i + 1
       end do
    end if
  end function strbuf_is_all_whitespace

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

  elemental function isdigit (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    integer(kind = ick), parameter :: zero = ichar (ck_'0', kind = ick)
    integer(kind = ick), parameter :: nine = ichar (ck_'9', kind = ick)

    integer(kind = ick) :: i_ch

    i_ch = ichar (ch, kind = ick)
    bool = (zero <= i_ch .and. i_ch <= nine)
  end function isdigit

  subroutine check_is_all_digits (lex_line_no, str)
    integer(kind = nk), intent(in) :: lex_line_no
    character(*, kind = ck), intent(in) :: str

    integer(kind = nk) :: n
    integer(kind = nk) :: i

    n = len (str, kind = nk)
    if (n == 0_nk) then
       call start_error_message (lex_line_no)
       write (error_unit, '("a required field is missing")')
       stop 1
    else
       do i = 1, n
          if (.not. isdigit (str(i:i))) then
             call start_error_message (lex_line_no)
             write (error_unit, '("a numeric field contains a non-digit")')
             stop 1
          end if
       end do
    end if
  end subroutine check_is_all_digits

  subroutine start_error_message (lex_line_no)
    integer(kind = nk), intent(in) :: lex_line_no

    write (error_unit, '("Token stream error at line ", I0, ": ")', advance = 'no') &
         &    lex_line_no
  end subroutine start_error_message

end module reading_of_lexer_tokens

module syntactic_analysis
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: compiler_type_kinds, only: nk, ck, ick
  use, non_intrinsic :: string_buffers
  use, non_intrinsic :: lexer_token_facts
  use, non_intrinsic :: reading_of_lexer_tokens

  implicit none
  private

  public :: ast_node_t
  public :: ast_t
  public :: parse_token_stream
  public :: output_ast_flattened

  integer, parameter, public :: tk_start_of_statement = -1
  integer, parameter, public :: tk_primary = -2

  integer, parameter :: node_Identifier = 1
  integer, parameter :: node_String = 2
  integer, parameter :: node_Integer = 3
  integer, parameter :: node_Sequence = 4
  integer, parameter :: node_If = 5
  integer, parameter :: node_Prtc = 6
  integer, parameter :: node_Prts = 7
  integer, parameter :: node_Prti = 8
  integer, parameter :: node_While = 9
  integer, parameter :: node_Assign = 10
  integer, parameter :: node_Negate = 11
  integer, parameter :: node_Not = 12
  integer, parameter :: node_Multiply = 13
  integer, parameter :: node_Divide = 14
  integer, parameter :: node_Mod = 15
  integer, parameter :: node_Add = 16
  integer, parameter :: node_Subtract = 17
  integer, parameter :: node_Less = 18
  integer, parameter :: node_LessEqual = 19
  integer, parameter :: node_Greater = 20
  integer, parameter :: node_GreaterEqual = 21
  integer, parameter :: node_Equal = 22
  integer, parameter :: node_NotEqual = 23
  integer, parameter :: node_And = 24
  integer, parameter :: node_Or = 25

  character(16), parameter :: node_variety_string(1:25) = &
       (/ "Identifier      ",    &
       &  "String          ",    &
       &  "Integer         ",    &
       &  "Sequence        ",    &
       &  "If              ",    &
       &  "Prtc            ",    &
       &  "Prts            ",    &
       &  "Prti            ",    &
       &  "While           ",    &
       &  "Assign          ",    &
       &  "Negate          ",    &
       &  "Not             ",    &
       &  "Multiply        ",    &
       &  "Divide          ",    &
       &  "Mod             ",    &
       &  "Add             ",    &
       &  "Subtract        ",    &
       &  "Less            ",    &
       &  "LessEqual       ",    &
       &  "Greater         ",    &
       &  "GreaterEqual    ",    &
       &  "Equal           ",    &
       &  "NotEqual        ",    &
       &  "And             ",    &
       &  "Or              " /)

  type :: ast_node_t
     integer :: node_variety
     character(:, kind = ck), allocatable :: val
     type(ast_node_t), pointer :: left => null ()
     type(ast_node_t), pointer :: right => null ()
   contains
     procedure, pass :: assign => ast_node_t_assign
     generic :: assignment(=) => assign
     final :: ast_node_t_finalize
  end type ast_node_t

  ! ast_t phases.
  integer, parameter :: building = 1
  integer, parameter :: completed = 2

  type :: ast_t
     !
     ! This type is used to build the subtrees, as well as for the
     ! completed AST. The difference is in the setting of ‘phase’.
     !
     type(ast_node_t), pointer :: node => null ()
     integer, private :: phase = building
   contains
     procedure, pass :: assign => ast_t_assign
     generic :: assignment(=) => assign
     final :: ast_t_finalize
  end type ast_t

  type(ast_t), parameter :: ast_nil = ast_t (null ())

contains

  recursive subroutine ast_node_t_assign (node, other)
    class(ast_node_t), intent(out) :: node
    class(*), intent(in) :: other

    select type (other)
    class is (ast_node_t)
       node%node_variety = other%node_variety
       if (allocated (other%val)) allocate (node%val, source = other%val)
       if (associated (other%left)) allocate (node%left, source = other%left)
       if (associated (other%right)) allocate (node%right, source = other%right)
    class default
       ! This branch should never be reached.
       error stop
    end select
  end subroutine ast_node_t_assign

  recursive subroutine ast_node_t_finalize (node)
    type(ast_node_t), intent(inout) :: node

    if (associated (node%left)) deallocate (node%left)
    if (associated (node%right)) deallocate (node%right)
  end subroutine ast_node_t_finalize

  recursive subroutine ast_t_assign (ast, other)
    class(ast_t), intent(out) :: ast
    class(*), intent(in) :: other

    select type (other)
    class is (ast_t)
       if (associated (other%node)) allocate (ast%node, source = other%node)
       !
       ! Whether it is better to set phase to ‘building’ or to set it
       ! to ‘other%phase’ is unclear to me. Probably ‘building’ is the
       ! better choice. Which variable controls memory recovery is
       ! clear and unchanging, in that case: it is the original,
       ! ‘other’, that does.
       !
       ast%phase = building
    class default
       ! This should not happen.
       error stop
    end select
  end subroutine ast_t_assign

  subroutine ast_t_finalize (ast)
    type(ast_t), intent(inout) :: ast

    !
    ! When we are building the tree, the tree’s nodes should not be
    ! deallocated when the ast_t variable temporarily holding them
    ! goes out of scope.
    !
    ! However, once the AST is completed, we do want the memory
    ! recovered when the variable goes out of scope.
    !
    ! (Elsewhere I have written a primitive garbage collector for
    ! Fortran programs, but in this case it would be a lot of overhead
    ! for little gain. In fact, we could reasonably just let the
    ! memory leak, in this program.
    !
    ! Fortran runtimes *are* allowed by the standard to have garbage
    ! collectors built in. To my knowledge, at the time of this
    ! writing, only NAG Fortran has a garbage collector option.)
    !

    if (ast%phase == completed) then
       if (associated (ast%node)) deallocate (ast%node)
    end if
  end subroutine ast_t_finalize

  function parse_token_stream (unit_no) result (ast)
    integer, intent(in) :: unit_no
    type(ast_t) :: ast

    integer(kind = nk) :: lex_line_no
    type(ast_t) :: statement
    type(lexer_token_t) :: token

    lex_line_no = -1_nk
    call get_token (unit_no, lex_line_no, token)
    call parse_statement (unit_no, lex_line_no, token, statement)
    ast = make_internal_node (node_Sequence, ast, statement)
    do while (token%token_no /= tk_EOI)
       call parse_statement (unit_no, lex_line_no, token, statement)
       ast = make_internal_node (node_Sequence, ast, statement)
    end do
    ast%phase = completed
  end function parse_token_stream

  recursive subroutine parse_statement (unit_no, lex_line_no, token, ast)
    integer, intent(in) :: unit_no
    integer(kind = nk), intent(inout) :: lex_line_no
    type(lexer_token_t), intent(inout) :: token
    type(ast_t), intent(out) :: ast

    ast = ast_nil

    select case (token%token_no)
    case (tk_If)
       call parse_ifelse_construct
    case (tk_Putc)
       call parse_putc
    case (tk_Print)
       call parse_print
    case (tk_Semi)
       call get_token (unit_no, lex_line_no, token)
    case (tk_Ident)
       call parse_identifier
    case (tk_While)
       call parse_while_construct
    case (tk_Lbrace)
       call parse_lbrace_construct
    case (tk_EOI)
       continue
    case default
       call syntax_error_message ("", tk_start_of_statement, token)
       stop 1
    end select

  contains

    recursive subroutine parse_ifelse_construct
      type(ast_t) :: predicate
      type(ast_t) :: statement_for_predicate_true
      type(ast_t) :: statement_for_predicate_false

      call expect_token ("If", tk_If, token)
      call get_token (unit_no, lex_line_no, token)
      call parse_parenthesized_expression (unit_no, lex_line_no, token, predicate)
      call parse_statement (unit_no, lex_line_no, token, statement_for_predicate_true)
      if (token%token_no == tk_Else) then
         call get_token (unit_no, lex_line_no, token)
         call parse_statement (unit_no, lex_line_no, token, statement_for_predicate_false)
         ast = make_internal_node (node_If, statement_for_predicate_true, &
              &                    statement_for_predicate_false)
      else
         ast = make_internal_node (node_If, statement_for_predicate_true, ast_nil)
      end if
      ast = make_internal_node (node_If, predicate, ast)
    end subroutine parse_ifelse_construct

    recursive subroutine parse_putc
      type(ast_t) :: arguments

      call expect_token ("Putc", tk_Putc, token)
      call get_token (unit_no, lex_line_no, token)
      call parse_parenthesized_expression (unit_no, lex_line_no, token, arguments)
      ast = make_internal_node (node_Prtc, arguments, ast_nil)
      call expect_token ("Putc", tk_Semi, token)
      call get_token (unit_no, lex_line_no, token)
    end subroutine parse_putc

    recursive subroutine parse_print
      logical :: done
      type(ast_t) :: arg
      type(ast_t) :: printer

      call expect_token ("Print", tk_Print, token)
      call get_token (unit_no, lex_line_no, token)
      call expect_token ("Print", tk_Lparen, token)
      done = .false.
      do while (.not. done)
         call get_token (unit_no, lex_line_no, token)
         select case (token%token_no)
         case (tk_String)
            arg = make_leaf_node (node_String, token%val)
            printer = make_internal_node (node_Prts, arg, ast_nil)
            call get_token (unit_no, lex_line_no, token)
         case default
            call parse_expression (unit_no, 0, lex_line_no, token, arg)
            printer = make_internal_node (node_Prti, arg, ast_nil)
         end select
         ast = make_internal_node (node_Sequence, ast, printer)
         done = (token%token_no /= tk_Comma)
      end do
      call expect_token ("Print", tk_Rparen, token)
      call get_token (unit_no, lex_line_no, token)
      call expect_token ("Print", tk_Semi, token)
      call get_token (unit_no, lex_line_no, token)
    end subroutine parse_print

    recursive subroutine parse_identifier
      type(ast_t) :: left_side
      type(ast_t) :: right_side

      left_side = make_leaf_node (node_Identifier, token%val)
      call get_token (unit_no, lex_line_no, token)
      call expect_token ("assign", tk_Assign, token)
      call get_token (unit_no, lex_line_no, token)
      call parse_expression (unit_no, 0, lex_line_no, token, right_side)
      ast = make_internal_node (node_Assign, left_side, right_side)
      call expect_token ("assign", tk_Semi, token)
      call get_token (unit_no, lex_line_no, token)
    end subroutine parse_identifier

    recursive subroutine parse_while_construct
      type(ast_t) :: predicate
      type(ast_t) :: statement_to_be_repeated

      call expect_token ("While", tk_While, token)
      call get_token (unit_no, lex_line_no, token)
      call parse_parenthesized_expression (unit_no, lex_line_no, token, predicate)
      call parse_statement (unit_no, lex_line_no, token, statement_to_be_repeated)
      ast = make_internal_node (node_While, predicate, statement_to_be_repeated)
    end subroutine parse_while_construct

    recursive subroutine parse_lbrace_construct
      type(ast_t) :: statement

      call expect_token ("Lbrace", tk_Lbrace, token)
      call get_token (unit_no, lex_line_no, token)
      do while (token%token_no /= tk_Rbrace .and. token%token_no /= tk_EOI)
         call parse_statement (unit_no, lex_line_no, token, statement)
         ast = make_internal_node (node_Sequence, ast, statement)
      end do
      call expect_token ("Lbrace", tk_Rbrace, token)
      call get_token (unit_no, lex_line_no, token)
    end subroutine parse_lbrace_construct

  end subroutine parse_statement

  recursive subroutine parse_expression (unit_no, p, lex_line_no, token, ast)
    integer, intent(in) :: unit_no
    integer, intent(in) :: p
    integer(kind = nk), intent(inout) :: lex_line_no
    type(lexer_token_t), intent(inout) :: token
    type(ast_t), intent(out) :: ast

    integer :: precedence
    type(ast_t) :: expression

    select case (token%token_no)
    case (tk_Lparen)
       call parse_parenthesized_expression (unit_no, lex_line_no, token, ast)
    case (tk_Sub)
       token%token_no = tk_Negate
       precedence = lexer_token_precedence(token%token_no)
       call get_token (unit_no, lex_line_no, token)
       call parse_expression (unit_no, precedence, lex_line_no, token, expression)
       ast = make_internal_node (node_Negate, expression, ast_nil)
    case (tk_Add)
       token%token_no = tk_Positive
       precedence = lexer_token_precedence(token%token_no)
       call get_token (unit_no, lex_line_no, token)
       call parse_expression (unit_no, precedence, lex_line_no, token, expression)
       ast = expression
    case (tk_Not)
       precedence = lexer_token_precedence(token%token_no)
       call get_token (unit_no, lex_line_no, token)
       call parse_expression (unit_no, precedence, lex_line_no, token, expression)
       ast = make_internal_node (node_Not, expression, ast_nil)
    case (tk_Ident)
       ast = make_leaf_node (node_Identifier, token%val)
       call get_token (unit_no, lex_line_no, token)
    case (tk_Integer)
       ast = make_leaf_node (node_Integer, token%val)
       call get_token (unit_no, lex_line_no, token)
    case default
       call syntax_error_message ("", tk_primary, token)
       stop 1
    end select

    do while (lexer_token_arity(token%token_no) == 2 .and. &
         &    p <= lexer_token_precedence(token%token_no))
       block
         type(ast_t) :: right_expression
         integer :: q
         integer :: node_variety

         if (lexer_token_associativity(token%token_no) == right_associative) then
            q = lexer_token_precedence(token%token_no)
         else
            q = lexer_token_precedence(token%token_no) + 1
         end if
         node_variety = binary_operator_node_variety (token%token_no)
         call get_token (unit_no, lex_line_no, token)
         call parse_expression (unit_no, q, lex_line_no, token, right_expression)
         ast = make_internal_node (node_variety, ast, right_expression)
       end block
    end do
  end subroutine parse_expression

  recursive subroutine parse_parenthesized_expression (unit_no, lex_line_no, token, ast)
    integer, intent(in) :: unit_no
    integer(kind = nk), intent(inout) :: lex_line_no
    type(lexer_token_t), intent(inout) :: token
    type(ast_t), intent(out) :: ast

    call expect_token ("paren_expr", tk_Lparen, token)
    call get_token (unit_no, lex_line_no, token)
    call parse_expression (unit_no, 0, lex_line_no, token, ast)
    call expect_token ("paren_expr", tk_Rparen, token)
    call get_token (unit_no, lex_line_no, token)
  end subroutine parse_parenthesized_expression

  elemental function binary_operator_node_variety (token_no) result (node_variety)
    integer, intent(in) :: token_no
    integer :: node_variety

    select case (token_no)
    case (tk_Mul)
       node_variety = node_Multiply
    case (tk_Div)
       node_variety = node_Divide
    case (tk_Mod)
       node_variety = node_Mod
    case (tk_Add)
       node_variety = node_Add
    case (tk_Sub)
       node_variety = node_Subtract
    case (tk_Lss)
       node_variety = node_Less
    case (tk_Leq)
       node_variety = node_LessEqual
    case (tk_Gtr)
       node_variety = node_Greater
    case (tk_Geq)
       node_variety = node_GreaterEqual
    case (tk_Eq)
       node_variety = node_Equal
    case (tk_Neq)
       node_variety = node_NotEqual
    case (tk_And)
       node_variety = node_And
    case (tk_Or)
       node_variety = node_Or
    case default
       ! This branch should never be reached.
       error stop
    end select
  end function binary_operator_node_variety

  function make_internal_node (node_variety, left, right) result (ast)
    integer, intent(in) :: node_variety
    class(ast_t), intent(in) :: left, right
    type(ast_t) :: ast

    type(ast_node_t), pointer :: node

    allocate (node)
    node%node_variety = node_variety
    node%left => left%node
    node%right => right%node
    ast%node => node
  end function make_internal_node

  function make_leaf_node (node_variety, val) result (ast)
    integer, intent(in) :: node_variety
    character(*, kind = ck), intent(in) :: val
    type(ast_t) :: ast

    type(ast_node_t), pointer :: node

    allocate (node)
    node%node_variety = node_variety
    node%val = val
    ast%node => node
  end function make_leaf_node

  subroutine get_token (unit_no, lex_line_no, token)
    integer, intent(in) :: unit_no
    integer(kind = nk), intent(inout) :: lex_line_no
    type(lexer_token_t), intent(out) :: token

    logical :: eof

    call get_lexer_token (unit_no, lex_line_no, eof, token)
    if (eof) then
       write (error_unit, '("Parser error: the stream of input tokens is incomplete")')
       stop 1
    end if
  end subroutine get_token

  subroutine expect_token (message, token_no, token)
    character(*), intent(in) :: message
    integer, intent (in) :: token_no
    class(lexer_token_t), intent(in) :: token

    if (token%token_no /= token_no) then
       call syntax_error_message (message, token_no, token)
       stop 1
    end if
  end subroutine expect_token

  subroutine syntax_error_message (message, expected_token_no, token)
    character(*), intent(in) :: message
    integer, intent(in) :: expected_token_no
    class(lexer_token_t), intent(in) :: token

    ! Write a message to an output unit dedicated to printing
    ! errors. The message could, of course, be more detailed than what
    ! we are doing here.
    write (error_unit, '("Syntax error at ", I0, ".", I0)') &
         &    token%line_no, token%column_no

    !
    ! For the sake of the exercise, also write, to output_unit, a
    ! message in the style of the C reference program.
    !
    write (output_unit, '("(", I0, ", ", I0, ") error: ")', advance = 'no') &
         &    token%line_no, token%column_no
    select case (expected_token_no)
    case (tk_start_of_statement)
       write (output_unit, '("expecting start of statement, found ''", 1A, "''")') &
            &    trim (lexer_token_string(token%token_no))
    case (tk_primary)
       write (output_unit, '("Expecting a primary, found ''", 1A, "''")') &
            &    trim (lexer_token_string(token%token_no))
    case default
       write (output_unit, '(1A, ": Expecting ''", 1A, "'', found ''", 1A, "''")') &
            &    trim (message), trim (lexer_token_string(expected_token_no)), &
            &    trim (lexer_token_string(token%token_no))
    end select
  end subroutine syntax_error_message

  subroutine output_ast_flattened (unit_no, ast)
    integer, intent(in) :: unit_no
    type(ast_t), intent(in) :: ast

    call output_ast_node_flattened (unit_no, ast%node)
  end subroutine output_ast_flattened

  recursive subroutine output_ast_node_flattened (unit_no, node)
    integer, intent(in) :: unit_no
    type(ast_node_t), pointer, intent(in) :: node

      if (.not. associated (node)) then
         write (unit_no, '(";")')
      else
         if (allocated (node%val)) then
            write (unit_no, '(1A16, 2X, 1A)') &
                 &   node_variety_string(node%node_variety), node%val
         else
            write (unit_no, '(1A)') &
                 &   trim (node_variety_string(node%node_variety))
            call output_ast_node_flattened (unit_no, node%left)
            call output_ast_node_flattened (unit_no, node%right)
         end if
      end if
    end subroutine output_ast_node_flattened

end module syntactic_analysis

program parse
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, non_intrinsic :: syntactic_analysis

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
       type(ast_t) :: ast

       ast = parse_token_stream (inp)
       call output_ast_flattened (outp, ast)
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

end program parse
