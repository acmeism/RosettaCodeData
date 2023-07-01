!!!
!!! An implementation of the Rosetta Code lexical analyzer task:
!!! https://rosettacode.org/wiki/Compiler/lexical_analyzer
!!!
!!! The C implementation was used as a reference on behavior, but was
!!! not adhered to for the implementation.
!!!

module string_buffers
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, intrinsic :: iso_fortran_env, only: int64

  implicit none
  private

  public :: strbuf_t
  public :: strbuf_t_length_kind
  public :: strbuf_t_character_kind

  integer, parameter :: strbuf_t_length_kind = int64

  ! String buffers can handle Unicode.
  integer, parameter :: strbuf_t_character_kind = selected_char_kind ('ISO_10646')

  ! Private abbreviations.
  integer, parameter :: nk = strbuf_t_length_kind
  integer, parameter :: ck = strbuf_t_character_kind

  type :: strbuf_t
     integer(kind = nk), private :: len = 0
     !
     ! ‘chars’ is made public for efficient access to the individual
     ! characters.
     !
     character(1, kind = ck), allocatable, public :: chars(:)
   contains
     procedure, pass, private :: ensure_storage => strbuf_t_ensure_storage
     procedure, pass :: to_unicode => strbuf_t_to_unicode
     procedure, pass :: length => strbuf_t_length
     procedure, pass :: set => strbuf_t_set
     procedure, pass :: append => strbuf_t_append
     generic :: assignment(=) => set
  end type strbuf_t

contains

  function strbuf_t_to_unicode (strbuf) result (s)
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
  end function strbuf_t_to_unicode

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

