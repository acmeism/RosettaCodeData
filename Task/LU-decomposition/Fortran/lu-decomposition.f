program lu1
implicit none

real*8     :: a1(3,3), a2(4,4)

a1 = reshape((/real*8::1,2,1,3,4,1,5,7,0/),(/3,3/))
call check(a1)

a2 = reshape((/real*8::11,1,3,2,9,5,17,5,24,2,18,7,2,6,1,1/),(/4,4/))
call check(a2)

contains

subroutine lu(a,p)
! in situ decomposition, correspondes to LAPACK's dgebtrf
implicit none
real*8, intent(inout) :: a(:,:)
integer, intent(out)  :: p(:)
integer               :: n, i,j,k,ii
n = ubound(a,1)
p = (/ ( i, i=1,n ) /)
do k = 1,n-1
    ii = k-1+maxloc(abs(a(p(k:),k)),1)
    if (ii /= k )  then
        p((/k, ii/)) = p((/ii, k/))
    end if
    a(p(k+1:),k) = a(p(k+1:),k)/a(p(k),k)
    forall (j = k+1:n)
        a(p(k+1:),j) = a(p(k+1:),j)-a(p(k+1:),k)*a(p(k),j)
    end forall
end do
end subroutine

subroutine check(a)
implicit none
real*8, intent(in) :: a(:,:)
real*8             :: aa(ubound(a,1), ubound(a,2))
real*8             :: l(ubound(a,1), ubound(a,2))
real*8             :: u(ubound(a,1), ubound(a,2))
integer            :: p(ubound(a,1), ubound(a,2)), ipiv(ubound(a,1))
integer            :: i,  n
character(len=100) :: fmt

n = ubound(a,1)
aa = a ! work with a copy
p = 0; l=0; u = 0
forall (i=1:n)
    p(i,i) = 1d0; l(i,i) = 1d0 ! convert permutation vector a matrix
end forall

call lu(aa, ipiv)
do i = 1,n
   l(i,:i-1) = aa(ipiv(i),:i-1)
   u(i,i:) = aa(ipiv(i),i:)
end do
p(ipiv,:) = p
write (fmt,"(a,i1,a)") "(",n,"(f8.2,1x))"

print *, "a"
print fmt, transpose(a)

print *, "p"
print fmt, transpose(dble(p))

print *, "l"
print fmt, transpose(l)

print *, "u"
print fmt, transpose(u)

print *, "residual"
print *, "|| P.A - L.U || =  ", maxval(abs(matmul(p,a)-matmul(l,u)))

end subroutine
end program>
