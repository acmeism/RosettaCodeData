!
! Word Wheel
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., May 2026
!
program WordWheel
implicit none

integer, parameter :: longestWord = 50                    ! is long enough for words.txt (45)

character(len=longestWord) :: word                        ! 1 word to read
integer :: io_stat                                        ! Status or read operation

! The example from Task description.
integer, parameter :: wheelSize=9
character (len=wheelSize) :: letters = 'ndeokgelw'
character  :: centralLetter

centralLetter = letters (1+wheelSize/2:1+wheelSize/2)

 ! going to read all words from word list
 open(unit=10, file='unixdict.txt', status='old', action='read', iostat=io_stat)
 if (io_stat .ne. 0) then
   print *, "Error opening file unixdict.txt"                  ! ERROR: would be useless to try reading words.
   stop
 end if

 do    ! read all words, until ERROR or EOF
  read (10,'(A)', iostat=io_stat)   word
  if (io_stat < 0) exit                          ! EOF: Normal end of this loop
  if (io_stat > 0) then
    print *, "Read error"                       ! ERROR (unexpected): would be useless to proceed
    exit
  end if

  ! Print this word if it passes all tests
  if (isInWheel (word, letters, centralLetter)) then
    write (*,'(A)')    word
  endif
end do

contains

! =============================================================================
! Decide if word w can be build from letters of letter set l,
! with the additional conditions that length of w is greater or equal 3, and
! that the central letter c MUST be present in w.
! =============================================================================
function isInWheel (w,l,c) result (YN)
character (len=*),intent(in) :: w, l      ! The word, and the set or allowed letters
character, intent(in) :: c                ! central letter
logical :: YN                             ! The result
character (len=len_trim(l)) :: ll         ! mutable copy of readonly argument l
integer :: lenw, ii, idx

YN = .true.                               ! to be falsified
ll=l                                      ! Local copy of argument

lenw = len_trim(w)                        ! Length of word w
if (lenw .lt. 3) then
  YN = .false.                            ! BAD: too short word w
else if (index (w, c) .eq. 0)    then     ! Central letter in word?
  YN = .false.                            ! BAD: Central letter not contained in word w
else
  ! Each time we find a letter of w in the set ll, we erase that letter from ll so that
  ! it can be used only once. The same letter may appear in ll muiltiple times and
  ! may be used in w as often as it is contained in ll).
  do ii=1, lenw                           ! Iterate the letters of w
    idx = index (ll, w(ii:ii))            ! Current letter in allowed/required set?
    if (idx .eq. 0) then
      YN = .false.                        ! BAD: This letter of word not in required set of letters
      exit
    else
      ll(idx:idx) = '#'                   ! Good, but invalidate this occurrance of letter w(ii:ii) in letter set
    endif
  enddo
endif

end function isInWheel
end program WordWheel
