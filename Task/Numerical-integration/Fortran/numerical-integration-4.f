module FunctionHolder
  implicit none

contains

  pure function afun(x)
    real :: afun
    real, intent(in) :: x

    afun = x**2
  end function afun

end module FunctionHolder
