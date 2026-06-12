program dft_verification
  !! Direct (O(N²)) implementation of the Discrete Fourier Transform
  !! and its inverse, with verification on the sequence [2, 3, 5, 7, 11].
  !!
  !! The implementation follows the exact mathematical definition:
  !!   Forward:  Z_k = S x_n · exp(-i·2p·k·n/N)
  !!   Inverse:  x_n = (1/N) · S Z_k · exp(+i·2p·k·n/N)
  !!
  !!
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none

  real(dp), parameter :: pi = acos(-1.0_dp)
  real(dp), parameter :: tol = 1e-10_dp          ! tolerance for cleaning

  integer, parameter  :: N = 5
  complex(dp)         :: x(0:N-1), Z(0:N-1), reconstructed(0:N-1)

  integer :: k

  ! Test sequence (real-valued integers)
  x = cmplx( [2.0_dp, 3.0_dp, 5.0_dp, 7.0_dp, 11.0_dp], 0.0_dp, kind=dp )

  ! Forward DFT
  call discrete_fourier_transform(x, Z, forward=.true.)

  print '(a)', "Forward DFT:"
  do k = 0, N-1
     print '(a,i1,a,f12.6,a,f12.6,a)', "Z(",k,") = ", real(Z(k)), " + ", aimag(Z(k)), "i"
  end do
  print *

  ! Inverse DFT
  call discrete_fourier_transform(Z, reconstructed, forward=.false.)

  ! Clean floating-point noise (small imaginary parts ? 0, round real part if very close to integer)
  call clean_small_errors(reconstructed)

  print '(a)', "Reconstructed sequence after inverse DFT + cleaning:"
  do k = 0, N-1
     print '(f12.1)', real(reconstructed(k))
  end do

contains

  subroutine discrete_fourier_transform(input, output, forward)
    !! Naive O(N²) DFT. Works for any N.
    !! forward = .true.  ? normal DFT  (negative exponent)
    !! forward = .false. ? inverse DFT (positive exponent + division by N)
    complex(dp), intent(in)  :: input(0:)
    complex(dp), intent(out) :: output(0:)
    logical,     intent(in)  :: forward

    integer  :: n, k, nn
    real(dp) :: angle, sgn
    complex(dp) :: omega

    nn = size(input)
    if (size(output) /= nn) stop "Size mismatch in DFT"

    output = (0.0_dp, 0.0_dp)
    sgn = merge(-1.0_dp, +1.0_dp, forward)

    do concurrent(k = 0:nn-1)
       do n = 0,nn-1
          angle = sgn * 2.0_dp * pi * real(k*n,dp) / real(nn,dp)
          omega = exp(cmplx(0.0_dp, angle, dp))           ! e^(±i·?)
          output(k) = output(k) + input(n) * omega
       end do
       if (.not. forward) output(k) = output(k) / real(nn, dp)
    end do
  end subroutine discrete_fourier_transform


  subroutine clean_small_errors(z)
    !! Optional cleaning step:
    !!  • Sets imaginary parts smaller than tol to exactly zero
    !!  • If the number is real (imag ˜ 0) and real part is very close to an integer,
    !!    rounds it to that integer (useful for integer test sequences)
    complex(dp), intent(inout) :: z(:)
    integer :: i
    real(dp) :: re

    do i = lbound(z,1), ubound(z,1)
       re = real(z(i))
       if (abs(aimag(z(i))) < tol)then
           z(i) = cmplx(real(z(i)),0.0_dp)
           endif
       if (abs(re - nint(re)) < tol) then
          z(i) = cmplx(nint(re), 0.0_dp, dp)
       end if
       if (abs(re) < tol) re = 0.0_dp
    end do
  end subroutine clean_small_errors

end program dft_verification
