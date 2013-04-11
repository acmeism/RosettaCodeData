type node
   real :: data
   type( node ), pointer :: next => null()
end type node
!
!. . . .
!
type( node ) :: head
