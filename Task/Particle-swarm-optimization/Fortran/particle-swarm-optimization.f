! ==============================================================================
! Particle Swarm Optimization (PSO)
!
! PSO is a population-based metaheuristic that simulates the social behaviour
! of a flock of birds searching for food.  Each candidate solution is called a
! "particle".  Particles move through the search space, attracted both toward
! the best position they have personally visited (cognitive component) and
! toward the best position any particle in the swarm has ever visited (social
! component).  No gradient information is required, so PSO works on
! discontinuous, non-differentiable, or black-box objective functions.
!
! Velocity update equation (applied per dimension j, per particle i):
!
!   v_ij <- omega * v_ij
!          + phi_p * r_p * (p_best_ij - x_ij)   ! pull toward personal best
!          + phi_g * r_g * (g_best_j  - x_ij)   ! pull toward global  best
!
!   x_ij <- x_ij + v_ij                          ! move particle
!
! where:
!   omega   - inertia weight: fraction of old velocity carried forward.
!             High omega encourages global exploration; low omega (or zero)
!             makes particles brake quickly and exploit known good regions.
!   phi_p   - cognitive coefficient: weight of the personal-best attraction.
!   phi_g   - social    coefficient: weight of the global-best  attraction.
!   r_p, r_g - independent uniform random scalars in [0,1], redrawn each step.
!
! Compile: gfortran -O2 -o pso pso.f90
! ==============================================================================

module pso_module
    use iso_fortran_env, only: real64
    implicit none

    ! --------------------------------------------------------------------------
    ! Abstract interface that every objective function must satisfy.
    ! x   - position vector of length n (the point being evaluated)
    ! n   - number of dimensions
    ! f   - scalar objective value; PSO minimises this quantity
    !
    ! Declaring the interface here lets the compiler type-check any function
    ! passed to the pso() subroutine at compile time rather than silently
    ! accepting a mismatched argument.
    ! --------------------------------------------------------------------------
    abstract interface
        function obj_func_t(x, n) result(f)
            import :: real64
            integer,           intent(in) :: n
            real(kind=real64), intent(in) :: x(n)
            real(kind=real64) :: f
        end function obj_func_t
    end interface

