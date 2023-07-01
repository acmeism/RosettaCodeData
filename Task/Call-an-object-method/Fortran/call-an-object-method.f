! type declaration
type my_type
 contains
procedure, pass :: method1
procedure, pass, pointer :: method2
end type my_type

! declare object of type my_type
type(my_type) :: mytype_object

!static call
 call mytype_object%method1() ! call method1 defined as subroutine
!instance?
 mytype_object%method2() ! call method2 defined as function
