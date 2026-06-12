! =============================================================================
! CORDIC COSINE -- Coordinate Rotation Digital Computer
! =============================================================================
!
! OVERVIEW OF THE ALGORITHM:
!   CORDIC computes cos and sin by rotating a unit vector down to zero angle
!   through a sequence of "micro-rotations".  Each micro-rotation has a step
!   angle of arctan(2^(-i)), chosen specifically so that the sine/cosine of
!   that angle requires only addition and a power-of-two scale (a bit shift).
!
! THE ROTATION EQUATIONS AT STEP i:
!   d_i   = +1  if residual angle theta >= 0  (rotate counter-clockwise)
!           -1  otherwise                      (rotate clockwise)
!
!   x' = x - d_i * 2^(-i) * y        <-- only + or - and a right shift
!   y' = y + d_i * 2^(-i) * x        <-- only + or - and a right shift
!   z' = z - d_i * arctan(2^(-i))    <-- subtract pre-tabulated angle
!
!   After n steps, z -> 0 and the vector (x,y) -> (cos(theta0), sin(theta0)).
!
! THE GAIN PROBLEM:
!   Each micro-rotation stretches the vector by sqrt(1 + 2^(-2i)) rather than
!   rotating it cleanly.  Over n steps the total gain is:
!       K = product_{i=0}^{n-1} sqrt(1 + 2^(-2i))
!   K converges to about 1.6468.  We compensate by pre-loading x = 1/K
!   instead of x = 1, so the gain cancels by the final step.
!
! CONVERGENCE RANGE:
!   CORDIC converges for |theta| <= sum_{i=0}^{inf} arctan(2^(-i)) ~ 1.7433
!   which comfortably covers [-pi/2, pi/2].  Angles outside this range are
!   reduced using cos(theta - pi) = -cos(theta) before entering the loop.
! =============================================================================

program cordic
    use iso_fortran_env, only: real64
    implicit none

    ! 56 iterations gives full real64 (53-bit mantissa) accuracy; beyond this
    ! rounding noise dominates and extra iterations add nothing.
    integer, parameter :: n_iter = 56

    real(kind=real64), parameter :: pi = 3.14159265358979323846_real64

    ! atan_table(i) = arctan(2^(-i)), pre-computed once and reused each call
    real(kind=real64) :: atan_table(0:n_iter-1)

    ! CORDIC gain compensation: start x at 1/K so accumulated stretch cancels
    real(kind=real64) :: inv_gain

    real(kind=real64) :: test_angles(4)
    integer :: i

    ! --- build lookup table and inverse gain before any cosine calls ---
    call build_tables(atan_table, inv_gain, n_iter)

    test_angles = [-9.0_real64, 0.0_real64, 1.5_real64, 6.0_real64]

    write(*, '(A)') 'CORDIC cosine (56 iterations) vs Fortran intrinsic:'
    write(*, '(A)') '------------------------------------------------------------'
    write(*, '(A6, A22, A22)') 'angle', 'CORDIC cos', 'intrinsic cos'
    write(*, '(A6, A22, A22)') '-----', '----------', '-------------'
    do i = 1, 4
        write(*, '(F6.1, F22.16, F22.16)') &
            test_angles(i),                                               &
            cordic_cos(test_angles(i), atan_table, inv_gain, n_iter),    &
            cos(test_angles(i))
    end do

