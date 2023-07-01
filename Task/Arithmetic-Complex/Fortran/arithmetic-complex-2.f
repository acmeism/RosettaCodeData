program cdemo2
    complex :: a = (5,3), b = (0.5, 6)        ! complex initializer
    real, parameter :: pi = 3.141592653589793 ! The constant "pi"
    complex, parameter :: i = (0, 1)          ! the imaginary unit "i" (sqrt(-1))
    complex :: abdiff, abquot, abpow, aconj, p2cart, newc
    real :: areal, aimag, anorm, rho = 10, theta = pi / 3.0, x = 2.3, y = 3.0
    integer, parameter :: n = 50
    integer :: j
    complex, dimension(0:n-1) :: unit_circle

    abdiff = a - b
    abquot = a / b
    abpow  = a ** b
    areal = real(a)               ! Real part
    aimag = imag(a)               ! Imaginary part. Function imag(a) is possibly not recognised. Use aimag(a) if so.
    newc = cmplx(x,y)             ! Creating a complex on the fly from two reals intrinsically
                                  !   (initializer only works in declarations)
    newc = x + y*i                ! Creating a complex on the fly from two reals arithmetically
    anorm = abs(a)                ! Complex norm (or "modulus" or "absolute value")
                                  !   (use CABS before Fortran 90)
    aconj = conjg(a)              ! Complex conjugate (same as real(a) - i*imag(a))
    p2cart = rho * exp(i * theta) ! Euler's polar complex notation to cartesian complex notation
                                  !   conversion (use CEXP before Fortran 90)

    ! The following creates an array of N evenly spaced points around the complex unit circle
    ! useful for FFT calculations, among other things
    unit_circle = exp(2*i*pi/n * (/ (j, j=0, n-1) /) )
end program cdemo2
