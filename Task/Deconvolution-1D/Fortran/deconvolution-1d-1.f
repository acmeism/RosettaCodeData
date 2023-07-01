! Build
! Windows: ifort /I "%IFORT_COMPILER11%\mkl\include\ia32" deconv1d.f90 "%IFORT_COMPILER11%\mkl\ia32\lib\*.lib"
! Linux:

program deconv
  ! Use gelsd from LAPACK95.
  use mkl95_lapack, only : gelsd

  implicit none
  real(8), allocatable :: g(:), href(:), A(:,:), f(:)
  real(8), pointer     :: h(:), r(:)
  integer              :: N
  character(len=16)    :: cbuff
  integer              :: i
  intrinsic            :: nint

  ! Allocate data arrays
  allocate(g(21),f(16))
  g = [24,75,71,-34,3,22,-45,23,245,25,52,25,-67,-96,96,31,55,36,29,-43,-7]
  f = [-3,-6,-1,8,-6,3,-1,-9,-9,3,-2,5,2,-2,-7,-1]

  ! Calculate deconvolution
  h => deco(f, g)

  ! Check result against reference
  N = size(h)
  allocate(href(N))
  href = [-8,-9,-3,-1,-6,7]
  cbuff = ' '
  write(cbuff,'(a,i0,a)') '(a,',N,'(i0,a),i0)'
  if (any(abs(h-href) > 1.0d-4)) then
     write(*,'(a)') 'deconv(f, g) - FAILED'
  else
     write(*,cbuff) 'deconv(f, g) = ',(nint(h(i)),', ',i=1,N-1),nint(h(N))
  end if

  ! Calculate deconvolution
  r => deco(h, g)

  cbuff = ' '
  N = size(r)
  write(cbuff,'(a,i0,a)') '(a,',N,'(i0,a),i0)'
  if (any(abs(r-f) > 1.0d-4)) then
     write(*,'(a)') 'deconv(h, g) - FAILED'
  else
     write(*,cbuff) 'deconv(h, g) = ',(nint(r(i)),', ',i=1,N-1),nint(r(N))
  end if

contains
  function deco(p, q)
    real(8), pointer    :: deco(:)
    real(8), intent(in) :: p(:), q(:)

    real(8), allocatable, target :: r(:)
    real(8), allocatable         :: A(:,:)
    integer :: N

    ! Construct derived arrays
    N = size(q) - size(p) + 1
    allocate(A(size(q),N),r(size(q)))
    A = 0.0d0
    do i=1,N
       A(i:i+size(p)-1,i) = p
    end do

    ! Invoke the LAPACK routine to do the work
    r = q
    call gelsd(A, r)

    deco => r(1:N)
  end function deco

end program deconv
