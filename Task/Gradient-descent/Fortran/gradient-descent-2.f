! =============================================================================
! gradient.f90  --  Gradient Descent (Steepest Descent) Optimisation
! =============================================================================
!
! Minimises the bivariate function
!
!   f(x,y) = (x-1)^2 * exp(-y^2)  +  y*(y+2) * exp(-2*x^2)
!
! starting from (x, y) = (0.1, -1.0) using gradient descent with a
! backtracking (Armijo) line search to choose a safe step size at each
! iteration.
!
! ALGORITHM  (steepest descent)
! ---------------------------------
! Repeat until ||gradient|| < tolerance:
!   1. Evaluate  g = (df/dx, df/dy)  at the current point (x, y).
!   2. Backtracking line search: start with alpha = 1.  Halve alpha until
!      the Armijo sufficient-decrease condition is satisfied:
!
!         f(x - alpha*g) <= f(x) - c * alpha * ||g||^2
!
!      where c = 1e-4.  This guarantees actual progress every step.
!   3. Update: (x, y) <- (x - alpha*gx, y - alpha*gy).
!
! ANALYTICAL GRADIENTS
! --------------------
! Let  A = exp(-y^2),  B = exp(-2*x^2).  Then:
!
!   df/dx = 2*(x-1)*A  -  4*x*y*(y+2)*B
!   df/dy = -2*y*(x-1)^2*A  +  2*(y+1)*B
!
! ANALYTICAL HESSIAN  (used to verify the result is a true minimum)
! -----------------------------------------------------------------
!   d^2f/dx^2  =  2*A  +  (16*x^2 - 4)*y*(y+2)*B
!   d^2f/dy^2  =  (x-1)^2*(4*y^2 - 2)*A  +  2*B
!   d^2f/dxdy  = -4*y*(x-1)*A  -  8*x*(y+1)*B
!
! The Hessian is positive definite (det > 0 and H_xx > 0) at a local
! minimum, negative definite at a local maximum, and indefinite at a
! saddle point.
! =============================================================================
program gradient_descent
  use iso_fortran_env, only: real64
  implicit none

  ! --------------------------------------------------------------------------
  ! Algorithm parameters
  ! --------------------------------------------------------------------------
  real(kind=real64), parameter :: GRAD_TOL  = 1.0e-9_real64   ! ||grad|| < TOL => converged
  real(kind=real64), parameter :: STEP_INIT = 1.0_real64      ! initial trial step size alpha
  real(kind=real64), parameter :: ARMIJO_C  = 1.0e-4_real64   ! Armijo constant c (0 < c < 0.5)
  real(kind=real64), parameter :: SHRINK    = 0.5_real64      ! backtracking reduction factor
  real(kind=real64), parameter :: STEP_MIN  = 1.0e-20_real64  ! give up if alpha falls below this
  integer,           parameter :: MAX_ITER  = 1000000         ! hard iteration cap
  integer,           parameter :: PRINT_INT = 500             ! print every PRINT_INT iterations

  ! --------------------------------------------------------------------------
  ! Working variables
  ! --------------------------------------------------------------------------
  real(kind=real64) :: x, y      ! current point
  real(kind=real64) :: gx, gy    ! gradient: (df/dx, df/dy)
  real(kind=real64) :: gnorm     ! Euclidean norm of the gradient
  real(kind=real64) :: f0        ! f at current point (before step)
  real(kind=real64) :: step      ! current backtracking step size alpha
  real(kind=real64) :: xn, yn   ! trial next point
  real(kind=real64) :: fn        ! f at trial next point
  integer           :: iter      ! iteration counter
  logical           :: stalled   ! true when line search cannot make progress

  ! --------------------------------------------------------------------------
  ! Starting point (given in the task)
  ! --------------------------------------------------------------------------
  x = 0.1_real64
  y = -1.0_real64

  write(*, '(a)') '================================================================'
  write(*, '(a)') ' Gradient Descent (Steepest Descent) Optimisation'
  write(*, '(a)') '================================================================'
  write(*, '(a)') ' Function:'
  write(*, '(a)') '   f(x,y) = (x-1)^2 * exp(-y^2)'
  write(*, '(a)') '          + y*(y+2)  * exp(-2*x^2)'
  write(*, *)
  write(*, '(a,f8.4,a,f8.4,a)') ' Starting point:  (x, y) = (', x, ',', y, ')'
  write(*, '(a,g18.10)')         ' f at start     = ', f(x, y)
  write(*, *)
  write(*, '(a)') ' Armijo c        = 1e-4'
  write(*, '(a)') ' Initial alpha   = 1.0   (halved each backtrack step)'
  write(*, '(a,g10.3)') ' Convergence:  ||grad|| < ', GRAD_TOL
  write(*, *)
  write(*, '(a)') '  iter        x             y          f(x,y)        |grad|'
  write(*, '(a)') ' ------  ----------    ----------   -----------   ----------'

  ! ==========================================================================
  ! Main gradient descent loop
  ! ==========================================================================
  do iter = 1, MAX_ITER

    ! Evaluate function and gradient at current point.
    f0    = f(x, y)
    gx    = df_dx(x, y)
    gy    = df_dy(x, y)
    gnorm = sqrt(gx*gx + gy*gy)

    ! Print the first few iterations and then every PRINT_INT steps.
    if (iter <= 5 .or. mod(iter, PRINT_INT) == 0) then
      write(*, '(i7,2f14.8,2e14.5)') iter, x, y, f0, gnorm
    end if

    ! Convergence check: stop when the gradient is essentially zero.
    if (gnorm < GRAD_TOL) exit

    ! ------------------------------------------------------------------
    ! Backtracking line search.
    ! Start with alpha = STEP_INIT and halve until the Armijo condition:
    !   f(x - alpha*g) <= f(x) - c * alpha * ||g||^2
    ! is satisfied.  The right-hand side is a linear model with a small
    ! fraction c of the expected decrease; any reasonable step satisfies
    ! this for small enough alpha.
    ! ------------------------------------------------------------------
    stalled = .false.
    step    = STEP_INIT
    do
      xn = x - step * gx
      yn = y - step * gy
      fn = f(xn, yn)

      ! Armijo condition satisfied: accept this step.
      if (fn <= f0 - ARMIJO_C * step * gnorm * gnorm) exit

      step = step * SHRINK

      ! If alpha has shrunk to the point where floating-point arithmetic
      ! can no longer represent a distinct new point, the algorithm has
      ! stalled at machine precision.  Accept the current point as the
      ! answer rather than looping forever.
      if (step < STEP_MIN) then
        stalled = .true.
        exit
      end if
    end do

    ! Take the step.
    x = xn
    y = yn

    ! Exit the outer loop if the line search stalled -- the gradient is
    ! already tiny (close to GRAD_TOL) and no further progress is possible.
    if (stalled) exit

  end do   ! end of gradient descent loop

  ! ==========================================================================
  ! Report results
  ! ==========================================================================
  write(*, '(a)') ' ------  ----------    ----------   -----------   ----------'
  write(*, *)

  ! Recompute gradient at the final point for the summary.
  gx    = df_dx(x, y)
  gy    = df_dy(x, y)
  gnorm = sqrt(gx*gx + gy*gy)

  if (gnorm < GRAD_TOL) then
    write(*, '(a,i0,a)') ' Converged after ', iter - 1, ' iterations  (gradient tolerance).'
  else if (stalled) then
    write(*, '(a,i0,a)') ' Converged after ', iter, ' iterations  (line search stalled at machine precision).'
  else
    write(*, '(a,i0,a)') ' Reached iteration limit (', MAX_ITER, ').'
  end if

  write(*, *)
  write(*, '(a)') ' Minimum found:'
  write(*, '(a,g22.15)') '   x      = ', x
  write(*, '(a,g22.15)') '   y      = ', y
  write(*, '(a,g22.15)') '   f(x,y) = ', f(x, y)
  write(*, '(a,g22.15)') '   |grad| = ', gnorm
  write(*, *)

  ! Verify this is a genuine local minimum by inspecting the Hessian.
  call verify_minimum(x, y)

