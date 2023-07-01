!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Fri Jun  7 23:39:20
!
!a=./f && make $a && $a
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
!   3   4   5
!   5  12  13
!   6   8  10
!   8  15  17
!   9  12  15
!  12  16  20
!
!Compilation finished at Fri Jun  7 23:39:20

program list_comprehension
  integer, parameter :: n = 20
  integer, parameter :: m = n*(n+1)/2
  integer :: i, j
  complex, dimension(m) :: a
  real, dimension(m) :: b
  logical, dimension(m) :: c
  integer, dimension(3, m) :: d
  a = [ ( ( cmplx(i,j), i=j,n), j=1,n) ] ! list comprehension, implicit do loop
  b = abs(a)
  c = (b .eq. int(b)) .and. (b .le. n)
  i = sum(merge(1,0,c))
  d(2,:i) = int(real(pack(a, c))) ! list comprehensions: array
  d(1,:i) = int(imag(pack(a, c))) ! assignments and operations.
  d(3,:i) = int(pack(b,c))
  print '(3i4)',d(:,:i)
end program list_comprehension
