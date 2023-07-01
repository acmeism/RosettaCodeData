program conjugate_transpose

  complex, dimension(3, 3) :: a
  integer :: i
  a = reshape((/ (i, i=1,9) /), shape(a))
  call characterize(a)
  a(:2,:2) = reshape((/cmplx(3,0),cmplx(2,-1),cmplx(2,1),cmplx(1,0)/),(/2,2/))
  call characterize(a(:2,:2))
  call characterize(cmplx(reshape((/1,0,1,1,1,0,0,1,1/),(/3,3/)),0))
  a(3,:) = (/cmplx(0,0), cmplx(0,0), cmplx(0,1)/)*sqrt(2.0)
  a(2,:) = (/cmplx(0,-1),cmplx(0,1),cmplx(0,0)/)
  a(1,:) = (/1,1,0/)
  a = a * sqrt(2.0)/2.0
  call characterize(a)

contains

  subroutine characterize(a)
    complex, dimension(:,:), intent(in) :: a
    integer :: i, j
    do i=1, size(a,1)
       print *,(a(i, j), j=1,size(a,1))
    end do
    print *,'Is Hermitian?  ',HermitianQ(a)
    print *,'Is normal?  ',NormalQ(a)
    print *,'Unitary?  ',UnitaryQ(a)
    print '(/)'
  end subroutine characterize

  function ct(a) result(b) ! return the conjugate transpose of a matrix
    complex, dimension(:,:), intent(in) :: a
    complex, dimension(size(a,1),size(a,1)) :: b
    b = conjg(transpose(a))
  end function ct

  function identity(n) result(b) ! return identity matrix
    integer, intent(in) :: n
    real, dimension(n,n) :: b
    integer :: i
    b = 0
    do i=1, n
       b(i,i) = 1
    end do
  end function identity

  logical function HermitianQ(a)
    complex, dimension(:,:), intent(in) :: a
    HermitianQ = all(a .eq. ct(a))
  end function HermitianQ

  logical function NormalQ(a)
    complex, dimension(:,:), intent(in) :: a
    NormalQ = all(matmul(ct(a),a) .eq. matmul(a,ct(a)))
  end function NormalQ

  logical function UnitaryQ(a)
    ! if  A inverse equals A star
    ! then multiplying each side by A should result in the identity matrix
    ! Thus show that  A times A star  is sufficiently close to  I .
    complex, dimension(:,:), intent(in) :: a
    UnitaryQ = all(abs(matmul(a,ct(a)) - identity(size(a,1))) .lt. 1e-6)
  end function UnitaryQ

end program conjugate_transpose
