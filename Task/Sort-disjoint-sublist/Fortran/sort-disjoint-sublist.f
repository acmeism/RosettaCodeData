program Example
  implicit none

  integer :: array(8) = (/ 7, 6, 5, 4, 3, 2, 1, 0 /)
  integer :: indices(3) = (/ 7, 2, 8 /)

! In order to make the output insensitive to index order
! we need to sort the indices first
  call Isort(indices)

! Should work with any sort routine as long as the dummy
! argument array has been declared as an assumed shape array
! Standard insertion sort used in this example
  call Isort(array(indices))

  write(*,*) array

contains

subroutine Isort(a)
  integer, intent(in out) :: a(:)
  integer :: temp
  integer :: i, j

  do i = 2, size(a)
     j = i - 1
     temp = a(i)
     do while (j>=1 .and. a(j)>temp)
        a(j+1) = a(j)
        j = j - 1
     end do
     a(j+1) = temp
  end do

end subroutine Isort
end program Example
