program Combsort_Demo
  implicit none

  integer, parameter :: num = 20
  real :: array(num)

  call random_seed
  call random_number(array)
  write(*,*) "Unsorted array:-"
  write(*,*) array
  write(*,*)
  call combsort(array)
  write(*,*) "Sorted array:-"
  write(*,*) array

contains

  subroutine combsort(a)

    real, intent(in out) :: a(:)
    real :: temp
    integer :: i, gap
    logical :: swapped = .true.

    gap = size(a)
    do while (gap > 1 .or. swapped)
      gap = gap / 1.3
      if (gap < 1) gap = 1
      swapped = .false.
      do i = 1, size(a)-gap
        if (a(i) > a(i+gap)) then
          temp = a(i)
          a(i) = a(i+gap)
          a(i+gap) = temp;
          swapped = .true.
        end if
      end do
    end do

  end subroutine combsort

end program Combsort_Demo
