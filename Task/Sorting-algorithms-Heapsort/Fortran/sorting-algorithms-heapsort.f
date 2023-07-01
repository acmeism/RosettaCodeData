program Heapsort_Demo
  implicit none

  integer, parameter :: num = 20
  real :: array(num)

  call random_seed
  call random_number(array)
  write(*,*) "Unsorted array:-"
  write(*,*) array
  write(*,*)
  call heapsort(array)
  write(*,*) "Sorted array:-"
  write(*,*) array

contains

subroutine heapsort(a)

   real, intent(in out) :: a(0:)
   integer :: start, n, bottom
   real :: temp

   n = size(a)
   do start = (n - 2) / 2, 0, -1
     call siftdown(a, start, n);
   end do

   do bottom = n - 1, 1, -1
     temp = a(0)
     a(0) = a(bottom)
     a(bottom) = temp;
     call siftdown(a, 0, bottom)
   end do

end subroutine heapsort

subroutine siftdown(a, start, bottom)

  real, intent(in out) :: a(0:)
  integer, intent(in) :: start, bottom
  integer :: child, root
  real :: temp

  root = start
  do while(root*2 + 1 < bottom)
    child = root * 2 + 1

    if (child + 1 < bottom) then
      if (a(child) < a(child+1)) child = child + 1
    end if

    if (a(root) < a(child)) then
      temp = a(child)
      a(child) = a (root)
      a(root) = temp
      root = child
    else
      return
    end if
  end do

end subroutine siftdown

end program Heapsort_Demo
