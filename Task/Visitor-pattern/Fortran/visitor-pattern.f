module visitor_mod
    implicit none

    ! Abstract type for car_element
    type, abstract :: car_element
    contains
        procedure(accept_interface), deferred :: accept
    end type car_element

    ! Accept interface after car_element
    abstract interface
        subroutine accept_interface(this, visitor)
            import :: car_element
            class(car_element), intent(inout) :: this
            class(*), intent(inout) :: visitor
        end subroutine accept_interface
    end interface

    ! Concrete wheel type
    type, extends(car_element) :: wheel_type
        character(len=20) :: name
    contains
        procedure :: accept => wheel_accept
    end type wheel_type

    ! Concrete engine type
    type, extends(car_element) :: engine_type
    contains
        procedure :: accept => engine_accept
    end type engine_type

    ! Concrete body type
    type, extends(car_element) :: body_type
    contains
        procedure :: accept => body_accept
    end type body_type

    ! Holder for elements
    type :: element_holder
        class(car_element), allocatable :: elem
    end type element_holder

    ! Concrete car type
    type, extends(car_element) :: car_type
        type(element_holder), allocatable :: elements(:)
    contains
        procedure :: accept => car_accept
    end type car_type

    ! Abstract type for car_element_visitor
    type, abstract :: car_element_visitor
    contains
        procedure(visit_wheel_interface), deferred :: visit_wheel
        procedure(visit_engine_interface), deferred :: visit_engine
        procedure(visit_body_interface), deferred :: visit_body
        procedure(visit_car_interface), deferred :: visit_car
    end type car_element_visitor

    ! Visit interfaces after car_element_visitor and concrete elements
    abstract interface
        subroutine visit_wheel_interface(this, wheel)
            import :: car_element_visitor, wheel_type
            class(car_element_visitor), intent(inout) :: this
            class(wheel_type), intent(inout) :: wheel
        end subroutine visit_wheel_interface
    end interface

    abstract interface
        subroutine visit_engine_interface(this, engine)
            import :: car_element_visitor, engine_type
            class(car_element_visitor), intent(inout) :: this
            class(engine_type), intent(inout) :: engine
        end subroutine visit_engine_interface
    end interface

    abstract interface
        subroutine visit_body_interface(this, body)
            import :: car_element_visitor, body_type
            class(car_element_visitor), intent(inout) :: this
            class(body_type), intent(inout) :: body
        end subroutine visit_body_interface
    end interface

    abstract interface
        subroutine visit_car_interface(this, car)
            import :: car_element_visitor, car_type
            class(car_element_visitor), intent(inout) :: this
            class(car_type), intent(inout) :: car
        end subroutine visit_car_interface
    end interface

    ! Concrete print visitor
    type, extends(car_element_visitor) :: car_element_print_visitor
    contains
        procedure :: visit_wheel => print_visit_wheel
        procedure :: visit_engine => print_visit_engine
        procedure :: visit_body => print_visit_body
        procedure :: visit_car => print_visit_car
    end type car_element_print_visitor

    ! Concrete do visitor
    type, extends(car_element_visitor) :: car_element_do_visitor
    contains
        procedure :: visit_wheel => do_visit_wheel
        procedure :: visit_engine => do_visit_engine
        procedure :: visit_body => do_visit_body
        procedure :: visit_car => do_visit_car
    end type car_element_do_visitor

contains

    ! Implement accept methods
    subroutine wheel_accept(this, visitor)
        class(wheel_type), intent(inout) :: this
        class(*), intent(inout) :: visitor
        select type(visitor)
            class is (car_element_visitor)
                call visitor%visit_wheel(this)
        end select
    end subroutine wheel_accept

    subroutine engine_accept(this, visitor)
        class(engine_type), intent(inout) :: this
        class(*), intent(inout) :: visitor
        select type(visitor)
            class is (car_element_visitor)
                call visitor%visit_engine(this)
        end select
    end subroutine engine_accept

    subroutine body_accept(this, visitor)
        class(body_type), intent(inout) :: this
        class(*), intent(inout) :: visitor
        select type(visitor)
            class is (car_element_visitor)
                call visitor%visit_body(this)
        end select
    end subroutine body_accept

    subroutine car_accept(this, visitor)
        class(car_type), intent(inout) :: this
        class(*), intent(inout) :: visitor
        integer :: i
        select type(visitor)
            class is (car_element_visitor)
                do i = 1, size(this%elements)
                    call this%elements(i)%elem%accept(visitor)
                end do
                call visitor%visit_car(this)
        end select
    end subroutine car_accept

    ! Implement print visitor methods
    subroutine print_visit_wheel(this, wheel)
        class(car_element_print_visitor), intent(inout) :: this
        class(wheel_type), intent(inout) :: wheel
        print *, "Visiting " // trim(wheel%name) // " wheel"
    end subroutine print_visit_wheel

    subroutine print_visit_engine(this, engine)
        class(car_element_print_visitor), intent(inout) :: this
        class(engine_type), intent(inout) :: engine
        print *, "Visiting engine"
    end subroutine print_visit_engine

    subroutine print_visit_body(this, body)
        class(car_element_print_visitor), intent(inout) :: this
        class(body_type), intent(inout) :: body
        print *, "Visiting body"
    end subroutine print_visit_body

    subroutine print_visit_car(this, car)
        class(car_element_print_visitor), intent(inout) :: this
        class(car_type), intent(inout) :: car
        print *, "Visiting car"
    end subroutine print_visit_car

    ! Implement do visitor methods
    subroutine do_visit_wheel(this, wheel)
        class(car_element_do_visitor), intent(inout) :: this
        class(wheel_type), intent(inout) :: wheel
        print *, "Kicking my " // trim(wheel%name) // " wheel"
    end subroutine do_visit_wheel

    subroutine do_visit_engine(this, engine)
        class(car_element_do_visitor), intent(inout) :: this
        class(engine_type), intent(inout) :: engine
        print *, "Starting my engine"
    end subroutine do_visit_engine

    subroutine do_visit_body(this, body)
        class(car_element_do_visitor), intent(inout) :: this
        class(body_type), intent(inout) :: body
        print *, "Moving my body"
    end subroutine do_visit_body

    subroutine do_visit_car(this, car)
        class(car_element_do_visitor), intent(inout) :: this
        class(car_type), intent(inout) :: car
        print *, "Starting my car"
    end subroutine do_visit_car

end module visitor_mod

program visitor_pattern
    use visitor_mod
    implicit none

    ! Main execution
    type(car_type) :: car
    type(car_element_print_visitor) :: print_visitor
    type(car_element_do_visitor) :: do_visitor

    allocate(car%elements(6))

    allocate(wheel_type :: car%elements(1)%elem)
    select type (el => car%elements(1)%elem)
        type is (wheel_type)
            el%name = "front left"
    end select

    allocate(wheel_type :: car%elements(2)%elem)
    select type (el => car%elements(2)%elem)
        type is (wheel_type)
            el%name = "front right"
    end select

    allocate(wheel_type :: car%elements(3)%elem)
    select type (el => car%elements(3)%elem)
        type is (wheel_type)
            el%name = "back left"
    end select

    allocate(wheel_type :: car%elements(4)%elem)
    select type (el => car%elements(4)%elem)
        type is (wheel_type)
            el%name = "back right"
    end select

    allocate(body_type :: car%elements(5)%elem)

    allocate(engine_type :: car%elements(6)%elem)

    call car%accept(print_visitor)
    print *, ""  ! Empty line for separation
    call car%accept(do_visitor)

end program visitor_pattern
