type node
   real :: data
   type(node), pointer :: next => null(), previous => null()
end type node
!
! . . . .
!
type( node ), target :: head
