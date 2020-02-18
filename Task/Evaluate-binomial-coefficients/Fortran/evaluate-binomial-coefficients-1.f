program test_choose

  implicit none

  write (*, '(i0)') choose (5, 3)

contains

  function factorial (n) result (res)

    implicit none
    integer, intent (in) :: n
    integer :: res
    integer :: i

    res = product ((/(i, i = 1, n)/))

  end function factorial

  function choose (n, k) result (res)

    implicit none
    integer, intent (in) :: n
    integer, intent (in) :: k
    integer :: res

    res = factorial (n) / (factorial (k) * factorial (n - k))

  end function choose

end program test_choose
