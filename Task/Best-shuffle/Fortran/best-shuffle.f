!
! Best Shuffle
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!
! VSI Fortran on VMS does not compile this code because its current version
! cannot handle allocatable character strings
!
! U.B., October 2025
!==============================================================================

program bestShuffle

  implicit none

  integer, parameter :: MAXLEN = 100                              ! Maximum length of strings to shuffle
  character (len=MAXLEN), dimension(:),allocatable  :: wordsToShuffle               ! Test cases as in task description
  character (len=MAXLEN) shuffledWord                             ! Result of a shuffle operation
  integer ::  ii, nWords, scr                                     ! little helpers
  integer:: longest                                               ! Length of longest test string
  character (len=50)  :: vFormat                                  ! Variable format for printing

  wordsToShuffle = &                                              ! Preset test cases
  [character(len=MAXLEN) :: 'abcdefghijk', &                      ! all letters different -> always score 0
                            'abracadabra', &                      ! The other test cases from task description
                            'seesaw',      &
                            'elk',         &
                            'grrrrrrr',    &
                            'up',          &
                            'a']                                  ! This style makes both ifx AND gfortran happy.
  nWords = size (wordsToShuffle)                                  ! Number of test cases
  longest = 0
  do ii=1, nWords                                                 ! Find length of longest test string
    longest = max (longest, len_trim(wordsToShuffle(ii)))
  end do

  ! Create a variable format depending on the length of the longest test string,
  ! to print the original string, the shuffled string and the score in three columns
  write (vFormat,'("(A", i0, ", x, A, T", i0,", i0)"  )')   longest, 2*longest+3

  ! Initialize random number generator once for the entire run-time of the program and all test cases
  call random_seed()

  do ii = 1, nWords
    ! Using the Sattolo cycle guarantees that each and every letter will be moved from its original
    ! position. However, duplicate letters within a word can lead to shuffled words that have a score >0
    ! If all letters aof the string are different, score will be 0 each time this program is run.
    call sattolo_cycle (wordsToShuffle(ii), shuffledWord, scr)
    print vFormat, trim(wordsToShuffle(ii)), trim(shuffledWord), scr
  end do

  contains

  !=============================================================
  ! shuffle using the Sattolo algorithm, and calculate the score
  ! @win: word to shuffle, @wout: resultant string
  ! @resultantscore: with the obvious meaning
  !=============================================================
  subroutine sattolo_cycle (win, wout, resultantscore)

  character (len=MAXLEN) , intent (in) :: win           ! The word to shuffle
  character (len=MAXLEN) , intent (out) :: wout         ! The resultant word after shuffling
  character :: tmp                                      ! for swapping single letters
  integer, intent(out) :: resultantscore                ! the calculated score of the resultant string

  integer :: j, k, l                                    ! Helper variables: indices into words, words' length

  wout = win
  l = len_trim (wout)
  do j = l, 1, -1                                       ! For all letters from end down to begin
    k = randominInterval (1, j-1)                       ! Select random letters between 1 and j-1
    tmp = wout(j:j)                                     ! then swap letter at pos j with letter at pos k
    wout (j:j) = wout (k:k)
    wout(k:k) = tmp
  end do

  resultantscore = score (win,wout,l)                   ! Calculate score
  end subroutine sattolo_cycle


  ! ===========================================================
  ! Generate random number between @lo and @hi (inclusive)
  ! Assume Random Number Generator has been initialized before.
  ! ===========================================================
  function randominInterval (lo, hi) result (r)
  integer, intent(in) :: lo, hi                         ! the interval
  integer :: r                                          ! resultant (pseudo-)random number
  real :: rnd                                           ! Fortran random number generator generates float values

  call random_number (rnd)
  r = lo + FLOOR((hi+1-lo)*rnd)                         ! We want to choose one between [lo,hi]

  end function randominInterval

  !===============================================================================
  ! Calculate score: count positions that have the same letter as before shuffling
  !===============================================================================
  function score (win, wout, l) result (scr)
  character (len=MAXLEN) , intent (in) :: win, wout     ! The two words to compare
  integer , intent(in) :: l                             ! Length of the words to consider
  integer :: scr                                        ! Resultant score
  integer :: jj                                         ! Loop index

  scr = 0
  do jj=1,l
    if (win(jj:jj) .eq. wout(jj:jj) )   scr = scr + 1
  enddo
  end function score

end program bestShuffle