contains

  ! ==========================================================================
  ! f(x,y) -- the objective function
  ! ==========================================================================
  pure function f(x, y) result(val)
    real(kind=real64), intent(in) :: x, y
    real(kind=real64) :: val
    val = (x - 1.0_real64)**2 * exp(-y*y) &
        + y * (y + 2.0_real64) * exp(-2.0_real64*x*x)
  end function f

  ! ==========================================================================
  ! df_dx -- partial derivative of f with respect to x
  !
  ! d/dx [(x-1)^2 exp(-y^2)] = 2(x-1) exp(-y^2)
  ! d/dx [y(y+2) exp(-2x^2)] = y(y+2) * (-4x) exp(-2x^2)
  ! ==========================================================================
  pure function df_dx(x, y) result(g)
    real(kind=real64), intent(in) :: x, y
    real(kind=real64) :: g
    g = 2.0_real64 * (x - 1.0_real64) * exp(-y*y) &
      - 4.0_real64 * x * y * (y + 2.0_real64) * exp(-2.0_real64*x*x)
  end function df_dx

  ! ==========================================================================
  ! df_dy -- partial derivative of f with respect to y
  !
  ! d/dy [(x-1)^2 exp(-y^2)] = (x-1)^2 * (-2y) * exp(-y^2)
  ! d/dy [y(y+2) exp(-2x^2)] = (2y+2) * exp(-2x^2) = 2(y+1) exp(-2x^2)
  ! ==========================================================================
  pure function df_dy(x, y) result(g)
    real(kind=real64), intent(in) :: x, y
    real(kind=real64) :: g
    g = -2.0_real64 * y * (x - 1.0_real64)**2 * exp(-y*y) &
      +  2.0_real64 * (y + 1.0_real64) * exp(-2.0_real64*x*x)
  end function df_dy

  ! ==========================================================================
  ! verify_minimum -- compute the Hessian and check positive definiteness.
  !
  ! A symmetric 2x2 matrix H is positive definite iff:
  !   H_xx > 0   AND   det(H) = H_xx*H_yy - H_xy^2 > 0
  ! This confirms a local minimum (negative definite => local max,
  ! indefinite => saddle point).
  ! ==========================================================================
  subroutine verify_minimum(x, y)
    real(kind=real64), intent(in) :: x, y
    real(kind=real64) :: A, B       ! exponential factors for brevity
    real(kind=real64) :: fxx, fyy, fxy, det

    A = exp(-y*y)
    B = exp(-2.0_real64*x*x)

    ! d^2f/dx^2 = 2*A + (16*x^2 - 4)*y*(y+2)*B
    fxx = 2.0_real64 * A &
        + (16.0_real64*x*x - 4.0_real64) * y * (y + 2.0_real64) * B

    ! d^2f/dy^2 = (x-1)^2*(4*y^2 - 2)*A + 2*B
    fyy = (x - 1.0_real64)**2 * (4.0_real64*y*y - 2.0_real64) * A &
        + 2.0_real64 * B

    ! d^2f/dxdy = -4*y*(x-1)*A - 8*x*(y+1)*B
    fxy = -4.0_real64 * y * (x - 1.0_real64) * A &
        -  8.0_real64 * x * (y + 1.0_real64) * B

    det = fxx * fyy - fxy * fxy

    write(*, '(a)') ' Hessian matrix at the found point:'
    write(*, '(a,g14.6,a,g14.6,a)') '   H = [ ', fxx, '   ', fxy, ' ]'
    write(*, '(a,g14.6,a,g14.6,a)') '       [ ', fxy, '   ', fyy, ' ]'
    write(*, *)
    write(*, '(a,g16.8)') '   det(H) = H_xx*H_yy - H_xy^2 = ', det
    write(*, '(a,g16.8)') '   H_xx   = ', fxx
    write(*, *)

    if (det > 0.0_real64 .and. fxx > 0.0_real64) then
      write(*, '(a)') ' Hessian is positive definite => confirmed LOCAL MINIMUM.'
    else if (det < 0.0_real64) then
      write(*, '(a)') ' Hessian is indefinite => SADDLE POINT (not a minimum).'
    else
      write(*, '(a)') ' Hessian is semidefinite or negative definite.'
    end if
  end subroutine verify_minimum

  ! ==========================================================================
  ! init_rng  (not needed here but included for project consistency)
  ! ==========================================================================

end program gradient_descent

