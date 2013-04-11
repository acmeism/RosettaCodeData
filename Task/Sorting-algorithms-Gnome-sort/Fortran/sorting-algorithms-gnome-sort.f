program example

  implicit none

  integer :: array(8) = (/ 2, 8, 6, 1, 3, 5, 4, 7 /)

  call Gnomesort(array)
  write(*,*) array

contains

subroutine Gnomesort(a)

  integer, intent(in out) :: a(:)
  integer :: i, j, temp

  i = 2
  j = 3
  do while (i <= size(a))
    if (a(i-1) <= a(i)) then
      i = j
      j = j + 1
    else
      temp = a(i-1)
      a(i-1) = a(i)
      a(i) = temp
      i = i -  1
      if (i == 1) then
        i = j
        j = j + 1
      end if
    end if
  end do

end subroutine Gnomesort

end program example