contains

    ! ==========================================================================
    ! subroutine pso
    !
    ! Runs the Particle Swarm Optimization algorithm and returns the best
    ! position and value found.
    !
    ! Arguments:
    !   n_dim       - number of search-space dimensions
    !   n_particles - swarm size (more particles = broader initial coverage)
    !   n_iter      - number of full swarm update cycles (iterations)
    !   omega       - inertia weight (see header notes)
    !   phi_p       - cognitive coefficient (personal-best attraction strength)
    !   phi_g       - social    coefficient (global-best  attraction strength)
    !   lb(n_dim)   - lower bounds for each dimension
    !   ub(n_dim)   - upper bounds for each dimension
    !   obj_func    - the objective function to minimise (procedure argument)
    !   best_pos    - (out) position of the global best found
    !   best_val    - (out) objective value at best_pos
    ! ==========================================================================
    subroutine pso(n_dim, n_particles, n_iter, omega, phi_p, phi_g, &
                   lb, ub, obj_func, best_pos, best_val)

        integer,           intent(in)  :: n_dim, n_particles, n_iter
        real(kind=real64), intent(in)  :: omega, phi_p, phi_g
        real(kind=real64), intent(in)  :: lb(n_dim), ub(n_dim)
        real(kind=real64), intent(out) :: best_pos(n_dim), best_val
        procedure(obj_func_t)          :: obj_func

        ! pos(i,j)       - current position of particle i in dimension j
        ! vel(i,j)       - current velocity of particle i in dimension j
        ! p_best_pos(i,j)- best position particle i has ever personally visited
        ! p_best_val(i)  - objective value at p_best_pos(i,:)
        ! g_best_pos(j)  - best position any particle has ever visited (global)
        ! g_best_val     - objective value at g_best_pos
        real(kind=real64), allocatable :: pos(:,:), vel(:,:)
        real(kind=real64), allocatable :: p_best_pos(:,:), p_best_val(:)
        real(kind=real64) :: g_best_pos(n_dim), g_best_val

        real(kind=real64) :: r_p     ! random scalar for personal-best term
        real(kind=real64) :: r_g     ! random scalar for global-best  term
        real(kind=real64) :: fval    ! objective value of current position
        real(kind=real64) :: v_max   ! per-dimension velocity clamp magnitude
        integer :: i, j, k          ! particle index, dimension index, iteration

        ! Heap-allocate swarm arrays so large swarms do not overflow the stack.
        allocate(pos(n_particles, n_dim))
        allocate(vel(n_particles, n_dim))
        allocate(p_best_pos(n_particles, n_dim))
        allocate(p_best_val(n_particles))

        ! Seed the RNG.  Calling random_seed() with no argument lets the runtime
        ! choose a seed (often from the system clock), giving a different sequence
        ! each run.  Replace with random_seed(put=...) for reproducibility.
        call random_seed()

        ! ----------------------------------------------------------------------
        ! Phase 1: Initialisation
        ! Scatter particles uniformly at random within [lb, ub].
        ! Assign each particle a small random initial velocity (+/-10% of the
        ! dimension range) so they are not immediately stationary.
        ! Evaluate the objective at each starting position and record it as the
        ! particle's personal best (since it is the only position seen so far).
        ! ----------------------------------------------------------------------
        do i = 1, n_particles
            do j = 1, n_dim
                ! Uniform random position: lb + U[0,1] * (ub - lb)
                call random_number(r_p)
                pos(i, j) = lb(j) + r_p * (ub(j) - lb(j))

                ! Small random initial velocity centred on zero: U[-0.1, 0.1]*range
                ! r_p is in [0,1], so (r_p - 0.5) is in [-0.5, 0.5];
                ! multiplying by 0.2 gives [-0.1, 0.1] of the dimension range.
                call random_number(r_p)
                vel(i, j) = (ub(j) - lb(j)) * (r_p - 0.5_real64) * 0.2_real64
            end do

            ! The initial position is trivially the personal best.
            p_best_pos(i, :) = pos(i, :)
            p_best_val(i)    = obj_func(pos(i, :), n_dim)
        end do

        ! ----------------------------------------------------------------------
        ! Phase 2: Identify the initial global best across the whole swarm.
        ! Start from particle 1, then scan the rest for anything better.
        ! ----------------------------------------------------------------------
        g_best_val = p_best_val(1)
        g_best_pos = p_best_pos(1, :)
        do i = 2, n_particles
            if (p_best_val(i) < g_best_val) then
                g_best_val = p_best_val(i)
                g_best_pos = p_best_pos(i, :)
            end if
        end do

        ! ----------------------------------------------------------------------
        ! Phase 3: Main PSO iteration loop
        !
        ! Each iteration: for every particle in every dimension,
        !   (a) draw fresh random scalars r_p and r_g,
        !   (b) update velocity using the standard PSO formula,
        !   (c) clamp velocity so particles cannot travel more than v_max per
        !       step -- without this, particles with zero inertia (omega=0) can
        !       receive arbitrarily large kicks from phi_p and phi_g and overshoot
        !       the entire search space,
        !   (d) advance position and clip it to [lb, ub] if it strays out,
        !   (e) evaluate the objective at the new position,
        !   (f) update personal best and, if better still, global best.
        ! ----------------------------------------------------------------------
        do k = 1, n_iter
            do i = 1, n_particles
                do j = 1, n_dim

                    ! Fresh independent random scalars for this particle-dimension-
                    ! iteration triplet.  Using separate r_p and r_g breaks any
                    ! correlation between the cognitive and social pulls.
                    call random_number(r_p)
                    call random_number(r_g)

                    ! Velocity update: inertia + cognitive pull + social pull
                    vel(i, j) = omega * vel(i, j) &
                              + phi_p * r_p * (p_best_pos(i, j) - pos(i, j)) &
                              + phi_g * r_g * (g_best_pos(j)    - pos(i, j))

                    ! Velocity clamping: limit to +/- 20% of the dimension range.
                    ! This prevents "velocity explosion" -- a failure mode where
                    ! particles rocket out of the search space and never return,
                    ! especially common when omega=0 removes damping.
                    v_max = 0.2_real64 * (ub(j) - lb(j))
                    vel(i, j) = max(-v_max, min(v_max, vel(i, j)))

                    ! Advance position by the new velocity.
                    pos(i, j) = pos(i, j) + vel(i, j)

                    ! Hard boundary enforcement: if the particle crosses a bound,
                    ! clamp it to the boundary edge.  The velocity is not reversed
                    ! here; it will be redirected by the attraction terms on the
                    ! next iteration once the particle is stuck on the wall.
                    pos(i, j) = max(lb(j), min(ub(j), pos(i, j)))

                end do   ! end dimension loop

                ! Evaluate the objective at the updated position.
                fval = obj_func(pos(i, :), n_dim)

                ! Update personal best if this position is an improvement.
                if (fval < p_best_val(i)) then
                    p_best_val(i)    = fval
                    p_best_pos(i, :) = pos(i, :)

                    ! A new personal best can only improve the global best,
                    ! so check here rather than in a separate sweep.
                    if (fval < g_best_val) then
                        g_best_val = fval
                        g_best_pos = pos(i, :)
                    end if
                end if

            end do   ! end particle loop
        end do       ! end iteration loop

        ! Return the global best found to the caller.
        best_pos = g_best_pos
        best_val = g_best_val

        deallocate(pos, vel, p_best_pos, p_best_val)
    end subroutine pso

