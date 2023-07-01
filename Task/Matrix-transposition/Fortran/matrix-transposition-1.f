integer, parameter   :: n = 3, m = 5
real, dimension(n,m) :: a = reshape( (/ (i,i=1,n*m) /), (/ n, m /) )
real, dimension(m,n) :: b

b = transpose(a)

do i = 1, n
    print *, a(i,:)
end do

do j = 1, m
    print *, b(j,:)
end do
