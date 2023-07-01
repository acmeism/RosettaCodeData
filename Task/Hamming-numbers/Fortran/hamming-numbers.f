program Hamming_Test
  use big_integer_module
  implicit none

  call Hamming(1,20)
  write(*,*)
  call Hamming(1691)
  write(*,*)
  call Hamming(1000000)

contains

subroutine Hamming(first, last)

  integer, intent(in) :: first
  integer, intent(in), optional :: last
  integer :: i, n, i2, i3, i5, lim
  type(big_integer), allocatable :: hnums(:)

  if(present(last)) then
    lim = last
  else
    lim = first
  end if

  if(first < 1 .or. lim > 2500000 ) then
    write(*,*) "Invalid input"
    return
  end if

  allocate(hnums(lim))

  i2 = 1 ;  i3 = 1 ; i5 = 1
  hnums(1) = 1
  n = 1
  do while(n < lim)
    n = n + 1
    hnums(n) = mini(2*hnums(i2), 3*hnums(i3), 5*hnums(i5))
    if(2*hnums(i2) == hnums(n)) i2 = i2 + 1
    if(3*hnums(i3) == hnums(n)) i3 = i3 + 1
    if(5*hnums(i5) == hnums(n)) i5 = i5 + 1
  end do

  if(present(last)) then
    do i = first, last
      call print_big(hnums(i))
      write(*, "(a)", advance="no") " "
    end do
  else
    call print_big(hnums(first))
  end if

  deallocate(hnums)
end subroutine

function mini(a, b, c)
  type(big_integer) :: mini
  type(big_integer), intent(in) :: a, b, c

  if(a < b ) then
    if(a < c) then
      mini = a
    else
      mini = c
    end if
  else if(b < c) then
    mini = b
  else
    mini = c
  end if
end function mini
end program
