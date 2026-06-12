program anagram_generator
    implicit none

    ! Constants
    integer, parameter :: MIN_WORD_LEN = 2
    integer, parameter :: MAX_WORD_LEN = 50
    integer, parameter :: MAX_WORDS = 100000 ! Increased to handle dict_sizes(5)=29874
    integer, parameter :: MAX_WORD_STR_LEN = 4 * MAX_WORD_LEN ! = 200
    character(len=*), parameter :: DICT_FILENAME = 'unix_dict.txt'
    integer(8), parameter :: HASH_MOD = 2_8**31 - 1 ! Large prime for modular arithmetic

    ! Prime numbers for hashing (corresponding to 'a' to 'z')
    integer(8), parameter :: PRIMES(97:122) = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, &
                                               41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]

    ! Dictionary storage: array of words and hashes per length
    type :: word_entry
        character(len=MAX_WORD_STR_LEN) :: word
        integer(8) :: hash
    end type word_entry
    type(word_entry), save, dimension(MAX_WORDS, MIN_WORD_LEN:MAX_WORD_LEN) :: hashed_dict
    integer, save, dimension(MIN_WORD_LEN:MAX_WORD_LEN) :: dict_sizes

    ! Main program
    call load_candidate_words(DICT_FILENAME, MIN_WORD_LEN, MAX_WORD_LEN)
    call anagram('Iron Butterfly')
    print *
    call anagram('Judas Priest')
    print *
    call anagram('Deep Purple')
    print *
    call anagram('Motorhead')
    print *
    stop 'normal termination'
contains

    ! Hash function: Product of primes with modular arithmetic
    function hash(str) result(res)
        implicit none
        character(len=*), intent(in) :: str
        integer(8) :: res
        integer :: i
        if (len_trim(str) == 0) then
            print *, 'Warning: Empty string passed to hash'
            res = 0
            return
        end if
        res = 1
        do i = 1, len_trim(str)
            if (ichar(str(i:i)) >= 97 .and. ichar(str(i:i)) <= 122) then
                res = mod(res * PRIMES(ichar(str(i:i))), HASH_MOD)
            else
                print *, 'Invalid character in string: ', str(i:i), ' in [', str(1:len_trim(str)), ']'
                res = 0
                return
            end if
        end do
    end function hash

    ! Load dictionary words and compute hashes
    subroutine load_candidate_words(filename, min_len, max_len)
        implicit none
        character(len=*), intent(in) :: filename
        integer, intent(in) :: min_len, max_len
        character(len=MAX_WORD_STR_LEN) :: line
        integer :: ios, word_len, i, dict_idx, line_count
        logical :: valid
        type(word_entry) :: entry
        character(len=200) :: pooka
        dict_sizes = 0
        line_count = 0
        open (unit=10, file=filename, status='old', action='read', iostat=ios, iomsg=pooka)
        if (ios /= 0) then
            print *, 'Error opening dictionary file: ', trim(pooka)
            stop 'bad file'
        else
            print *, 'file opened'
        end if

        do while (.true.)
            read (10, '(A)', iostat=ios, iomsg=pooka) line
            if (ios /= 0) then
                if (ios == -1) then
                    print *, 'Reached end of file'
                else
                    print *, 'Read error: ', trim(pooka)
                end if
                exit
            end if
            line_count = line_count + 1
            line = lowcase(trim(line))
            word_len = len_trim(line)
            if (word_len >= min_len .and. word_len <= max_len) then
                valid = .true.
                do i = 1, word_len
                    if (ichar(line(i:i)) < 97 .or. ichar(line(i:i)) > 122) then
                        valid = .false.
                        print *, 'Skipping invalid word: ', trim(line)
                        exit
                    end if
                end do
                if (valid) then
                    if (dict_sizes(word_len) < MAX_WORDS) then
                        dict_sizes(word_len) = dict_sizes(word_len) + 1
                        dict_idx = dict_sizes(word_len)
                        entry % word = line
                        entry % hash = hash(line)
                        if (entry % hash == 0) then
                            print *, 'Skipping word due to hash failure: ', trim(line)
                            dict_sizes(word_len) = dict_sizes(word_len) - 1
                            cycle
                        end if
                        hashed_dict(dict_idx, word_len) = entry
                        if (dict_idx <= 3 .and. word_len <= 3) then
                        end if
                    else
                        print *, 'Warning: MAX_WORDS exceeded for length ', word_len
                        dict_sizes(word_len) = MAX_WORDS
                    end if
                end if
            end if
        end do
        if (all(dict_sizes == 0)) then
            print *, 'Error: No valid words loaded. Check dictionary file contents.'
            stop 'empty dictionary'
        end if
        close (10)
    end subroutine load_candidate_words

    ! Convert string to lowercase
    pure function lowcase(s) result(t)
        implicit none
