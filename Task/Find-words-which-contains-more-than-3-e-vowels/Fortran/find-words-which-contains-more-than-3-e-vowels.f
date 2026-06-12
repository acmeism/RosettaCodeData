!
! Find words which contains more than 3 e vowels
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
!
program Three_e
  implicit none

  integer, parameter :: longestWord = 50                    ! is long enough for unixdict

  character(len=longestWord) :: word
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
        print *, "Read error" ! ERROR: never seen this error condition
        exit
     end if
     if (ContainsMoreThan_3e (word(1:l), l ))  print *, word(1:l)
  end do

  close(10)

  contains

  function ContainsMoreThan_3e  (w, l ) result (YN)

  character (*), intent(in)     :: w            ! The word to check
  integer, intent(in)           :: l            ! length of the word
  logical                       :: YN           ! function Result

  integer                       :: nE           ! Counter for e's
  integer                       :: ii           ! loop index

  nE = 0
  YN=.false.

  do ii=1,l
    if (w(ii:ii) .eq. 'e' .or. w(ii:ii) .eq. 'E') then
      nE = nE + 1
      if (nE .gt. 3) then
        YN=.true.
      endif
    else if ( w(ii:ii) .eq. 'a' .or. w(ii:ii) .eq. 'A' &    ! Check for other vowels
         .or. w(ii:ii) .eq. 'i' .or. w(ii:ii) .eq. 'I' &
         .or. w(ii:ii) .eq. 'o' .or. w(ii:ii) .eq. 'O' &
         .or. w(ii:ii) .eq. 'u' .or. w(ii:ii) .eq. 'U' ) then
      YN=.false.                                            ! Vowel other than 'e' found.
      exit                                                  ! No need to proceed, we're done here.
    endif
  end do

  end function ContainsMoreThan_3e


end program Three_e

