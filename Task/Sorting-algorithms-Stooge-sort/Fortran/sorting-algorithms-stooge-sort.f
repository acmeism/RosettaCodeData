program Stooge
  implicit none

  integer :: i
  integer :: array(50) = (/ (i, i = 50, 1, -1) /) ! Reverse sorted array

  call Stoogesort(array)
  write(*,"(10i5)") array

contains

recursive subroutine Stoogesort(a)
  integer, intent(in out) :: a(:)
  integer :: j, t, temp

   j = size(a)
   if(a(j) < a(1)) then
     temp = a(j)
     a(j) = a(1)
     a(1) = temp
   end if

  if(j > 2) then
    t = j / 3
    call Stoogesort(a(1:j-t))
    call Stoogesort(a(1+t:j))
    call Stoogesort(a(1:j-t))
  end if

end subroutine
end program
