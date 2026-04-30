!
! Password generator
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!  but not with VSI Fortran x86-64 beause that compiler does not know the
!  Fortran 2003 style command line handling.
! U.B., April 2026
!

program passwordGenerator
implicit none

character (len=50) :: Password
character (len=*), parameter ::lowerCase = 'abcdefghijklmnopqrstuvwxyz'
character (len=*), parameter ::upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
character (len=*), parameter ::digits='0123456789'
character (len=*), parameter ::others = '!"#$%&''()*+,-./:;<=>?@[]^_{|}~'
character (len=*), parameter :: any = lowerCase//upperCase//digits//others

character(len=12), dimension(:), allocatable :: args

integer :: pwLen, nPassw

integer :: ii, remLen, num_args, pos, ios
character :: c

num_args = command_argument_count()
! Provide defaults for the command line options.
pwLen = 20
nPassw=1
if (num_args .gt. 0)  then
  allocate(args(num_args))  ! omitted checking the return status of the allocation
  do ii = 1, num_args
   call get_command_argument(ii,args(ii))
  end do
  !
  ! from the task description: The user must be able to specify the password
  !                            length and the number of passwords to generate.
  ! Expect Command line arguments: -l [integer], -n [integer]
  ! Help is displayed if any command line argument other -l length or -n Number of Passwds
  !
  ii = 1
  do while (num_args .ge. ii)
    if (args(ii) .eq. '-l') then
      ii = ii + 1
      if (ii .le. num_args) then
        read (args(ii), *, iostat = ios)  pwLen
        if (ios .ne. 0 .or. pwLen .gt. 50  ) then
          write (*, '(/A,X,A)')  args(ii), 'Is not a valid input for the passwpord length: '
          call help()
          stop
        else
          ii = ii + 1     ! Prepare to get next argument
        endif
      else
        write (*, '(/A)')  'Missing password length after "-l"'
        call help()
        stop
      endif
    else if (args(ii) .eq. '-n') then
      ii = ii + 1
      if (ii .le. num_args) then
        read (args(ii), *, iostat = ios)  nPassw
        if (ios .ne. 0) then
          write (*, '(/A,X,A)')  args(ii), 'Is not a valid input for number of passwpords.'
          call help()
          stop
        else
          ii = ii + 1     ! Prepare to get next argument
        endif
      else
        write (*, '(/A)')  'Missing number of passwords after "-n"'
        call help()
        stop
      end if
  ! From Task description: the You may also allow the user to specify a
  !                        seed value, and give the option of excluding
  !                        visually similar characters. These 2 features are
  !                        optional, hence omitted here.
  ! else if (...)   Add the code for more options here
    else
      ! provide help if any argument other than -l <len> or -n <num> given
      call help()
      stop
    end if
  enddo
endif
! from the task description: The randomness should be from a system source or library.
! If RANDOM_SEED is called without arguments, it is seeded with random data
! retrieved from the operating system.
call random_seed()
do ii=1, nPassw
  password = ' '        ! Start with all blank.
  remlen = pwLen        ! Remaining chars to fill

  ! from the task description: The generated password(s) must include
  !                            at least 1 (of each of the four groups)
  call addRandomCharacter (upperCase)
  call addRandomCharacter (lowerCase)
  call addRandomCharacter (digits)
  call addRandomCharacter (others)

  ! Fill up ramaining locations with characters of any type
  do while (remLen .gt. 0)
    call addRandomCharacter (any)
  enddo
  write (*,'(A)'), password
end do

contains

! =====================================================
! Print help text to explain the command line arguments
! =====================================================
subroutine help()
write (*, '(/A/)') 'Valid command line arguments are:'
write (*, '(A)') '-n <nPassword> : Number of passwords to generate'
write (*, '(A)') '-l <length>    : Length of password(s) (<=50)'

end subroutine help

! ====================================================================================
! Randomly select a character from charset, and place it at a randomly selected empty
! space in the password
! ====================================================================================
subroutine   addRandomCharacter (charset)
character (len=*), intent(in) :: charset
integer:: pos
character :: c
  pos = randEmptyPos()
  c=randomCharacter(charset)
  Password (pos:pos) = c
  remLen = remLen-1
end subroutine   addRandomCharacter


! ========================================================
! Randomly select a character from the given character set
! ========================================================
function randomCharacter (charset) result (chr)
character (len=*), intent(in) :: charset
character :: chr
integer :: ipos, l

l = len (charset)
ipos = randominInterval (1, l)
chr = charset(ipos:ipos)
end function randomCharacter

! ========================================
! Select random empty position in password
! ========================================
function randEmptyPos() result (retv)
integer :: retv
integer :: ipos, ic, ii

ipos = randominInterval (1, remLen)
ic=0
do ii=1, pwLen
  if (Password(ii:ii) .eq. ' ') ic = ic + 1
  if (ic .eq. ipos) then
    retv = ii
    exit
  endif
end do
end function randEmptyPos

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


end program passwordGenerator
