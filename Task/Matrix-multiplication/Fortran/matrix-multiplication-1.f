real, dimension(n,m) :: a = reshape( (/ (i, i=1, n*m) /), (/ n, m /) )
real, dimension(m,k) :: b = reshape( (/ (i, i=1, m*k) /), (/ m, k /) )
real, dimension(size(a,1), size(b,2)) :: c    ! C is an array whose first dimension (row) size
                                              ! is the same as A's first dimension size, and
                                              ! whose second dimension (column) size is the same
                                              ! as B's second dimension size.

c = matmul( a, b )

print *, 'A'
do i = 1, n
    print *, a(i,:)
end do

print *,
print *, 'B'
do i = 1, m
    print *, b(i,:)
end do

print *,
print *, 'C = AB'
do i = 1, n
    print *, c(i,:)
end do
