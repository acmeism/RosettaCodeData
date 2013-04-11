module Rref
  implicit none
contains
  subroutine to_rref(matrix)
    real, dimension(:,:), intent(inout) :: matrix

    integer :: pivot, norow, nocolumn
    integer :: r, i
    real, dimension(:), allocatable :: trow

    pivot = 1
    norow = size(matrix, 1)
    nocolumn = size(matrix, 2)

    allocate(trow(nocolumn))

    do r = 1, norow
       if ( nocolumn <= pivot ) exit
       i = r
       do while ( matrix(i, pivot) == 0 )
          i = i + 1
          if ( norow == i ) then
             i = r
             pivot = pivot + 1
             if ( nocolumn == pivot ) return
          end if
       end do
       trow = matrix(i, :)
       matrix(i, :) = matrix(r, :)
       matrix(r, :) = trow
       matrix(r, :) = matrix(r, :) / matrix(r, pivot)
       do i = 1, norow
          if ( i /= r ) matrix(i, :) = matrix(i, :) - matrix(r, :) * matrix(i, pivot)
       end do
       pivot = pivot + 1
    end do
    deallocate(trow)
  end subroutine to_rref
end module Rref
