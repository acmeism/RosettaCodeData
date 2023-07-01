type intpointer
  integer, pointer :: p
end type intpointer

!...
  type(intpointer), dimension(100)  :: parray
