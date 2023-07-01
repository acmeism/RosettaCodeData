module cg
    implicit none

    type, abstract :: eatable
    end type eatable

    type, extends(eatable) :: carrot_t
    end type carrot_t

    type :: brick_t; end type brick_t

    type :: foodbox
	class(eatable), allocatable :: food
    contains
        procedure, public :: add_item => add_item_fb
    end type foodbox

contains

    subroutine add_item_fb(this, f)
        class(foodbox), intent(inout) :: this
        class(eatable), intent(in)    :: f
        allocate(this%food, source=f)
    end subroutine add_item_fb
end module cg


program con_gen
    use cg
    implicit none

    type(carrot_t) :: carrot
    type(brick_t)  :: brick
    type(foodbox)  :: fbox

    ! Put a carrot into the foodbox
    call fbox%add_item(carrot)

    ! Try to put a brick in - results in a compiler error
    call fbox%add_item(brick)

end program con_gen
