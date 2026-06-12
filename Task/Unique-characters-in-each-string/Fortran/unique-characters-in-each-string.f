program bit_unique_chars
  implicit none
  ! This program finds characters that appear exactly once in each of three strings,
  ! then prints the intersection of those unique characters in ASCII order.
  ! I took a different approach to the problem, rather than count occurences
  ! it uses bitfields (64-bit integers) to efficiently track character occurrences.
  ! Then uses XOR to build a 'unique mask' which gets ANDed with the originals to
  ! give the unique characters.
  integer, parameter :: n_strings = 3
  ! Number of input strings to process

  integer, parameter :: n_words = 4
  ! We need to represent all 256 possible ASCII codes.
  ! Each 64-bit integer can hold 64 bits → 4 words cover 256 bits.

  integer(kind=8) :: seen(n_words, n_strings) = 0_8
  ! Bitfield array: for each string, mark which characters have been seen at least once.
  ! Dimensions: (4 words × 3 strings). Initialized to zero.

  integer(kind=8) :: dup(n_words, n_strings) = 0_8
  ! Bitfield array: for each string, mark which characters appear more than once.
  ! Same dimensions as `seen`. Initialized to zero.

  integer(kind=8) :: unique_mask(n_words, n_strings)
  ! Bitfield array: for each string, mark characters that appear exactly once.
  ! Computed later as seen XOR dup.

  integer(kind=8) :: common_unique(n_words)
  ! Bitfield: intersection of unique characters across all strings.
  ! Will hold the final set of characters that are unique in *every* string.

  character(len=20), parameter :: strs(3) = [character(len=20) :: &
       "1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]
  ! Input strings (fixed length 20, but actual content is shorter).
  ! Three test strings are provided here.

  integer :: str_idx, char_idx, code, word, bitpos
  ! Loop indices and temporary variables:
  ! - str_idx: which string we’re processing
  ! - char_idx: which character within the string
  ! - code: ASCII code of the character
  ! - word: which 64-bit word the character maps to
  ! - bitpos: which bit inside that word

  logical :: first = .true.
  ! Used to control spacing when printing output characters.

  ! ============================================================
  ! STEP 1: Build seen/dup bitfields for each string
  ! ============================================================
  do str_idx = 1, n_strings
     do char_idx = 1, len_trim(strs(str_idx))
        code = iachar(strs(str_idx)(char_idx:char_idx))
        ! Get ASCII code of the current character

        word = code / 64 + 1
        ! Determine which 64-bit word this character belongs to
        ! (0–63 → word 1, 64–127 → word 2, etc.)

        bitpos = mod(code, 64)
        ! Position of the bit inside the chosen word

        if (btest(seen(word, str_idx), bitpos)) then
           ! If this character has already been seen in this string,
           ! mark it as a duplicate.
           dup(word, str_idx) = ibset(dup(word, str_idx), bitpos)
        end if

        ! Mark the character as seen (set its bit).
        seen(word, str_idx) = ibset(seen(word, str_idx), bitpos)
     end do
  end do

  ! ============================================================
  ! STEP 2: Compute unique_mask for each string
  ! ============================================================
  ! Characters that appear exactly once are those that are seen but not duplicated.
  ! This is achieved by XOR: seen ⊕ dup
  ! - If bit is set in seen but not in dup → unique
  ! - If bit is set in both → cancels out (not unique)
  ! - If bit is unset in both → remains unset
  do str_idx = 1, n_strings
     unique_mask(:, str_idx) = ieor(seen(:, str_idx), dup(:, str_idx))
  end do

  ! ============================================================
  ! STEP 3: Find intersection of all unique sets
  ! ============================================================
  ! Only characters that are unique in *every* string should remain.
  common_unique = unique_mask(:,1)
  common_unique = iand(common_unique, unique_mask(:,2))
  common_unique = iand(common_unique, unique_mask(:,3))
  ! Bitwise AND across all three unique masks.

  ! ============================================================
  ! STEP 4: Scan ASCII codes in order and print results
  ! ============================================================
  first = .true.
  do code = 0, 255
     word = code / 64 + 1
     bitpos = mod(code, 64)

     if (btest(common_unique(word), bitpos)) then
        ! If this character is marked as common unique, print it.
        ! Add a space before subsequent characters for readability.
        if (.not. first) write(*, '(a)', advance='no') ' '
        write(*, '(a)', advance='no') char(code)
        first = .false.
     end if
  end do
  write(*,*)
  ! Final newline after output

end program bit_unique_chars

