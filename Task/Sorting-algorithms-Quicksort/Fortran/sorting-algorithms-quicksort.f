module qsort_mod

implicit none

type group
    integer :: order    ! original order of unsorted data
    real :: value       ! values to be sorted by
end type group

contains

recursive subroutine QSort(a,na)

! DUMMY ARGUMENTS
integer, intent(in) :: nA
type (group), dimension(nA), intent(in out) :: A

! LOCAL VARIABLES
integer :: left, right
real :: random
real :: pivot
type (group) :: temp
integer :: marker

    if (nA > 1) then

        call random_number(random)
        pivot = A(int(random*real(nA-1))+1)%value    ! random pivot (not best performance, but avoids worst-case)
        left = 0
        right = nA + 1

        do while (left < right)
            right = right - 1
            do while (A(right)%value > pivot)
                right = right - 1
            end do
            left = left + 1
            do while (A(left)%value < pivot)
                left = left + 1
            end do
            if (left < right) then
                temp = A(left)
                A(left) = A(right)
                A(right) = temp
            end if
        end do

        if (left == right) then
            marker = left + 1
        else
            marker = left
        end if

        call QSort(A(:marker-1),marker-1)
        call QSort(A(marker:),nA-marker+1)

    end if

end subroutine QSort

end module qsort_mod

! Test Qsort Module
program qsort_test
use qsort_mod
implicit none

integer, parameter :: l = 8
type (group), dimension(l) :: A
integer, dimension(3) :: seed = [1, 2, 3]
integer :: i
real :: random

    write (*,*) "Unsorted Values:"
    call random_seed(put = seed)
    do i = 1, l
        call random_number(random)
        A(i)%value = random
        A(i)%order = i
        if (mod(i,4) == 0) write (*,"(4(I5,1X,F8.6))") A(i-3:i)
    end do

    call QSort(A,l)
    write (*,*) "Sorted Values:"
    do i = 4, l, 4
        if (mod(i,4) == 0) write (*,"(4(I5,1X,F8.6))") A(i-3:i)
    end do

end program qsort_test
