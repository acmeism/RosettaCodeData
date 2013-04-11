program luhn
  implicit none
  integer              :: nargs
  character(len=20)    :: arg
  integer              :: alen, i, dr
  integer, allocatable :: number(:)
  integer, parameter   :: drmap(0:9) = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]

  ! Get number
  nargs = command_argument_count()
  if (nargs /= 1) then
     stop
  end if
  call get_command_argument(1, arg, alen)
  allocate(number(alen))
  do i=1, alen
     number(alen-i+1) = iachar(arg(i:i)) - iachar('0')
  end do

  ! Calculate number
  dr = 0
  do i=1, alen
     dr = dr + merge(drmap(number(i)), number(i), mod(i,2) == 0)
  end do

  if (mod(dr,10) == 0) then
     write(*,'(a,i0)') arg(1:alen)//' is valid'
  else
     write(*,'(a,i0)') arg(1:alen)//' is not valid'
  end if
end program luhn

! Results:
! 49927398716 is valid
! 49927398717 is not valid
! 1234567812345678 is not valid
! 1234567812345670 is valid
