module PrimeDecompose
  implicit none

  integer, parameter :: huge = selected_int_kind(18)
  ! => integer(8) ... more fails on my 32 bit machine with gfortran(gcc) 4.3.2

contains

  subroutine find_factors(n, d)
    integer(huge), intent(in) :: n
    integer, dimension(:), intent(out) :: d

    integer(huge) :: div, next, rest
    integer :: i

    i = 1
    div = 2; next = 3; rest = n

    do while ( rest /= 1 )
       do while ( mod(rest, div) == 0 )
          d(i) = div
          i = i + 1
          rest = rest / div
       end do
       div = next
       next = next + 2
    end do

  end subroutine find_factors

end module PrimeDecompose
