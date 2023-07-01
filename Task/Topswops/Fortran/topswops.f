module top
implicit none
contains
recursive function f(x) result(m)
  integer :: n, m, x(:),y(size(x)), fst
  fst = x(1)
  if (fst == 1) then
    m = 0
  else
    y(1:fst) = x(fst:1:-1)
    y(fst+1:) = x(fst+1:)
    m = 1 + f(y)
  end if
end function

recursive function perms(x) result(p)
integer, pointer     :: p(:,:), q(:,:)
integer              :: x(:), n, k, i
n = size(x)
if (n == 1) then
  allocate(p(1,1))
  p(1,:) = x
else
  q => perms(x(2:n))
  k = ubound(q,1)
  allocate(p(k*n,n))
  p = 0
  do i = 1,n
    p(1+k*(i-1):k*i,1:i-1) = q(:,1:i-1)
    p(1+k*(i-1):k*i,i) = x(1)
    p(1+k*(i-1):k*i,i+1:) = q(:,i:)
  end do
end if
end function
end module

program topswort
use top
implicit none
integer :: x(10)
integer, pointer  :: p(:,:)
integer :: i, j, m

forall(i=1:10)
  x(i) = i
end forall

do i = 1,10
  p=>perms(x(1:i))
  m = 0
  do j = 1, ubound(p,1)
    m = max(m, f(p(j,:)))
  end do
  print "(i3,a,i3)", i,": ",m
end do
end program
