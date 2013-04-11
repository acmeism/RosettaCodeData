integer, dimension(10) :: a = (/ (i, i=1, 10) /)
integer :: sresult, presult

sresult = sum(a);
presult = product(a);