end module pso_module


! ==============================================================================
! Standard benchmark objective functions used to exercise the PSO solver.
! Both conform to obj_func_t so they can be passed directly to pso().
! ==============================================================================
module test_functions
    use iso_fortran_env, only: real64
    implicit none

    ! pi is needed by Michalewicz; compute at compile time via acos identity.
    real(kind=real64), parameter :: pi = acos(-1.0_real64)

contains

    ! --------------------------------------------------------------------------
    ! McCormick function  (2-dimensional)
    !
    !   f(x1, x2) = sin(x1 + x2) + (x1 - x2)^2 - 1.5*x1 + 2.5*x2 + 1
    !
    ! The surface is bowl-shaped with a single global minimum and no
    ! significant local minima, making it a useful sanity-check: a correctly
    ! implemented PSO should always find it.
    !
    ! Recommended search bounds: -1.5 <= x1 <= 4,  -3 <= x2 <= 4
    ! Global minimum:  f(-0.54719, -1.54719) = -1.9133285
    ! --------------------------------------------------------------------------
    function mccormick(x, n) result(f)
        integer,           intent(in) :: n
        real(kind=real64), intent(in) :: x(n)
        real(kind=real64) :: f

        ! sin(x1+x2) gives the undulating ridge character of the surface.
        ! (x1-x2)^2 forms a parabolic valley running diagonally.
        ! The linear terms -1.5*x1 + 2.5*x2 tilt the surface and shift
        ! the minimum away from the origin.
        f = sin(x(1) + x(2)) + (x(1) - x(2))**2 &
            - 1.5_real64*x(1) + 2.5_real64*x(2) + 1.0_real64
    end function mccormick


    ! --------------------------------------------------------------------------
    ! Michalewicz function  (n-dimensional, parameter m controls steepness)
    !
    !   f(x) = -sum_{i=1}^{n}  sin(xi) * [ sin(i * xi^2 / pi) ]^(2*m)
    !
    ! m=10 (used here) produces extremely steep ridges and deep, narrow
    ! valleys.  The function has n! local minima, of which n are deep enough
    ! to trap a naive optimizer, making it a demanding multimodal test case.
    !
    ! Recommended search bounds: 0 <= xi <= pi for each dimension.
    !
    ! 2-D global minimum:  f(2.2029, 1.5708) approx -1.8013
    !   x2 = pi/2 exactly (the peak of sin) -- the ridge is infinitely
    !   thin in the x2 direction when m is large, which is why a large
    !   swarm (1000 particles) is needed to land close enough to it.
    ! --------------------------------------------------------------------------
    function michalewicz(x, n) result(f)
        integer,           intent(in) :: n
        real(kind=real64), intent(in) :: x(n)
        real(kind=real64) :: f

        integer :: i
        integer, parameter :: m = 10   ! steepness parameter; higher = sharper ridges

        f = 0.0_real64
        do i = 1, n
            ! Each term is negative (subtracted from zero) so the function is
            ! minimised where the absolute value of the sum is maximised.
            ! sin(xi) peaks at xi = pi/2; the power term (2*m=20) sharpens the
            ! valley around each i-dependent xi* location so that almost all the
            ! function value is concentrated in a tiny neighbourhood of xi*.
            f = f - sin(x(i)) * (sin(real(i, real64) * x(i)**2 / pi))**(2*m)
        end do
    end function michalewicz

