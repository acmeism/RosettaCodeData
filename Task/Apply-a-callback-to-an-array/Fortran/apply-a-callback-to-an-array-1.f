module arrCallback
contains
    elemental function cube( x )
        implicit none
        real :: cube
        real, intent(in) :: x
        cube = x * x * x
    end function cube
end module arrCallback
