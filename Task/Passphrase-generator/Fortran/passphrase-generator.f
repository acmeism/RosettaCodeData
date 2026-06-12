!
! Passphrase generator
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
! NOT VSI Fortran on OpenVMS because that compiler does not like allocatable strings
! U.B., April 2026
!
program Passphrasegenerator
implicit none

integer, parameter :: longestWord = 50                    ! is long enough for words.txt (45)

character(len=longestWord) :: word                        ! 1 word to read
character(len=longestWord), allocatable  :: Words(:)      ! the entire collection of all words
integer :: capacity, content                              ! usage of above container

integer :: num_args
integer :: ios

integer :: nWordsInPassphrase
character(len=1023), dimension(:), allocatable :: args
character (len=:) , allocatable :: dictFile
integer :: l, io_stat, ii, rnd

! Parse Command line arguments, if any.
num_args = command_argument_count()

! Provide default for the command line option

nWordsInPassphrase=3
dictfile = 'unixdict.txt'

if (num_args .gt. 0)  then
  allocate(args(num_args))  ! omitted checking the return status of the allocation
  do ii = 1, num_args
   call get_command_argument(ii,args(ii))
  end do
  !
  ! Expect 1 Command line arguments: -n [integer]
  ! Help is displayed if any command line argument other -n integer Number of words in passphrase
  !
  ii = 1
  do while (num_args .ge. ii)
    if (args(ii) .eq. '-n') then
      ii = ii + 1
      if (ii .le. num_args) then
        read (args(ii), *, iostat = ios)  nWordsInPassphrase
        if (ios .ne. 0) then
          write (*, '(/A,X,A)')  args(ii), 'Is not a valid input for number of passwpords.'
          call help()
          stop
        else
          ii = ii + 1     ! Prepare to get next argument
        endif
      else
        write (*, '(/A)')  'Missing number of words after "-n"'
        call help()
        stop
      end if
    else if (args(ii) .eq. '-d')  then
      ii = ii + 1
      if (ii .le. num_args) then
        dictFile = trim(args(ii) )
        ii = ii + 1
      else
        write (*, '(/A)')  'Missing file name for dictionary after "-d"'
        call help()
        stop
      endif
    else if (args(ii) .eq. '-h') then
      call help()
      stop
    else
      ! provide help if any argument other than -d <file> or -n <num> given
      write (*, '(/A)')  'Invalid command line argument: ', args(ii)
      call help()
      stop
    end if
  enddo
endif



content = 0

! Begin with moderate words array size
capacity = 1024
call resize (Words, capacity)

 ! going to read all words from word list (default is unixdict.txt)
 open(unit=10, file=dictfile, status='old', action='read', iostat=io_stat)
 if (io_stat .ne. 0) then
   print *, "Error opening file ", dictFile                  ! ERROR: would be useless to try reading words.
   stop
 end if

 ii = 0
 do    ! read all words, until ERROR or EOF
  read (10,'(A)', iostat=io_stat)   word
  if (io_stat < 0) exit                          ! EOF: Normal end of this loop
  if (io_stat > 0) then
    print *, "Read error"                       ! ERROR (unexpected): would be useless to proceed
    exit
  end if
  ii = ii + 1
  l = len_trim (word)                             ! use this instead of Q format so that VMS Fortran can grok it.
  if (l .ge. 4 .and. l .le. 9) then               ! Use only words with lengh 4...9 (incl.)
     call addWord ()
  end if
end do

call random_seed()

do ii=1, nWordsInPassphrase
  rnd = randominInterval(1, content)
  write (*, '(A)', advance='no')    Words(rnd)(:len_trim(words(rnd)) )
  write (*, '(I0)', advance='no')  randominInterval(1, 99)
  if (ii .lt. nWordsInPassphrase) write (*, '("-")', advance='no')
end do
write (*,*)

contains

! ===========================================================
! Generate random number between @lo and @hi (inclusive)
! Assume Random Number Generator has been initialized before.
! ===========================================================
function randominInterval (lo, hi) result (r)
integer, intent(in) :: lo, hi                         ! the interval
integer :: r                                          ! resultant (pseudo-)random number
real :: rnd                                           ! Fortran random number generator generates float values
call random_number (rnd)                              ! 0. <= rnd < 1.
r = lo + FLOOR((hi+1-lo)*rnd)                         ! We want to choose one between [lo,hi]: add +1 to possibly include "hi".
end function randominInterval

! =====================================================
! Print help text to explain the command line arguments
! =====================================================
subroutine help()
write (*, '(/A/)') 'Valid command line arguments are:'
write (*, '(A)') '-h            : this help text'
write (*, '(A)') '-n <nWords>   : Number of words used to generate a passphrase'
write (*, '(A)') '-d <fileName> : File name of word list, default="unixdict.txt"'

end subroutine help

  ! ------------------------------------
  ! add a new word to the list of words.
  ! ------------------------------------
  subroutine addWord()
  ! No local variables here. Just working on Main program's variables.

  content = content+1

  ! If we would exceed capacity of array 'Words', we need to increment capacity
  if (content .gt. capacity) then
    capacity = 2*capacity
    call resize (Words, capacity)
  end if

  Words(content) = word

! Task description requires all words to begin with an upper case letter
 !if (word(1:1) .ge. 'a' .and. word(1:1) .le. 'z')    &                                      ! lower?
 !     Words(content)(1:1) = char (ichar( Words(content)(1:1) ) - ichar('a') + ichar('A'))   ! to Upper

  end subroutine addWord
  ! ----------------------------------------------
  ! Increase allocated size of string array 'var'
  ! ----------------------------------------------
  subroutine resize(var, newSize)
  character (len=longestWord), allocatable, intent(inout) :: var(:)   ! The array to be increased
  integer, intent(in)                             :: newSize          ! The new size of var
  character (len=longestWord), allocatable                :: tmp(:)   ! Temporary storage
  integer                                         :: oldSize          ! Current array size
  integer                                         :: ii               ! Loop index

  ! Copy allocated values to temporary, then allocate var with
  ! new size and copy back saved values.
  ! Could be done with move_alloc but this would not be portable to OpenVMS Fortran
  if (allocated(var)) then
    oldSize = size(var)
  else
    oldSize = 0
  end if

  if (newSize .gt. oldSize) then           ! only increment
    if (oldSize .gt.0) then
      allocate(tmp (oldSize))
      tmp(:oldSize) = var(:oldSize)
      deallocate (var)
    end if
    allocate(var(newSize))
    if (allocated(tmp) .and. allocated (var) ) then
      oldSize = min(size(tmp, 1), size(var, 1))
      var(:oldSize) = tmp(:oldSize)
      deallocate (tmp)
    end if
    do ii=oldSize+1, newSize
      var (ii)(1:) = ' '
    end do
  end if
end subroutine resize



end program Passphrasegenerator
