! Find words which contain the most consonants
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! Note that VMS requires switch $Fortran/ccdefault=LIST
! otherwise 1st character of each output line is interpreted as
! Carriage Control character.
!
! U.B., August 2025
!

program AllVowels
  implicit none

  character(len=100)  :: word    ! is longer than expected input word length
  integer :: l, io_stat

  integer, parameter :: maximumConsonantCount = 21          ! Max cons count is 26(a-z) - 5 (aeiou)
  integer, parameter :: longestWord = 50                    ! is long enough for unixdict
  integer, parameter :: maximumNumberOfWOrdsPerCount = 160  ! Expect no more words for a given number of consonants
  integer            :: cnt, maxcnt = 0                     ! Current, maximum consonant count
  integer            :: consoCount(maximumConsonantCount)   ! number of words found with given number of consonants

  ! List of all words found per number of consonants
  character (len=longestWord) ::  mxWords (maximumNumberOfWOrdsPerCount, maximumConsonantCount)
  integer            :: ii, jj   ! Loop indices

  ! going to read all words from unixdict.txt
  open(unit=10, file='unixdict.txt', status='old', action='read', iostat=io_stat)
  if (io_stat /= 0) then
     print *, "Error opening file"
     stop
  end if

  ! Initialize counter array
  do ii = 1, maximumConsonantCount
    consoCount (ii) = 0
  end do

  do    ! read all words, one in a line, until ERROR or EOF, and print the word if it contains all 5 vowels
     read (10,'(A)', iostat=io_stat)   word               ! ok for both intel and GNU.
     l = len_trim (word)                                  ! use this instead of Q format

     if (io_stat < 0) exit    ! EOF: Normal end of this loop
     if (io_stat > 0) then
        print *, "Read error" ! ERROR: (never seen)
        exit
     end if

    cnt = countConsonants (word(1:l), l )
    if (cnt  .gt. 0 .and. cnt .le. maximumConsonantCount) then  ! Can use cnt as index?
      consoCount (cnt) = consoCount(cnt) + 1                    ! Chalk one up for this count
      mxwords (consoCount (cnt), cnt) = word                    ! and memoize this word
      if (cnt .gt. maxcnt) then                                 ! Keep track of highest count, so that...
        maxcnt = cnt                                            ! ... later we do not need to search for maximum.
      end if
    end if
  end do

  ! Printout the result
  do cnt = maxcnt,1,-1
    if (consoCount (cnt) .eq. 1) then
      write (6, '("Found ", I0, " word with ", I0, " Consonants:")')   consoCount(cnt), cnt  ! 1 = singular
    else if (consoCount (cnt) .gt. 0) then
      write (6, '("Found ", I0, " words with ", I0, " Consonants:")')   consoCount(cnt), cnt  ! 1 = singular
    end if
    if (consoCount (cnt) .gt. 0) then
      do ii = 1, consoCount(cnt), 7       ! Print up to 7 words per line, maximum 14 letters each
        write (6,'(7A15)')  (mxWords(jj, cnt)(:len_trim(mxWords(jj,cnt))), jj=ii, min (ii+6, consocount(cnt)) )
      enddo
      write (6,*) ! empty line after each set of words
    end if
  end do

  close(10)

  contains

  function countConsonants  (w, l ) result (cnt)

  character (*), intent(in)     :: w            ! The word to check

  integer, intent(in)           :: l            ! length of the word
  integer                       :: cnt          ! function Result
                                                ! 0 = no result.
  character                     :: c
  integer                       :: ic
  integer                       :: ii           ! loop index
  integer                       :: conscnt(26)  ! Counter for each letter

  ! Initialize counters each time we come here,
  ! not once in Definitions of these variables

  cnt = 0
  do ii=1,26
    conscnt(ii) = 0
  enddo

  if (l .gt. 10) then     ! Task desription: Length of any word must be > 10
    ! Iterate through the word, counting occurrances of a,e,i,o,u
    do ii=1,l
      c = w(ii:ii)
      if (c .ge. 'A' .and. c .le. 'Z') then
        c = char(ichar(w(ii:ii)) - ichar('A') + ichar('a'))
      end if
      ic = ichar(c) - ichar('a') + 1

      if (c .ne. 'a'  .and. &
          c .ne. 'e'  .and. &
          c .ne. 'i'  .and. &
          c .ne. 'o'  .and. &
          c .ne. 'u'  .and. c .ge. 'a' .and. c .le. 'z'  ) then     ! Not a vowel, and wwell in alphabet

        ic = ichar(c) - ichar('a') + 1
        conscnt (ic) = conscnt (ic) + 1
        if (conscnt (ic) .gt. 1) then   ! Skip word if it contains multiple instances of one consonant
          cnt = 0
          return
        else
          cnt = cnt + 1
        endif
      endif
    end do
  else
    ! word is too short to get listed
    cnt = 0
  end if
  end function countConsonants

end program AllVowels