module lexical_analysis
  use, intrinsic :: iso_fortran_env, only: input_unit
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, intrinsic :: iso_fortran_env, only: error_unit
  use, intrinsic :: iso_fortran_env, only: int32
  use, non_intrinsic :: string_buffers

  implicit none
  private

  public :: lexer_input_t
  public :: lexer_output_t
  public :: run_lexer

  integer, parameter :: input_file_unit_no = 100
  integer, parameter :: output_file_unit_no = 101

  ! Private abbreviations.
  integer, parameter :: nk = strbuf_t_length_kind
  integer, parameter :: ck = strbuf_t_character_kind

  ! Integers large enough for a Unicode code point. Unicode code
  ! points (and UCS-4) have never been allowed to go higher than
  ! 7FFFFFFF, and are even further restricted now.
  integer, parameter :: ichar_kind = int32

  character(1, kind = ck), parameter :: horizontal_tab_char = char (9, kind = ck)
  character(1, kind = ck), parameter :: linefeed_char = char (10, kind = ck)
  character(1, kind = ck), parameter :: vertical_tab_char = char (11, kind = ck)
  character(1, kind = ck), parameter :: formfeed_char = char (12, kind = ck)
  character(1, kind = ck), parameter :: carriage_return_char = char (13, kind = ck)
  character(1, kind = ck), parameter :: space_char = ck_' '

  ! The following is correct for Unix and its relatives.
  character(1, kind = ck), parameter :: newline_char = linefeed_char

  character(1, kind = ck), parameter :: backslash_char = char (92, kind = ck)

  character(*, kind = ck), parameter :: newline_intstring = ck_'10'
  character(*, kind = ck), parameter :: backslash_intstring = ck_'92'

  integer, parameter :: tk_EOI = 0
  integer, parameter :: tk_Mul = 1
  integer, parameter :: tk_Div = 2
  integer, parameter :: tk_Mod = 3
  integer, parameter :: tk_Add = 4
  integer, parameter :: tk_Sub = 5
  integer, parameter :: tk_Negate = 6
  integer, parameter :: tk_Not = 7
  integer, parameter :: tk_Lss = 8
  integer, parameter :: tk_Leq = 9
  integer, parameter :: tk_Gtr = 10
  integer, parameter :: tk_Geq = 11
  integer, parameter :: tk_Eq = 12
  integer, parameter :: tk_Neq = 13
  integer, parameter :: tk_Assign = 14
  integer, parameter :: tk_And = 15
  integer, parameter :: tk_Or = 16
  integer, parameter :: tk_If = 17
  integer, parameter :: tk_Else = 18
  integer, parameter :: tk_While = 19
  integer, parameter :: tk_Print = 20
  integer, parameter :: tk_Putc = 21
  integer, parameter :: tk_Lparen = 22
  integer, parameter :: tk_Rparen = 23
  integer, parameter :: tk_Lbrace = 24
  integer, parameter :: tk_Rbrace = 25
  integer, parameter :: tk_Semi = 26
  integer, parameter :: tk_Comma = 27
  integer, parameter :: tk_Ident = 28
  integer, parameter :: tk_Integer = 29
  integer, parameter :: tk_String = 30

  character(len = 16), parameter :: token_names(0:30) = &
       & (/ "End_of_input    ", "Op_multiply     ", "Op_divide       ", "Op_mod          ", "Op_add          ", &
       &    "Op_subtract     ", "Op_negate       ", "Op_not          ", "Op_less         ", "Op_lessequal    ", &
       &    "Op_greater      ", "Op_greaterequal ", "Op_equal        ", "Op_notequal     ", "Op_assign       ", &
       &    "Op_and          ", "Op_or           ", "Keyword_if      ", "Keyword_else    ", "Keyword_while   ", &
       &    "Keyword_print   ", "Keyword_putc    ", "LeftParen       ", "RightParen      ", "LeftBrace       ", &
       &    "RightBrace      ", "Semicolon       ", "Comma           ", "Identifier      ", "Integer         ", &
       &    "String          " /)

  type :: token_t
     integer :: token_no

     ! Our implementation stores the value of a tk_Integer as a
     ! string. The C reference implementation stores it as an int.
     character(:, kind = ck), allocatable :: val

     integer(nk) :: line_no
     integer(nk) :: column_no
  end type token_t

  type :: lexer_input_t
     logical, private :: using_input_unit = .true.
     integer, private :: unit_no = -(huge (1))
     integer(kind = nk) :: line_no = 1
     integer(kind = nk) :: column_no = 0
     integer, private :: unget_count = 0

     ! The maximum lookahead is 2, although I believe we are using
     ! only 1. In principle, the lookahead could be any finite number.
     character(1, kind = ck), private :: unget_buffer(1:2)
     logical, private :: unget_eof_buffer(1:2)

     ! Using the same strbuf_t multiple times reduces the need for
     ! reallocations. Putting that strbuf_t in the lexer_input_t is
     ! simply for convenience.
     type(strbuf_t), private :: strbuf

   contains
     !
     ! Note: There is currently no facility for closing one input and
     !       switching to another.
     !
     ! Note: There is currently no facility to decode inputs into
     !       Unicode codepoints. Instead, what happens is raw bytes of
     !       input get stored as strbuf_t_character_kind values. This
     !       behavior is adequate for ASCII inputs.
     !
     procedure, pass :: use_file => lexer_input_t_use_file
     procedure, pass :: get_next_ch => lexer_input_t_get_next_ch
     procedure, pass :: unget_ch => lexer_input_t_unget_ch
     procedure, pass :: unget_eof => lexer_input_t_unget_eof
  end type lexer_input_t

  type :: lexer_output_t
     integer, private :: unit_no = output_unit
   contains
     procedure, pass :: use_file => lexer_output_t_use_file
     procedure, pass :: output_token => lexer_output_t_output_token
  end type lexer_output_t

