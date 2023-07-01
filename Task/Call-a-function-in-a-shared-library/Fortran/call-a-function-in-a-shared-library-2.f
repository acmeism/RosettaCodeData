function  add_nf(a,b) bind(c, name='add_nf')
use, intrinsic :: iso_c_binding
implicit none
real(c_double), intent(in) :: a,b
real(c_double) :: add_nf

add_nf = a + b
end function add_nf
