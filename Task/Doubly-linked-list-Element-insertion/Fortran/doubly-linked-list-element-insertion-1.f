module dlList
    public :: node, insertAfter, getNext

    type node
        real :: data
        type( node ), pointer :: next => null()
        type( node ), pointer :: previous => null()
    end type node

contains
    subroutine insertAfter(nodeBefore, value)
        type( node ), intent(inout), target :: nodeBefore
        type( node ), pointer :: newNode
        real, intent(in) :: value

        allocate( newNode )
        newNode%data = value
        newNode%next => nodeBefore%next
        newNode%previous => nodeBefore

        if (associated( newNode%next )) then
            newNode%next%previous => newNode
        end if
        newNode%previous%next => newNode
    end subroutine insertAfter

    subroutine delete(current)
        type( node ), intent(inout), pointer :: current

        if (associated( current%next )) current%next%previous => current%previous
        if (associated( current%previous )) current%previous%next => current%next
        deallocate(current)
    end subroutine delete
end module dlList

program dlListTest
    use dlList
    type( node ), target :: head
    type( node ), pointer :: current, next

    head%data = 1.0
    current => head
    do i = 1, 20
       call insertAfter(current, 2.0**i)
       current => current%next
    end do

    current => head
    do while (associated(current))
        print *, current%data
        next => current%next
        if (.not. associated(current, head)) call delete(current)
        current => next
    end do
end program dlListTest
