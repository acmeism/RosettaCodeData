program test_horner

  implicit none

  write (*, '(f5.1)') horner ([-19.0, 7.0, -4.0, 6.0], 3.0)

contains

  function horner (coeffs, x) result (res)

    implicit none
    real, dimension (0:), intent (in) :: coeffs
    real, intent (in) :: x
    real :: res
    integer :: i

    res = coeffs(ubound(coeffs,1))
    do i = ubound(coeffs,1)-1, 0, -1
      res = res * x + coeffs (i)
    end do

  end function horner

end program test_horner
