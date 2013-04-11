module funcs
  implicit none
contains
  pure function iseven(x)
    logical :: iseven
    integer, intent(in) :: x
    iseven = mod(x, 2) == 0
  end function iseven
end module funcs
