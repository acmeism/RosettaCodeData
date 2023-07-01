program population_count
  implicit none

  integer, parameter :: i64 = selected_int_kind(18)
  integer(i64) :: x
  integer :: i, n

  x = 1
  write(*, "(a8)", advance = "no") "3**i :"
  do i = 1, 30
    write(*, "(i3)", advance = "no") popcnt(x)
    x = x * 3
  end do

  write(*,*)
  write(*, "(a8)", advance = "no") "Evil :"
  n = 0
  x = 0
  do while(n < 30)
    if(mod(popcnt(x), 2) == 0) then
      n = n + 1
      write(*, "(i3)", advance = "no") x
    end if
    x = x + 1
  end do

  write(*,*)
  write(*, "(a8)", advance = "no") "Odious :"
  n = 0
  x = 0
  do while(n < 30)
    if(mod(popcnt(x), 2) /= 0) then
      n = n + 1
      write(*, "(i3)", advance = "no") x
    end if
    x = x + 1
  end do

contains

integer function popcnt(x)
  integer(i64), intent(in) :: x
  integer :: i

  popcnt = 0
  do i = 0, 63
    if(btest(x, i)) popcnt = popcnt + 1
  end do

end function
end program
