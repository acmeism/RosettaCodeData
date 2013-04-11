program Pancake_Demo
  implicit none

  integer :: list(8) = (/ 1, 4, 7, 2, 5, 8, 3, 6 /)

  call Pancake_sort(list)

contains

subroutine Pancake_sort(a)

  integer, intent(in out) :: a(:)
  integer :: i, maxpos

  write(*,*) a
  do i = size(a), 2, -1

! Find position of max number between index 1 and i
    maxpos = maxloc(a(1:i), 1)

! is it in the correct position already?
    if (maxpos == i) cycle

! is it at the beginning of the array? If not flip array section so it is
    if (maxpos /= 1) then
      a(1:maxpos) = a(maxpos:1:-1)
      write(*,*) a
    end if

! Flip array section to get max number to correct position
    a(1:i) = a(i:1:-1)
    write(*,*) a
  end do

end subroutine

end program Pancake_Demo
