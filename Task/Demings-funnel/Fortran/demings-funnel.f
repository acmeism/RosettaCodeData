!
! Deming's funnel
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
! VSI Fortran V8.6-001 does not/not yet compile this code
! because it cannot initialize variables using intrinsic functions
! U.B., December 2025
!==============================================================================
program DemingsFunnel

implicit none

real, parameter :: dx(*) = &
    [-0.533, 0.27, 0.859, -0.043, -0.205, -0.127, -0.071, 0.275, 1.251,            &
     -0.231, -0.401, 0.269, 0.491, 0.951, 1.15, 0.001, -0.382, 0.161, 0.915,       &
     2.08, -2.337, 0.034, -0.126, 0.014, 0.709, 0.129, -1.093, -0.483, -1.193,     &
     0.02, -0.051, 0.047, -0.095, 0.695, 0.34, -0.182, 0.287, 0.213, -0.423,       &
     -0.021, -0.134, 1.798, 0.021, -1.099, -0.361, 1.636, -1.134, 1.315, 0.201,    &
     0.034, 0.097, -0.17, 0.054, -0.553, -0.024, -0.181, -0.7, -0.361, -0.789,     &
     0.279, -0.174, -0.009, -0.323, -0.658, 0.348, -0.528, 0.881, 0.021, -0.853,   &
     0.157, 0.648, 1.774, -1.043, 0.051, 0.021, 0.247, -0.31, 0.171, 0.0, 0.106,   &
     0.024, -0.386, 0.962, 0.765, -0.125, -0.289, 0.521, 0.017, 0.281, -0.749,     &
     -0.149, -2.436, -0.909, 0.394, -0.113, -0.598, 0.443, -0.521, -0.799,  0.087],&
    dy(*) =                                                                        &
    [0.136, 0.717, 0.459, -0.225, 1.392, 0.385, 0.121, -0.395, 0.49, -0.682,       &
     -0.065, 0.242, -0.288, 0.658, 0.459, 0.0, 0.426, 0.205, -0.765, -2.188,       &
     -0.742, -0.01, 0.089, 0.208, 0.585, 0.633, -0.444, -0.351, -1.087, 0.199,     &
     0.701, 0.096, -0.025, -0.868, 1.051, 0.157, 0.216, 0.162, 0.249, -0.007,      &
     0.009, 0.508, -0.79, 0.723, 0.881, -0.508, 0.393, -0.226, 0.71, 0.038,        &
     -0.217, 0.831, 0.48, 0.407, 0.447, -0.295, 1.126, 0.38, 0.549, -0.445,        &
     -0.046, 0.428, -0.074, 0.217, -0.822, 0.491, 1.347, -0.141, 1.23, -0.044,     &
     0.079, 0.219, 0.698, 0.275, 0.056, 0.031, 0.421, 0.064, 0.721, 0.104,         &
     -0.729, 0.65, -1.103, 0.154, -1.72, 0.051, -0.385, 0.477, 1.537, -0.901,      &
     0.939, -0.411, 0.341, -0.411, 0.106, 0.224, -0.947, -1.424, -0.542, -1.032]


  integer, parameter :: NGenerate = 100             ! number of random pairs to generate

  real :: dyndx (NGenerate), dyndy(NGenerate)

  interface                                         ! describe the 4 Rule functions
    pure function rule1 (z,dz) result (retv)
      real , intent(in) :: z, dz
      real   :: retv
    end function rule1
    pure function rule2 (z,dz) result (retv)
      real , intent(in) :: z, dz
      real   :: retv
    end function rule2
    pure function rule3 (z,dz) result (retv)
      real , intent(in) :: z, dz
      real   :: retv
    end function rule3
    pure function rule4 (z,dz) result (retv)
      real , intent(in) :: z, dz
      real   :: retv
    end function rule4
  end interface


  write ( *, "( 'With test data as in the Racket solution as suggested in the task description:',/)")

  call simulation (dx, dy, size(dx), rule1)
  call simulation (dx, dy, size(dx), rule2)
  call simulation (dx, dy, size(dx), rule3)
  call simulation (dx, dy, size(dx), rule4)


  call random_seed ()                       ! Initialize random number generator
  call fillRandom (dyndx, dyndy, NGenerate)

  write ( *, "( 'With randomly generated displacements:',/)")

  call simulation (dyndx, dyndy, NGenerate, rule1)
  call simulation (dyndx, dyndy, NGenerate, rule2)
  call simulation (dyndx, dyndy, NGenerate, rule3)
  call simulation (dyndx, dyndy, NGenerate, rule4)

end program DemingsFunnel


! ================================================================
! Do the simulation: drop the balls through the funnel and correct
! funnel position according to the applied rule
! ================================================================
subroutine simulation (ddx, ddy, sizddx, rule)

implicit none

real, intent(in) :: ddx(*), ddy(*)
integer, intent(in) :: sizddx
real, external :: stddev

