program combinations

  implicit none
  integer, parameter :: m_max = 3
  integer, parameter :: n_max = 5
  integer, dimension (m_max) :: comb
  character (*), parameter :: fmt = '(i0' // repeat (', 1x, i0', m_max - 1) // ')'

  call gen (1)

contains

  recursive subroutine gen (m)

    implicit none
    integer, intent (in) :: m
    integer :: n

    if (m > m_max) then
      write (*, fmt) comb
    else
      do n = 1, n_max
        if ((m == 1) .or. (n > comb (m - 1))) then
          comb (m) = n
          call gen (m + 1)
        end if
      end do
    end if

  end subroutine gen

end program combinations
