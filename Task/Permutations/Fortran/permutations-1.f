program permutations

  implicit none
  integer, parameter :: value_min = 1
  integer, parameter :: value_max = 3
  integer, parameter :: position_min = value_min
  integer, parameter :: position_max = value_max
  integer, dimension (position_min : position_max) :: permutation

  call generate (position_min)

contains

  recursive subroutine generate (position)

    implicit none
    integer, intent (in) :: position
    integer :: value

    if (position > position_max) then
      write (*, *) permutation
    else
      do value = value_min, value_max
        if (.not. any (permutation (: position - 1) == value)) then
          permutation (position) = value
          call generate (position + 1)
        end if
      end do
    end if

  end subroutine generate

end program permutations
