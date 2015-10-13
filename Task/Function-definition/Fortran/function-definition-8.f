module elemFunc
contains
    elemental function multiply(x, y) result(z)
        real, intent(in) :: x, y
        real :: z
        z = x * y
    end function multiply
end module elemFunc
