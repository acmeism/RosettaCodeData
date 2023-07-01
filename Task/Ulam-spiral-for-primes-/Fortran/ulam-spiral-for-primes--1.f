program ulam
  implicit none

  integer, parameter :: nsize = 49
  integer :: i, j, n, x, y
  integer :: a(nsize*nsize) = (/ (i, i = 1, nsize*nsize) /)
  character(1)  :: spiral(nsize, nsize) = " "
  character(2)  :: sstr
  character(10) :: fmt

  n = 1
  x = nsize / 2 + 1
  y = x
  if(isprime(a(n))) spiral(x, y) = "O"
  n = n + 1

  do i = 1, nsize-1, 2
    do j = 1, i
      x = x + 1
      if(isprime(a(n))) spiral(x, y) = "O"
      n = n + 1
    end do

    do j = 1, i
      y = y - 1
      if(isprime(a(n))) spiral(x, y) = "O"
      n = n + 1
    end do

    do j = 1, i+1
      x = x - 1
      if(isprime(a(n))) spiral(x, y) = "O"
      n = n + 1
    end do

    do j = 1, i+1
      y = y + 1
      if(isprime(a(n))) spiral(x, y) = "O"
      n = n + 1
    end do
  end do

  do j = 1, nsize-1
    x = x + 1
    if(isprime(a(n))) spiral(x, y) = "O"
    n = n + 1
  end do

  write(sstr, "(i0)") nsize
  fmt = "(" // sstr // "(a,1x))"
  do i = 1, nsize
    write(*, fmt) spiral(:, i)
  end do

contains

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