interface                   ! describe the Rule function
  pure function rule (z,dz) result (retv)
    real , intent(in) :: z, dz
    real   :: retv
  end function rule
end interface

real  :: allX (sizddx)      ! Array with x position of impact
real  :: allY (sizddx)      ! ... same, y positions.
real  :: x, y               ! The funnel's position
real  :: rx, ry             ! The actual impact position
real  ::  avx, avy          ! Averaged impact position, calculate it here
real  :: sigmaX, sigmaY     ! The resultant standard deviation of the impact positions
integer :: ii               ! loop index
integer :: ruleno=1         ! Which rule is applied to "improve" the outcome.

print '("Rule ", I0, ":")', ruleno
ruleno = mod(ruleno,4) + 1        ! 1,2,3,4,1,2,3,4..., knowing there are 4 rules only.

x=0   ! Start values
y=0
avx = 0
avy = 0
do ii=1, sizddx
  rx = x + ddx(ii)          ! Impact position is funnel pos + offset
  ry = y + ddy(ii)
  x = rule (x,ddx(ii))      ! New funnel position according to rule 1,2,3, or 4
  y = rule (y,ddy(ii))
  avx = avx + rx            ! Add up impact positions to calculate average
  avy = avy + ry
  allx(ii) = rx             ! Store impact positions to calculate standard deviation
  ally(ii) = ry
end do
avx = avx / sizddx
avy = avy / sizddx

sigmaX = stddev (allx, avx, sizddx)
sigmaY = stddev (ally, avy, sizddx)

write (*,'("Mean x, y:   ", 2F12.4)')  avx, avy
write (*,'("Std dev x, y:", 2F12.4,//)') sigmaX, sigmaY

end subroutine simulation

! The 4 rules how to move the funnel after a shot

pure function rule1 (z,dz) result (retv)       ! funnel always above (0,0)
  real, intent(in) :: z, dz
  real  :: retv
  retv = z                                     ! avoid compiler warning "unused dummy argument"
  retv = dz
  retv = 0
end function rule1

pure function rule2 (z,dz) result (retv)       ! "correct" for last deviation from aim
  real , intent(in) :: z, dz
  real   :: retv
  retv = z                                     ! avoid compiler warning "unused dummy argument"
  retv = -dz
end function rule2

pure function rule3 (z,dz) result (retv)       ! Move funnel back to (0,0), then correct for last dev
  real , intent(in) :: z, dz
  real   :: retv
  retv = -(z+dz)
end function rule3

pure function rule4 (z,dz) result (retv)       ! funnel over last drop
  real , intent(in) :: z, dz
  real   :: retv
  retv = z+dz
end function rule4


! ===================================================================
! Calculate the standard deviation of the values in the array "allz"
! the mean value of these values is allz, and the third argument is
! the size of the array.
! ===================================================================
function stddev (allz, avz, sizddx) result (sz)

implicit none

integer, intent(in) :: sizddx
real , intent(in) :: allz (sizddx)
real , intent(in) :: avz

real  :: sqsum
real  :: sz

integer :: ii
sqsum = 0.

do ii=1, sizddx
  sqsum = sqsum + (allz(ii)-avz)**2
end do
sz = sqrt (sqsum / sizddx)
end function stddev

! =======================================================================================
! Fill arrays x and y with gaussian distributed random numbers
! x and y are cartesian coordinates of points. Transformed to cylinder coordinates,
! the radius is gaussian distributed with standard deviation of 1.0, and the polar angle
! phi is uniformly distributed between 0 and 2.0*PI
! =======================================================================================
subroutine fillRandom (x,y,n)

implicit none

real, parameter :: sigma = sqrt(2.) / 2.          ! Forces sigma of radius of (x,y) to be 1.0
integer, intent(in) :: n                          ! Dimension of arrays x and y
real, intent(out) :: x(n),y(n)                    ! the arrays to fill
integer :: ii                                     ! Loop index
do ii=1, n
  call normrand(x(ii),y(ii), sigma)
enddo
end subroutine fillRandom


! ==========================================================================================
! Generate a pair of gaussian distributed pseudo-randum numbers (in cartesian coordinates),
! each with a mean value = 0 and standard deviation of sigma
! ==========================================================================================
subroutine normrand(x,y, sigma)

implicit none

! Using Box-Muller method as described in Wikipedia,
! and the formulae therein

real, intent(out) :: x,y                  ! the two variables to be filled with pseudo random numbers
real, intent(in) :: sigma                 ! standard deviation of the distribution in x and y
real, parameter :: twopi = 2.*acos(-1.)
real :: u(2), radius, phi

call random_number(u)                     ! n.b.: this sets both elements of u to random in [0...1]

radius = sigma * sqrt(-2 * log(u(1)))     ! norm distribution in radius
phi = twopi*u(2)                          ! Uniform distribution in angle
x = radius * cos(phi)                     ! to cartesian coordinates
y = radius * sin(phi)

end subroutine normrand
