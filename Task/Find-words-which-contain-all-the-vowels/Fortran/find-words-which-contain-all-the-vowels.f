! All Vowels
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

  ! going to read all words from unixdict.txt
  open(unit=10, file='unixdict.txt', status='old', action='read', iostat=io_stat)
  if (io_stat /= 0) then
     print *, "Error opening file"
     stop
  end if

  do    ! read all words, one in a line, until ERROR or EOF, and print the word if it contains all 5 vowels
     read (10,'(A)', iostat=io_stat)   word               ! ok for both intel and GNU.
     l = len_trim (word)                                  ! use this instead of Q format

     if (io_stat < 0) exit    ! EOF: Normal end of this loop
     if (io_stat > 0) then
        print *, "Read error" ! ERROR: ever seen
        exit
     end if

     if (ContainsAllVowels (word(1:l), l ))  print '(a)', word(1:l)
  end do

  close(10)

  contains

  function ContainsAllVowels  (w, l ) result (YN)

  character (*), intent(in)     :: w            ! The word to check
  integer, intent(in)           :: l            ! length of the word
  logical                       :: YN           ! function Result

  integer                       :: lA, lE, lI, lO, lU      ! Indicators for the vowels
  integer                       :: ii           ! loop index

  ! Initialize counters each time we come here,
  ! not once in Definitions of these variables
  lA = 0
  lE = 0
  lI = 0
  lO = 0
  lU = 0

  if (l .gt. 10) then     ! Task desription: Length of any word must be > 10
    ! Iterate through the word, counting occurrances of a,e,i,o,u
    do ii=1,l
      if (w(ii:ii) .eq. 'a' .or. w(ii:ii) .eq. 'A') then
        lA = lA + 1
      else if (w(ii:ii) .eq. 'e' .or. w(ii:ii) .eq. 'E') then
        lE = lE + 1
      else if (w(ii:ii) .eq. 'i' .or. w(ii:ii) .eq. 'I') then
        lI = lI + 1
      else if (w(ii:ii) .eq. 'o' .or. w(ii:ii) .eq. 'O') then
        lO = lO + 1
      else if (w(ii:ii) .eq. 'u' .or. w(ii:ii) .eq. 'U') then
        lU = lU + 1
      endif
    end do
    ! Result: A,E,I,O U seen exactly once
    yn = lA .eq. 1 .and. lE .eq. 1 .and. lI .eq. 1 .and. lO .eq. 1 .and. lU .eq. 1
  else
    ! word too short to be listed
    yn = .false.
  end if

  end function ContainsAllVowels


end program AllVowels