!
! parameter definitions
!
        integer, parameter :: diff = ichar('A') - ichar('a'), biga = ichar('A'),       &
                               & bigz = ichar('Z')
!
! dummy arguments
!
        character(*) :: s
        intent(in) s
!
! local variables
!
        integer :: i, lenstr
        character(len(s)) :: t
!
! returns string 's' in lowercase
        t = s
        lenstr = len(t)
        forall (i=1:lenstr, ((ichar(t(i:i)) >= biga) .and. (ichar(t(i:i)) <= bigz)))
            t(i:i) = char(ichar(t(i:i)) - diff)
        end forall
        return
    end function lowcase
!
!

    ! Find words with matching hashes for two-word anagrams
    subroutine find_words(len1, len2, hash1, hash2)
        implicit none
        integer, intent(in) :: len1, len2
        integer(8), intent(in) :: hash1, hash2
        integer :: i, j
        if (len1 < MIN_WORD_LEN .or. len1 > MAX_WORD_LEN .or. len2 < MIN_WORD_LEN .or. len2 > MAX_WORD_LEN) then
            print *, 'Invalid lengths: len1=', len1, ' len2=', len2
            return
        end if
        if (dict_sizes(len1) == 0 .or. dict_sizes(len2) == 0) then
            print *, 'No words available for len1=', len1, ' (', dict_sizes(len1), ') or len2=', len2, ' (', dict_sizes(len2), ')'
            return
        end if
        if (hash1 == 0 .or. hash2 == 0) then
            print *, 'Invalid hash values: hash1=', hash1, ' hash2=', hash2
            return
        end if

        do i = 1, dict_sizes(len1)
        if (hashed_dict(i, len1) % hash == hash1) then
            do j = 1, dict_sizes(len2)
                if (hashed_dict(j, len2) % hash == hash2) then
                    print *, trim(hashed_dict(i, len1) % word), ' ', trim(hashed_dict(j, len2) % word)
                    hashed_dict(i, len1) % hash = 0 ! Prevent reuse
                end if
            end do
        end if
        end do
        return
    end subroutine find_words

    ! Get next bit pattern with same number of 1s
    pure function next(n) result(res)
        implicit none
        integer(4), intent(in) :: n
        integer(4) :: res
        integer :: ones
        ones = popcnt(n)
        if (ones == 0) then
            res = 0
            return
        else if (ones == 1) then
            res = ishft(n, 1)
            return
        else
            res = n + 1
            do while (popcnt(res) /= ones)
                res = res + 1
            end do
        end if
    end function next

    ! Extract characters based on bit mask
    pure function masked_chars(src, mask) result(res)
        implicit none
        character(len=*), intent(in) :: src
        integer, intent(in) :: mask
        character(len=MAX_WORD_STR_LEN) :: res
        integer :: i, str_idx, shifted
        character(len=:),allocatable :: holder
        if (len_trim(src) == 0) then
            error stop 'DEBUG: Empty source string detected'
            res = ''
            return
        end if
        res = ''
        shifted = iand(mask, 2_4**len_trim(src) - 1)
        str_idx = 1
        do i = 1, len_trim(src)
            if (iand(shifted, 1) == 1) then
                if (str_idx <= MAX_WORD_STR_LEN) then
                    res(str_idx:str_idx) = src(i:i)
                    str_idx = str_idx + 1
                else
                    holder = 'DEBUG: str_idx exceeds MAX_WORD_STR_LEN'// '[' // src(1:len_trim(src))// ']'
                    error stop holder
                    res = ''
                    return
                end if
            end if
            shifted = ishft(shifted, -1)
            if (shifted == 0) then
                exit
            end if
        end do
    end function masked_chars

    ! Find two-word anagrams for a given word
    subroutine anagram(wordz)
        implicit none
        character(len=*), intent(in) :: wordz
        character(len=len(wordz)) :: word
        character(len=MAX_WORD_LEN) :: word_lc
        integer :: max_search_len, part1_len, part2_len
        integer(4) :: part1, part_len_mask
        if (len_trim(word) < MIN_WORD_LEN .or. len_trim(word) > MAX_WORD_LEN) then
            print *, 'Word length out of allowed range.'
            return
        end if
        word = strcompress(wordz)
        word_lc = lowcase(word)
        max_search_len = len_trim(word) - MIN_WORD_LEN
        print *, 'Two-word anagrams of ', trim(word), '...'
        part1_len = len_trim(word) - MIN_WORD_LEN
        part2_len = len_trim(word) - part1_len
        do while (part1_len >= part2_len)
            part_len_mask = 2**len_trim(word) - 1
            part1 = 2**part1_len - 1
            do while (part1 < 2**len_trim(word))
                call find_words(part1_len, part2_len, &
                                hash(masked_chars(word_lc, part1)), &
                                hash(masked_chars(word_lc, iand(ieor(part1, -1), part_len_mask))))
                part1 = next(part1)
            end do
            part1_len = part1_len - 1
            part2_len = part2_len + 1
        end do
    end subroutine anagram