contains

  subroutine lexer_input_t_use_file (inputter, filename)
    class(lexer_input_t), intent(inout) :: inputter
    character(*), intent(in) :: filename

    integer :: stat

    inputter%using_input_unit = .false.
    inputter%unit_no = input_file_unit_no
    inputter%line_no = 1
    inputter%column_no = 0

    open (unit = input_file_unit_no, file = filename, status = 'old', &
         & action = 'read', access = 'stream', form = 'unformatted',  &
         & iostat = stat)
    if (stat /= 0) then
       write (error_unit, '("Error: failed to open ", A, " for input")') filename
       stop 1
    end if
  end subroutine lexer_input_t_use_file

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

  subroutine lexer_input_t_get_next_ch (inputter, eof, ch)
    class(lexer_input_t), intent(inout) :: inputter
    logical, intent(out) :: eof
    character(1, kind = ck), intent(inout) :: ch

    integer :: stat
    character(1) :: c = '*'

    if (0 < inputter%unget_count) then
       if (inputter%unget_eof_buffer(inputter%unget_count)) then
          eof = .true.
       else
          eof = .false.
          ch = inputter%unget_buffer(inputter%unget_count)
       end if
       inputter%unget_count = inputter%unget_count - 1
    else
       if (inputter%using_input_unit) then
          call get_input_unit_char (c, stat)
       else
          read (unit = inputter%unit_no, iostat = stat) c
       end if

       ch = char (ichar (c, kind = ichar_kind), kind = ck)

       if (0 < stat) then
          write (error_unit, '("Input error with status code ", I0)') stat
          stop 1
       else if (stat < 0) then
          eof = .true.
          ! The C reference code increases column number on end of file;
          ! therefore, so shall we.
          inputter%column_no = inputter%column_no + 1
       else
          eof = .false.
          if (ch == newline_char) then
             inputter%line_no = inputter%line_no + 1
             inputter%column_no = 0
          else
             inputter%column_no = inputter%column_no + 1
          end if
       end if
    end if
  end subroutine lexer_input_t_get_next_ch

  subroutine lexer_input_t_unget_ch (inputter, ch)
    class(lexer_input_t), intent(inout) :: inputter
    character(1, kind = ck), intent(in) :: ch

    if (ubound (inputter%unget_buffer, 1) <= inputter%unget_count) then
       write (error_unit, '("class(lexer_input_t) unget buffer overflow")')
       stop 1
    else
       inputter%unget_count = inputter%unget_count + 1
       inputter%unget_buffer(inputter%unget_count) = ch
       inputter%unget_eof_buffer(inputter%unget_count) = .false.
    end if
  end subroutine lexer_input_t_unget_ch

  subroutine lexer_input_t_unget_eof (inputter)
    class(lexer_input_t), intent(inout) :: inputter

    if (ubound (inputter%unget_buffer, 1) <= inputter%unget_count) then
       write (error_unit, '("class(lexer_input_t) unget buffer overflow")')
       stop 1
    else
       inputter%unget_count = inputter%unget_count + 1
       inputter%unget_buffer(inputter%unget_count) = ck_'*'
       inputter%unget_eof_buffer(inputter%unget_count) = .true.
    end if
  end subroutine lexer_input_t_unget_eof

  subroutine lexer_output_t_use_file (outputter, filename)
    class(lexer_output_t), intent(inout) :: outputter
    character(*), intent(in) :: filename

    integer :: stat

    outputter%unit_no = output_file_unit_no
    open (unit = output_file_unit_no, file = filename, action = 'write', iostat = stat)
    if (stat /= 0) then
       write (error_unit, '("Error: failed to open ", A, " for output")') filename
       stop 1
    end if
  end subroutine lexer_output_t_use_file

  subroutine lexer_output_t_output_token (outputter, token)
    class(lexer_output_t), intent(inout) :: outputter
    class(token_t), intent(in) :: token

    select case (token%token_no)
    case (tk_Integer, tk_Ident, tk_String)
       write (outputter%unit_no, '(1X, I20, 1X, I20, 1X, A, 1X, A)')  &
            &    token%line_no, token%column_no,                      &
            &    token_names(token%token_no), token%val
    case default
       write (outputter%unit_no, '(1X, I20, 1X, I20, 1X, A)')         &
            &    token%line_no, token%column_no,                      &
            &    trim (token_names(token%token_no))
    end select
  end subroutine lexer_output_t_output_token

  subroutine run_lexer (inputter, outputter)
    class(lexer_input_t), intent(inout) :: inputter
    class(lexer_output_t), intent(inout) :: outputter

    type(token_t) :: token

    token = get_token (inputter)
    do while (token%token_no /= tk_EOI)
       call outputter%output_token (token)
       token = get_token (inputter)
    end do
    call outputter%output_token (token)
  end subroutine run_lexer

  function get_token (inputter) result (token)
    class(lexer_input_t), intent(inout) :: inputter
    type(token_t) :: token

    logical :: eof
    character(1, kind = ck) :: ch

    call skip_spaces_and_comments (inputter, eof, ch,              &
         &                         token%line_no, token%column_no)

    if (eof) then
       token%token_no = tk_EOI
    else
       select case (ch)
       case (ck_'{')
          token%token_no = tk_Lbrace
       case (ck_'}')
          token%token_no = tk_Rbrace
       case (ck_'(')
          token%token_no = tk_Lparen
       case (ck_')')
          token%token_no = tk_Rparen
       case (ck_'+')
          token%token_no = tk_Add
       case (ck_'-')
          token%token_no = tk_Sub
       case (ck_'*')
          token%token_no = tk_Mul
       case (ck_'%')
          token%token_no = tk_Mod
       case (ck_';')
          token%token_no = tk_Semi
       case (ck_',')
          token%token_no = tk_Comma
       case (ck_'/')
          token%token_no = tk_Div

       case (ck_"'")
          call read_character_literal

       case (ck_'<')
          call distinguish_operators (ch, ck_'=', tk_Leq, tk_Lss)
       case (ck_'>')
          call distinguish_operators (ch, ck_'=', tk_Geq, tk_Gtr)
       case (ck_'=')
          call distinguish_operators (ch, ck_'=', tk_Eq, tk_Assign)
       case (ck_'!')
          call distinguish_operators (ch, ck_'=', tk_Neq, tk_Not)
       case (ck_'&')
          call distinguish_operators (ch, ck_'&', tk_And, tk_EOI)
       case (ck_'|')
          call distinguish_operators (ch, ck_'|', tk_Or, tk_EOI)

       case (ck_'"')
          call read_string_literal (ch, ch)

       case default
          if (isdigit (ch)) then
             call read_numeric_literal (ch)
          else if (isalpha_or_underscore (ch)) then
             call read_identifier_or_keyword (ch)
          else
             call start_error_message (inputter)
             write (error_unit, '("unrecognized character ''", A, "''")') ch
             stop 1
          end if
       end select
    end if
  contains

    subroutine read_character_literal
      character(1, kind = ck) :: ch
      logical :: eof
      character(20, kind = ck) :: buffer

      token%token_no = tk_Integer

      call inputter%get_next_ch (eof, ch)
      if (eof) then
         call start_error_message (inputter)
         write (error_unit, '("end of input in character literal")')
         stop 1
      else if (ch == ck_"'") then
         call start_error_message (inputter)
         write (error_unit, '("empty character literal")')
         stop 1
      else if (ch == backslash_char) then
         call inputter%get_next_ch (eof, ch)
         if (eof) then
            call start_error_message (inputter)
            write (error_unit, '("end of input in character literal, after backslash")')
            stop 1
         else if (ch == ck_'n') then
            allocate (token%val, source = newline_intstring)
         else if (ch == backslash_char) then
            allocate (token%val, source = backslash_intstring)
         else
            call start_error_message (inputter)
            write (error_unit, '("unknown escape sequence ''", A, A, "'' in character literal")') &
                 &    backslash_char, ch
            stop 1
         end if
         call read_character_literal_close_quote
      else
         call read_character_literal_close_quote
         write (buffer, '(I0)') ichar (ch, kind = ichar_kind)
         allocate (token%val, source = trim (buffer))
      end if
    end subroutine read_character_literal

    subroutine read_character_literal_close_quote
      logical :: eof
      character(1, kind = ck) :: close_quote

      call inputter%get_next_ch (eof, close_quote)
      if (eof) then
         call start_error_message (inputter)
         write (error_unit, '("end of input in character literal")')
         stop 1
      else if (close_quote /= ck_"'") then
         call start_error_message (inputter)
         write (error_unit, '("multi-character literal")')
         stop 1
      end if
    end subroutine read_character_literal_close_quote

    subroutine distinguish_operators (first_ch, second_ch,      &
         &                            token_no_if_second_ch,    &
         &                            token_no_if_no_second_ch)
      character(1, kind = ck), intent(in) :: first_ch
      character(1, kind = ck), intent(in) :: second_ch
      integer, intent(in) :: token_no_if_second_ch
      integer, intent(in) :: token_no_if_no_second_ch

      character(1, kind = ck) :: ch
      logical :: eof

      call inputter%get_next_ch (eof, ch)
      if (eof) then
         call inputter%unget_eof
         token%token_no = token_no_if_no_second_ch
      else if (ch == second_ch) then
         token%token_no = token_no_if_second_ch
      else if (token_no_if_no_second_ch == tk_EOI) then
         call start_error_message (inputter)
         write (error_unit, '("unrecognized character ''", A, "''")') first_ch
         stop 1
      else
         call inputter%unget_ch (ch)
         token%token_no = token_no_if_no_second_ch
      end if
    end subroutine distinguish_operators

    subroutine read_string_literal (opening_quote, closing_quote)
      character(1, kind = ck), intent(in) :: opening_quote
      character(1, kind = ck), intent(in) :: closing_quote

      character(1, kind = ck) :: ch
      logical :: done

      inputter%strbuf = opening_quote
      done = .false.
      do while (.not. done)
         call inputter%get_next_ch (eof, ch)
         if (eof) then
            call start_error_message (inputter)
            write (error_unit, '("end of input in string literal")')
            stop 1
         else if (ch == closing_quote) then
            call inputter%strbuf%append(ch)
            done = .true.
         else if (ch == newline_char) then
            call start_error_message (inputter)
            write (error_unit, '("end of line in string literal")')
            stop 1
         else
            call inputter%strbuf%append(ch)
         end if
      end do
      allocate (token%val, source = inputter%strbuf%to_unicode())
      token%token_no = tk_String
    end subroutine read_string_literal

    subroutine read_numeric_literal (first_ch)
      character(1, kind = ck), intent(in) :: first_ch

      character(1, kind = ck) :: ch

      token%token_no = tk_Integer

      inputter%strbuf = first_ch
      call inputter%get_next_ch (eof, ch)
      do while (isdigit (ch))
         call inputter%strbuf%append (ch)
         call inputter%get_next_ch (eof, ch)
      end do
      if (isalpha_or_underscore (ch)) then
         call start_error_message (inputter)
         write (error_unit, '("invalid numeric literal """, A, """")') &
              &    inputter%strbuf%to_unicode()
         stop 1
      else
         call inputter%unget_ch (ch)
         allocate (token%val, source = inputter%strbuf%to_unicode())
      end if
    end subroutine read_numeric_literal

    subroutine read_identifier_or_keyword (first_ch)
      character(1, kind = ck), intent(in) :: first_ch

      character(1, kind = ck) :: ch

      inputter%strbuf = first_ch
      call inputter%get_next_ch (eof, ch)
      do while (isalnum_or_underscore (ch))
         call inputter%strbuf%append (ch)
         call inputter%get_next_ch (eof, ch)
      end do

      call inputter%unget_ch (ch)

      !
      ! The following is a handwritten ‘implicit radix tree’ search
      ! for keywords, first partitioning the set of keywords according
      ! to their lengths.
      !
      ! I did it this way for fun. One could, of course, write a
      ! program to generate code for such a search.
      !
      ! Perfect hashes are another method one could use.
      !
      ! The reference C implementation uses a binary search.
      !
      token%token_no = tk_Ident
      select case (inputter%strbuf%length())
      case (2)
         select case (inputter%strbuf%chars(1))
         case (ck_'i')
            select case (inputter%strbuf%chars(2))
            case (ck_'f')
               token%token_no = tk_If
            case default
               continue
            end select
         case default
            continue
         end select
      case (4)
         select case (inputter%strbuf%chars(1))
         case (ck_'e')
            select case (inputter%strbuf%chars(2))
            case (ck_'l')
               select case (inputter%strbuf%chars(3))
               case (ck_'s')
                  select case (inputter%strbuf%chars(4))
                  case (ck_'e')
                     token%token_no = tk_Else
                  case default
                     continue
                  end select
               case default
                  continue
               end select
            case default
               continue
            end select
         case (ck_'p')
            select case (inputter%strbuf%chars(2))
            case (ck_'u')
               select case (inputter%strbuf%chars(3))
               case (ck_'t')
                  select case (inputter%strbuf%chars(4))
                  case (ck_'c')
                     token%token_no = tk_Putc
                  case default
                     continue
                  end select
               case default
                  continue
               end select
            case default
               continue
            end select
         case default
            continue
         end select
      case (5)
         select case (inputter%strbuf%chars(1))
         case (ck_'p')
            select case (inputter%strbuf%chars(2))
            case (ck_'r')
               select case (inputter%strbuf%chars(3))
               case (ck_'i')
                  select case (inputter%strbuf%chars(4))
                  case (ck_'n')
                     select case (inputter%strbuf%chars(5))
                     case (ck_'t')
                        token%token_no = tk_Print
                     case default
                        continue
                     end select
                  case default
                     continue
                  end select
               case default
                  continue
               end select
            case default
               continue
            end select
         case (ck_'w')
            select case (inputter%strbuf%chars(2))
            case (ck_'h')
               select case (inputter%strbuf%chars(3))
               case (ck_'i')
                  select case (inputter%strbuf%chars(4))
                  case (ck_'l')
                     select case (inputter%strbuf%chars(5))
                     case (ck_'e')
                        token%token_no = tk_While
                     case default
                        continue
                     end select
                  case default
                     continue
                  end select
               case default
                  continue
               end select
            case default
               continue
            end select
         case default
            continue
         end select
      case default
         continue
      end select
      if (token%token_no == tk_Ident) then
         allocate (token%val, source = inputter%strbuf%to_unicode ())
      end if
    end subroutine read_identifier_or_keyword

  end function get_token

  subroutine skip_spaces_and_comments (inputter, eof, ch, line_no, column_no)
    !
    ! This procedure skips spaces and comments, and also captures the
    ! line and column numbers at the correct moment to indicate the
    ! start of a token.
    !
    class(lexer_input_t), intent(inout) :: inputter
    logical, intent(out) :: eof
    character(1, kind = ck), intent(inout) :: ch
    integer(kind = nk), intent(out) :: line_no
    integer(kind = nk), intent(out) :: column_no

    integer(kind = nk), parameter :: not_done = -(huge (1_nk))

    line_no = not_done
    do while (line_no == not_done)
       call inputter%get_next_ch (eof, ch)
       if (eof) then
          line_no = inputter%line_no
          column_no = inputter%column_no
       else if (ch == ck_'/') then
          line_no = inputter%line_no
          column_no = inputter%column_no
          call inputter%get_next_ch (eof, ch)
          if (eof) then
             call inputter%unget_eof
             ch = ck_'/'
          else if (ch /= ck_'*') then
             call inputter%unget_ch (ch)
             ch = ck_'/'
          else
             call read_to_end_of_comment
             line_no = not_done
          end if
       else if (.not. isspace (ch)) then
          line_no = inputter%line_no
          column_no = inputter%column_no
       end if
    end do

  contains

    subroutine read_to_end_of_comment
      logical :: done

      done = .false.
      do while (.not. done)
         call inputter%get_next_ch (eof, ch)
         if (eof) then
            call end_of_input_in_comment
         else if (ch == ck_'*') then
            call inputter%get_next_ch (eof, ch)
            if (eof) then
               call end_of_input_in_comment
            else if (ch == ck_'/') then
               done = .true.
            end if
         end if
      end do
    end subroutine read_to_end_of_comment

    subroutine end_of_input_in_comment
      call start_error_message (inputter)
      write (error_unit, '("end of input in comment")')
      stop 1
    end subroutine end_of_input_in_comment

  end subroutine skip_spaces_and_comments

  subroutine start_error_message (inputter)
    class(lexer_input_t), intent(inout) :: inputter

    write (error_unit, '("Lexical error at ", I0, ".", I0, ": ")', advance = 'no') &
         &    inputter%line_no, inputter%column_no
  end subroutine start_error_message

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

  elemental function isupper (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    integer(kind = ichar_kind), parameter :: uppercase_A = ichar (ck_'A', kind = ichar_kind)
    integer(kind = ichar_kind), parameter :: uppercase_Z = ichar (ck_'Z', kind = ichar_kind)

    integer(kind = ichar_kind) :: i_ch

    i_ch = ichar (ch, kind = ichar_kind)
    bool = (uppercase_A <= i_ch .and. i_ch <= uppercase_Z)
  end function isupper

  elemental function islower (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    integer(kind = ichar_kind), parameter :: lowercase_a = ichar (ck_'a', kind = ichar_kind)
    integer(kind = ichar_kind), parameter :: lowercase_z = ichar (ck_'z', kind = ichar_kind)

    integer(kind = ichar_kind) :: i_ch

    i_ch = ichar (ch, kind = ichar_kind)
    bool = (lowercase_a <= i_ch .and. i_ch <= lowercase_z)
  end function islower

  elemental function isalpha (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    bool = isupper (ch) .or. islower (ch)
  end function isalpha

  elemental function isdigit (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    integer(kind = ichar_kind), parameter :: zero = ichar (ck_'0', kind = ichar_kind)
    integer(kind = ichar_kind), parameter :: nine = ichar (ck_'9', kind = ichar_kind)

    integer(kind = ichar_kind) :: i_ch

    i_ch = ichar (ch, kind = ichar_kind)
    bool = (zero <= i_ch .and. i_ch <= nine)
  end function isdigit

  elemental function isalnum (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    bool = isalpha (ch) .or. isdigit (ch)
  end function isalnum

  elemental function isalpha_or_underscore (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    bool = isalpha (ch) .or. (ch == ck_'_')
  end function isalpha_or_underscore

  elemental function isalnum_or_underscore (ch) result (bool)
    character(1, kind = ck), intent(in) :: ch
    logical :: bool

    bool = isalnum (ch) .or. (ch == ck_'_')
  end function isalnum_or_underscore

end module lexical_analysis

program lex
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, non_intrinsic :: lexical_analysis

  implicit none

  integer :: arg_count
  character(200) :: arg
  type(lexer_input_t) :: inputter
  type(lexer_output_t) :: outputter

  arg_count = command_argument_count ()
  if (3 <= arg_count) then
     call print_usage
  else if (arg_count == 0) then
     call run_lexer (inputter, outputter)
  else if (arg_count == 1) then
     call get_command_argument (1, arg)
     call inputter%use_file(trim (arg))
     call run_lexer (inputter, outputter)
  else if (arg_count == 2) then
     call get_command_argument (1, arg)
     call inputter%use_file(trim (arg))
     call get_command_argument (2, arg)
     call outputter%use_file(trim (arg))
     call run_lexer (inputter, outputter)
  end if

contains

  subroutine print_usage
    character(200) :: progname

    call get_command_argument (0, progname)
    write (output_unit, '("Usage: ", A, " [INPUT_FILE [OUTPUT_FILE]]")') &
         &      trim (progname)
  end subroutine print_usage

end program lex
