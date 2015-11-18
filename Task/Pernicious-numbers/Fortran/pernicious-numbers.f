program pernicious
  implicit none

  integer :: i, n

  i = 1
  n = 0
  do
    if(isprime(popcnt(i))) then
      write(*, "(i0, 1x)", advance = "no") i
      n = n + 1
      if(n == 25) exit
    end if
    i = i + 1
  end do

  write(*,*)
  do i = 888888877, 888888888
    if(isprime(popcnt(i))) write(*, "(i0, 1x)", advance = "no") i
  end do

contains

function popcnt(x)
  integer :: popcnt
  integer, intent(in) :: x
  integer :: i

  popcnt = 0
  do i = 0, 31
    if(btest(x, i)) popcnt = popcnt + 1
  end do

end function

function isprime(number)
  logical :: isprime
  integer, intent(in) :: number
  integer :: i

  if(number == 2) then
    isprime = .true.
  else if(number < 2 .or. mod(number,2) == 0) then
    isprime = .false.
  else
    isprime = .true.
    do i = 3, int(sqrt(real(number))), 2
      if(mod(number,i) == 0) then
        isprime = .false.
        exit
      end if
    end do
  end if
end function
end program