end module test_functions


! ==============================================================================
! Main program: run the two benchmark tests and report results.
! ==============================================================================
program particle_swarm
    use iso_fortran_env, only: real64
    use pso_module
    use test_functions
    implicit none

    real(kind=real64) :: best_pos(2)  ! 2-D position of the optimum found
    real(kind=real64) :: best_val     ! objective value at best_pos
    real(kind=real64) :: lb(2), ub(2) ! search-space bounds for each test

    print *, '================================================'
    print *, ' Particle Swarm Optimization'
    print *, '================================================'
    print *

    ! ==========================================================================
    ! Test 1: McCormick function
    !
    ! omega = 0 means particles carry NO inertia from the previous step: each
    ! velocity update is purely attraction-based.  This is aggressive exploitation
    ! and works well for a single-basin function like McCormick where there is
    ! no danger of prematurely converging to a local minimum.
    !
    ! phi_p = 0.6 (cognitive) > phi_g = 0.3 (social): particles trust their own
    ! history more than the swarm consensus, keeping them spread across the bowl
    ! until they individually close in on the minimum.
    !
    ! 100 particles over 40 iterations is sufficient for a smooth 2-D landscape.
    ! ==========================================================================
    print *, 'Test 1: McCormick function'
    print *, '  f(x1,x2) = sin(x1+x2) + (x1-x2)^2 - 1.5*x1 + 2.5*x2 + 1'
    print *, '  Bounds:  -1.5 < x1 < 4,  -3 < x2 < 4'
    print *, '  omega=0.0  phi_p=0.6  phi_g=0.3  N=100  iter=40'
    print *

    lb = [-1.5_real64, -3.0_real64]
    ub = [ 4.0_real64,  4.0_real64]
!subroutine pso(n_dim, n_particles, n_iter, omega, phi_p, phi_g, &
!                   lb, ub, obj_func, best_pos, best_val)
    call pso(2, 500, 100, 0.0_real64, 0.6_real64, 0.3_real64, &
             lb, ub, mccormick, best_pos, best_val)

    print '(2x,a,f12.7)', 'Best x1   = ', best_pos(1)
    print '(2x,a,f12.7)', 'Best x2   = ', best_pos(2)
    print '(2x,a,f12.7)', 'Best f(x) = ', best_val
    print *, '  Known minimum: f(-0.54719, -1.54719) = -1.9133285'
    print *

    ! ==========================================================================
    ! Test 2: Michalewicz function
    !
    ! omega = 0.3 retains some inertia, helping particles glide across the
    ! narrow inter-valley ridges rather than stalling on a slope.
    !
    ! phi_p = phi_g = 0.3: balanced cognitive and social terms keep the swarm
    ! from collapsing onto a single discovered valley too quickly, which would
    ! miss the true global minimum hidden in a different (possibly narrower) one.
    !
    ! 1000 particles are needed because the deep valleys at m=10 are so narrow
    ! that with fewer particles most runs fail to place any particle close enough
    ! to the correct valley for it to be discovered.  30 iterations suffice once
    ! the right valley is seeded, since the social pull then rapidly draws the
    ! whole swarm in.
    ! ==========================================================================
    print *, 'Test 2: Michalewicz function (m=10)'
    print *, '  f(x) = -sum_i sin(xi) * [sin(i*xi^2/pi)]^20'
    print *, '  Bounds:  0 < x1 < pi,  0 < x2 < pi'
    print *, '  omega=0.3  phi_p=0.3  phi_g=0.3  N=1000  iter=30'
    print *

    lb = [0.0_real64, 0.0_real64]
    ub = [pi, pi]

    call pso(2, 1000, 30, 0.3_real64, 0.3_real64, 0.3_real64, &
             lb, ub, michalewicz, best_pos, best_val)

    print '(2x,a,f12.7)', 'Best x1   = ', best_pos(1)
    print '(2x,a,f12.7)', 'Best x2   = ', best_pos(2)
    print '(2x,a,f12.7)', 'Best f(x) = ', best_val
    print *, '  Known minimum: f(2.2029, 1.5708) approx -1.8013'
    print *

    print *, '================================================'

end program particle_swarm