contains

    ! -------------------------------------------------------------------------
    ! BUILD_TABLES
    !   Fills the arctan lookup table and computes the inverse CORDIC gain.
    !   Called once; results are reused for every angle.
    !
    !   tbl(i)  = arctan(2^(-i))         -- angle stepped at iteration i
    !   inv_k   = 1 / product sqrt(1 + 2^(-2i))  -- gain correction factor
    ! -------------------------------------------------------------------------
    subroutine build_tables(tbl, inv_k, n)
        real(kind=real64), intent(out) :: tbl(0:n-1)
        real(kind=real64), intent(out) :: inv_k
        integer,           intent(in)  :: n

        real(kind=real64) :: pow2   ! current power of two: 2^(-i)
        real(kind=real64) :: gain   ! accumulated product of stretch factors
        integer :: i

        pow2 = 1.0_real64    ! start at 2^0; halved each iteration
        gain = 1.0_real64

        do i = 0, n-1
            tbl(i) = atan(pow2)                            ! arctan(2^(-i))
            gain   = gain * sqrt(1.0_real64 + pow2 * pow2) ! accumulate K
            pow2   = pow2 * 0.5_real64                     ! right shift to 2^(-i-1)
        end do

        inv_k = 1.0_real64 / gain   ! ~ 0.60725293500888
    end subroutine build_tables

    ! -------------------------------------------------------------------------
    ! CORDIC_COS
    !   Returns cos(angle) for any angle in radians via CORDIC rotation mode.
    !
    !   The main loop body uses only: +, -, multiply by a power of 2 (shift),
    !   and a table lookup -- no general multiplications.
    ! -------------------------------------------------------------------------
    function cordic_cos(angle, tbl, inv_k, n) result(c)
        real(kind=real64), intent(in) :: angle
        real(kind=real64), intent(in) :: tbl(0:n-1)
        real(kind=real64), intent(in) :: inv_k
        integer,           intent(in) :: n
        real(kind=real64) :: c

        real(kind=real64) :: theta   ! residual angle being driven toward zero
        real(kind=real64) :: x, y   ! rotating vector, starts at (inv_k, 0)
        real(kind=real64) :: x_new  ! temporary x before y is overwritten
        real(kind=real64) :: pow2   ! step magnitude = 2^(-i), right-shifted each step
        integer :: i, flip

        ! --- Step 1: wrap angle into [-pi, pi] ---
        ! floor((angle + pi) / (2*pi)) is the nearest lower integer multiple
        ! of 2*pi, so subtracting it leaves the residual in (-pi, pi].
        theta = angle - 2.0_real64 * pi * floor((angle + pi) / (2.0_real64 * pi))

        ! --- Step 2: reduce to [-pi/2, pi/2] using cosine symmetry ---
        ! cos is defined on all reals but CORDIC converges only near zero.
        ! cos(theta) = -cos(theta - pi)  for theta in (pi/2,  pi]
        ! cos(theta) = -cos(theta + pi)  for theta in [-pi, -pi/2)
        flip = 1
        if (theta > pi * 0.5_real64) then
            theta = theta - pi
            flip  = -1
        else if (theta < -pi * 0.5_real64) then
            theta = theta + pi
            flip  = -1
        end if

        ! --- Step 3: CORDIC rotation loop ---
        ! Start vector at (inv_k, 0).  The loop drives theta toward zero by
        ! adding or subtracting micro-rotation angles arctan(2^(-i)).
        ! When theta reaches zero the vector has rotated by the original angle
        ! and the gain K has been pre-cancelled by inv_k, so x = cos(theta0).
        x    = inv_k
        y    = 0.0_real64
        pow2 = 1.0_real64   ! 2^(-i): starts at 1, halved after each step

        do i = 0, n-1

            if (theta >= 0.0_real64) then
                ! Rotate counter-clockwise (d_i = +1):
                !   x' = x - 2^(-i) * y
                !   y' = y + 2^(-i) * x
                !   z' = z - arctan(2^(-i))
                x_new = x - pow2 * y
                y     = y + pow2 * x
                theta = theta - tbl(i)
            else
                ! Rotate clockwise (d_i = -1):
                !   x' = x + 2^(-i) * y
                !   y' = y - 2^(-i) * x
                !   z' = z + arctan(2^(-i))
                x_new = x + pow2 * y
                y     = y - pow2 * x
                theta = theta + tbl(i)
            end if

            x    = x_new
            pow2 = pow2 * 0.5_real64   ! right shift: 2^(-i) -> 2^(-(i+1))

        end do

        ! x now holds cos(reduced theta); apply sign flip if we shifted quadrants
        c = real(flip, real64) * x

    end function cordic_cos

end program cordic