!------------------------------------------------------------------------------
!
! NAME:
!       StrCompress
!
! PURPOSE:
!       Subroutine to return a copy of an input string with all whitespace
!       (spaces and tabs) removed.
!
! CATEGORY:
!       Utility
!
! LANGUAGE:
!       Fortran-95
!
! CALLING SEQUENCE:
!       Result = StrCompress( String,  &  ! Input
!                             n = n    )  ! Optional Output
!
! INPUT ARGUMENTS:
!       String:         Character string to be compressed.
!                       UNITS:      N/A
!                       TYPE:       CHARACTER( * )
!                       DIMENSION:  Scalar
!                       ATTRIBUTES: INTENT( IN )
!
! OPTIONAL INPUT ARGUMENTS:
!       None.
!
! OUTPUT ARGUMENTS:
!       None.
!
! OPTIONAL OUTPUT ARGUMENTS:
!       n:              Number of useful characters in output string
!                       after compression. From character n+1 -> LEN( Input_String )
!                       the output is padded with blanks.
!                       UNITS:      N/A
!                       TYPE:       INTEGER
!                       DIMENSION:  Scalar
!                       ATTRIBUTES: INTENT( OUT ), OPTIONAL
!
! FUNCTION RESULT:
!       Result:         Input string with all whitespace removed before the
!                       first non-whitespace character, and from in-between
!                       non-whitespace characters.
!                       UNITS:      N/A
!                       TYPE:       CHARACTER( LEN(String) )
!                       DIMENSION:  Scalar
!
! CALLS:
!       None.
!
! SIDE EFFECTS:
!       None.
!
! RESTRICTIONS:
!       None.
!
! EXAMPLE:
!       Input_String = '  This is a string with spaces in it.'
!       Output_String = StrCompress( Input_String, n=n )
!       WRITE( *, '( a )' ) '>',Output_String( 1:n ),'<'
!   >Thisisastringwithspacesinit.<
!
!       or
!
!       WRITE( *, '( a )' ) '>',TRIM( Output_String ),'<'
!   >Thisisastringwithspacesinit.<
!
! PROCEDURE:
!       Definitions of a space and a tab character are made for the
!       ASCII collating sequence. Each single character of the input
!       string is checked against these definitions using the IACHAR()
!       intrinsic. If the input string character DOES NOT correspond
!       to a space or tab, it is not copied to the output string.
!
!       Note that for input that ONLY has spaces or tabs BEFORE the first
!       useful character, the output of this function is the same as the
!       ADJUSTL() instrinsic.
!
! CREATION HISTORY:
!       Written by:     Paul van Delst, CIMSS/SSEC 18-Oct-1999
!                       paul.vandelst@ssec.wisc.edu
!S-
!------------------------------------------------------------------------------

    function strcompress(input_string, n) result(output_string)
        implicit none
!
! parameter definitions
!
        integer, parameter :: iachar_space = 32, iachar_tab = 9
!
! dummy arguments
!
        character(*),intent(in) :: input_string
        integer :: n
        optional n
        intent(out) n
!
! local variables
!
        integer :: i, iachar_character, j, lent
        character(len(Input_string)) :: OUTPUT_STRING

        output_string = ' '
        lent = len(input_string)
        j = 0

        do i = 1, lent
            iachar_character = iachar(input_string(i:i))
            if (iachar_character /= iachar_space .and. iachar_character /= iachar_tab) then
                j = j + 1
                output_string(j:j) = input_string(i:i)
            end if
        end do
        if (present(n)) n = j
        return
    end function strcompress
end program anagram_generator

