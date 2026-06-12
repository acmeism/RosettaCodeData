! ABC Correlation
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! Note that VMS requires switch $Fortran/ccdefault=LIST
! otherwise 1st character of each output line is interpreted as
! Carriage Control character.
!
! U.B., July 2025
!
program ABC_unixdict
  implicit none

  !
  ! Print all ABC words from file "unixdict.txt", with at least one a or b or c
  !

  character(len=100)  :: word    ! is longer than expected input word length
  integer :: l, io_stat

  ! going to read all words from unixdict.txt
  open(unit=10, file='unixdict.txt', status='old', action='read', iostat=io_stat)
  if (io_stat /= 0) then
     print *, "Error opening file"
     stop
  end if

  do    ! read all words, one in a line, until ERROR or EOF, and print of ABC-word as defined.
     ! read(10, '(q, a)', iostat=io_stat) l, word(1:l)    ! fine for Intel, but GNU does not like 'Q' edit descriptor
     read (10,'(A)', iostat=io_stat)   word               ! ok for both intel and GNU.
     l = len_trim (word)                                  ! use this instead of Q format

     if (io_stat < 0) exit    ! EOF: Normal end of this loop
     if (io_stat > 0) then
        print *, "Read error" ! ERROR: ever seen
        exit
     end if

     if (is_abc(word(1:l), l, allowZero=.false.))  print '(a)', word(1:l)
  end do

  close(10)

  contains

  function is_abc (w, l, allowZero) result (YN)

  character (*), intent(in)     :: w            ! The word to check
  integer, intent(in)           :: l            ! length of the word
  logical, intent(in)           :: allowZero    ! if set, words without any a,b, or c are ABC words!
  logical                       :: YN           ! function Result

  integer                       :: A, B, C      ! Counters for letters a,b,c in word w.
  integer                       :: ii           ! loop index

  ! Initialize counters each time we come here,
  ! not once in Definitions of A,B,C
  A=0
  B=0
  C=0

  ! Iterate through the word, counting occurrances of a,b,c
  do ii=1,l
    if (w(ii:ii) .eq. 'a') then
      A = A + 1
    else if (w(ii:ii) .eq. 'b') then
      B = B + 1
    else if (w(ii:ii) .eq. 'c') then
      C = C + 1
    endif
  end do

  ! Result: a,b,c same value, zero not allowed.
  if (.not. allowZero) then
    yn = (a .ne. 0) .and. (A.eq.B) .and. (B .eq. C)
  else
    yn = (A.eq.B) .and. (B .eq. C)
  endif
  end function is_abc


end program ABC_unixdict
