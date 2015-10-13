module elemFunc
contains
    elemental function multiply(x, y)
        real, intent(in) :: x, y
        real :: multiply
        multiply = x * y
    end function multiply
end module elemFunc
