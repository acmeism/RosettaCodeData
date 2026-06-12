module cuboid_module
    implicit none
    type :: Cuboid
        real :: length
        real :: breadth
        real :: height
    contains
        procedure :: getVolume => cuboid_volume
        procedure :: setLength => cuboid_set_length
        procedure :: setBreadth => cuboid_set_breadth
        procedure :: setHeight => cuboid_set_height
        generic :: operator(+) => cuboid_add
        generic :: operator(-) => cuboid_subtract
        procedure, private :: cuboid_add
        procedure, private :: cuboid_subtract
    end type Cuboid

contains

    function cuboid_volume(this) result(volume)
        class(Cuboid), intent(in) :: this
        real :: volume
        volume = this%length * this%breadth * this%height
    end function cuboid_volume

    subroutine cuboid_set_length(this, l)
        class(Cuboid), intent(inout) :: this
        real, intent(in) :: l
        this%length = l
    end subroutine cuboid_set_length

    subroutine cuboid_set_breadth(this, b)
        class(Cuboid), intent(inout) :: this
        real, intent(in) :: b
        this%breadth = b
    end subroutine cuboid_set_breadth

    subroutine cuboid_set_height(this, h)
        class(Cuboid), intent(inout) :: this
        real, intent(in) :: h
        this%height = h
    end subroutine cuboid_set_height

    function cuboid_add(a, b) result(c)
        class(Cuboid), intent(in) :: a, b
        type(Cuboid) :: c
        c%length = a%length + b%length
        c%breadth = a%breadth + b%breadth
        c%height = a%height + b%height
    end function cuboid_add

    function cuboid_subtract(a, b) result(c)
        class(Cuboid), intent(in) :: a, b
        type(Cuboid) :: c
        c%length = a%length - b%length
        c%breadth = a%breadth - b%breadth
        c%height = a%height - b%height
    end function cuboid_subtract

end module cuboid_module

program main
    use cuboid_module
    implicit none
    type(Cuboid) :: c1, c2, c3
    real :: volume

    call c1%setLength(6.0)
    call c1%setBreadth(7.0)
    call c1%setHeight(5.0)

    call c2%setLength(12.0)
    call c2%setBreadth(13.0)
    call c2%setHeight(10.0)

    volume = c1%getVolume()
    print *, "Volume of 1st cuboid: ", volume

    volume = c2%getVolume()
    print *, "Volume of 2nd cuboid: ", volume

    c3 = c1 + c2
    volume = c3%getVolume()
    print *, "Volume of 3rd cuboid after adding: ", volume

    c3 = c1 - c2
    volume = c3%getVolume()
    print *, "Volume of 3rd cuboid after subtracting: ", volume

end program main

