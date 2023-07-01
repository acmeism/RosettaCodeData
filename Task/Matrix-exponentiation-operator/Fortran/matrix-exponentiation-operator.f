module matmod
  implicit none

! Overloading the ** operator does not work because the compiler cannot
! differentiate between matrix exponentiation and the elementwise raising
! of an array to a power therefore we define a new operator
  interface operator (.matpow.)
    module procedure matrix_exp
  end interface

contains

function matrix_exp(m, n) result (res)
  real, intent(in)  :: m(:,:)
  integer, intent(in)  :: n
  real :: res(size(m,1),size(m,2))
  integer :: i

  if(n == 0) then
    res = 0
    do i = 1, size(m,1)
      res(i,i) = 1
    end do
    return
  end if

  res = m
  do i = 2, n
    res = matmul(res, m)
  end do

end function matrix_exp
end module matmod

program Matrix_exponentiation
  use matmod
  implicit none

  integer, parameter :: n = 3
  real, dimension(n,n) :: m1, m2
  integer :: i, j

  m1 = reshape((/ (i, i = 1, n*n) /), (/ n, n /), order = (/ 2, 1 /))

  do i = 0, 4
    m2 = m1 .matpow. i
    do j = 1, size(m2,1)
      write(*,*) m2(j,:)
    end do
    write(*,*)
  end do

end program Matrix_exponentiation
