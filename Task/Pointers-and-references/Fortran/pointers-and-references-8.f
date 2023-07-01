real, dimension(20), target :: a
real, dimension(20,20), target :: b
real, dimension(:), pointer :: p

p => a(5:20)
! p(1) == a(5), p(2) == a(6) ...
p => b(10,1:20)
! p(1) == b(10,1), p(2) == b(10,2) ...
