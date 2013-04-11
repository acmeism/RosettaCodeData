program Factors
  implicit none
  integer :: i, number

  write(*,*) "Enter a number between 1 and 2147483647"
  read*, number

  do i = 1, int(sqrt(real(number))) - 1
    if (mod(number, i) == 0) write (*,*) i, number/i
  end do

  ! Check to see if number is a square
  i = int(sqrt(real(number)))
  if (i*i == number) then
     write (*,*) i
  else if (mod(number, i) == 0) then
     write (*,*) i, number/i
  end if

end program
