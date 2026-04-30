! ==============================================================================
! circle_union.f90  --  '''Exact''' area of the union of N overlapping disks
! ==============================================================================
!
! METHOD: Analytical boundary integration via Green's theorem
! -----------------------------------------------------------------
! Rather than sampling the plane (Monte Carlo or grid), this program
! computes the area EXACTLY (to floating-point precision) by integrating
! along the true geometric boundary of the union.
!
! The boundary of the union of circles is a closed curve made up entirely
! of circular arcs -- pieces of individual circle boundaries that are not
! covered by any other circle.  Green's theorem converts a 2-D area
! integral into a 1-D line integral around that boundary:
!
!   A  =  (1/2) * INTEGRAL_boundary ( x dy - y dx )
!
! For an arc of radius r centred at (cx, cy), running from angle t1 to t2
! in the counterclockwise direction, the parametric form is:
!
!   x(t) = cx + r*cos(t),   y(t) = cy + r*sin(t)
!   dx   = -r*sin(t) dt,    dy   =  r*cos(t) dt
!
! Substituting and integrating analytically gives the closed-form result:
!
!   arc contribution  =  (r/2) * [ cx*(sin(t2)-sin(t1))
!                                 - cy*(cos(t2)-cos(t1))
!                                 + r*(t2-t1) ]
!
! Summing this over every boundary arc yields the total area with no
! approximation error beyond normal IEEE 754 double-precision rounding.
!
! WHY THIS IS SUPERIOR TO SAMPLING APPROACHES
! -----------------------------------------------------------------
! 1. ACCURACY
!    Monte Carlo converges as 1/sqrt(S) where S is the number of samples.
!    To gain one extra decimal digit you must take 100x more samples.
!    A grid (pixel-counting) approach converges as 1/S, still slow.
!    This method has NO convergence parameter -- the result is exact up
!    to floating-point rounding (~15 significant digits with real(kind=real64)).
!
! 2. SPEED
!    The work here is O(n^2) in the number of circles: for each of the n
!    circles we examine at most n-1 others to find intersections.  For
!    n=25 that is a handful of microseconds.  A sampling method accurate
!    to 10 decimal places would need billions of samples and many seconds.
!
! 3. NO TUNING
!    Sampling methods require the user to choose a sample count or grid
!    resolution and then judge whether it is "good enough".  This method
!    has no such knob; the answer is simply correct.
!
! 4. ROBUSTNESS TO GEOMETRY
!    Grid methods can mis-count when a circle boundary happens to pass
!    very close to a grid node.  Monte Carlo has similar edge effects near
!    boundaries.  This method handles all configurations -- tangent circles,
!    near-tangent circles, tiny circles, and fully-contained circles --
!    through straightforward geometric tests with no special-casing of
!    near-degenerate configurations (apart from a small epsilon guard on
!    near-zero arc lengths).
!
! ALGORITHM OUTLINE
! -----------------------------------------------------------------
! For each circle i:
!   1. If circle i lies entirely inside some other circle j, skip it --
!      none of its boundary is exposed and its area is already counted
!      inside j.
!   2. Find every circle j that properly crosses circle i's boundary.
!      Each such intersection contributes two angles (measured from the
!      centre of circle i) computed via the law of cosines.
!   3. Sort those angles.  They divide circle i into arcs.
!   4. For each arc, sample its midpoint and test whether that point
!      lies inside any other circle.  If not, the arc is on the outer
!      boundary of the union and its Green's-theorem contribution is added.
!   5. If no other circle intersects circle i at all, add the full disk
!      area pi*r^2.
!
! DATASET  (Rosetta Code standard test, 25 disks, 11 fully contained)
! Expected result:  21.56503660...
! ==============================================================================

program circle_union
   use iso_fortran_env, only:real64
   implicit none

   ! Number of circles in the dataset
   integer, parameter :: n = 25

   real(kind=real64), parameter :: pi = acos(-1.0d0)
   real(kind=real64), parameter :: two_pi = 2.0d0 * pi

   ! Circle centre coordinates and radii
   real(kind=real64) :: xc(n), yc(n), r(n)

   ! Intersection angles collected for the current circle i.
   ! At most 2*(n-1) intersections are possible (two per circle pair),
   ! so 2*n+2 is a safe upper bound.
   real(kind=real64) :: angles(2 * n + 2)
   integer :: nang ! number of angles collected so far

   ! Working variables
   real(kind=real64) :: area ! accumulated union area
   real(kind=real64) :: dx, dy ! vector from centre i to centre j
   real(kind=real64) :: d2, d ! squared distance and distance between centres
   real(kind=real64) :: a ! cosine of half the intersection angle (law of cosines)
   real(kind=real64) :: phi ! bearing from centre i to centre j
   real(kind=real64) :: da ! half-angle offset to each intersection point
   real(kind=real64) :: t1, t2 ! start and end angles of the current arc
   real(kind=real64) :: tmid ! midpoint angle of the current arc
   real(kind=real64) :: xm, ym ! Cartesian coordinates of the arc midpoint
   integer :: i, j, k
   logical :: fully_inside ! true when circle i is swallowed by circle j
   logical :: arc_outside ! true when arc midpoint is outside all other circles

   ! ------------------------------------------------------------------
   ! Dataset: centre (xc, yc) and radius r for each of the 25 disks
   ! (Rosetta Code standard input)
   ! ------------------------------------------------------------------
   xc = [ 1.6417233788d0, -1.4944608174d0, 0.6110294452d0, 0.3844862411d0, &
         -0.2495892950d0, 1.7813504266d0, -0.1985249206d0, -1.7011985145d0, &
         -0.4319462812d0, 0.2178372997d0, -0.6294854565d0, 1.7952608455d0, &
         1.4168575317d0, 1.4637371396d0, -0.5263668798d0, -1.2197352481d0, &
         -0.1389358881d0, 1.5293954595d0, -0.5258728625d0, -0.1403562064d0, &
         0.8055826339d0, -0.6311979224d0, 1.4685857879d0, -0.6855727502d0, &
         0.0152957411d0 ]
   yc = [ 1.6121789534d0, 1.2077959613d0, -0.6907087527d0, 0.2923344616d0, &
         -0.3832854473d0, 1.6178237031d0, -0.8343333301d0, -0.1263820964d0, &
         1.4104420482d0, -0.9499557344d0, -1.3078893852d0, 0.6281269104d0, &
         1.0683357171d0, 0.9463877418d0, 1.7315156631d0, 0.9144146579d0, &
         0.1092805780d0, 0.0030278255d0, 1.3782633069d0, 0.2437382535d0, &
         -0.0482092025d0, 0.7184578971d0, -0.8347049536d0, 1.6465021616d0, &
         0.0638919221d0 ]
   r = [ 0.0848270516d0, 1.1039549836d0, 0.9089162485d0, 0.2375743054d0, &
         1.0845181219d0, 0.8162655711d0, 0.0538864941d0, 0.4776976918d0, &
         0.7886291537d0, 0.0357871187d0, 0.7653357688d0, 0.2727652452d0, &
         1.1016025378d0, 1.1846214562d0, 1.4428514068d0, 1.0727263474d0, &
         0.7350208828d0, 1.2472867347d0, 1.3495508831d0, 1.3804956588d0, &
         0.3327165165d0, 0.2491045282d0, 1.3670667538d0, 1.0593087096d0, &
         0.9771215985d0 ]

   area = 0.0d0

   ! ==================================================================
   ! Main loop: process each circle in turn
   ! ==================================================================
   do i = 1, n

      ! ------------------------------------------------------------------
      ! Step 1: skip circles that are entirely swallowed by another circle.
      !
      ! Circle i is inside circle j when the farthest point of circle i
      ! (i.e. the point on circle i closest to circle j's boundary on the
      ! far side) still does not reach circle j's boundary:
      !
      !   d(centres) + r_i  <=  r_j
      !
      ! Such circles contribute nothing to the union boundary; their area
      ! is already included inside the larger circle.
      ! ------------------------------------------------------------------
      fully_inside = .false.
      do j = 1, n
         if (i == j) cycle
         dx = xc(j) - xc(i)
         dy = yc(j) - yc(i)
         d = hypot(dx, dy)
         if (d + r(i) <= r(j)) then
            fully_inside = .true.
            exit
         end if
      end do
      if (fully_inside) cycle ! nothing to do for this circle

      ! ------------------------------------------------------------------
      ! Step 2: find the angles at which other circles cross circle i.
      !
      ! Two circles intersect properly when:
      !   |r_i - r_j| < d < r_i + r_j
      !
      ! Given that they do intersect, the law of cosines gives the cosine
      ! of the angle (measured at centre i) between the line i->j and each
      ! intersection point:
      !
      !   cos(da) = (r_i^2 + d^2 - r_j^2) / (2 * r_i * d)
      !
      ! The two intersection angles are therefore:  phi +/- da
      ! where phi = atan2(yj-yi, xj-xi) is the bearing from i to j.
      ! ------------------------------------------------------------------
      nang = 0
      do j = 1, n
         if (i == j) cycle
         dx = xc(j) - xc(i)
         dy = yc(j) - yc(i)
         d2 = dx * dx + dy * dy
         d = sqrt(d2)

         ! Circles are external to each other -- no intersection
         if (d >= r(i) + r(j)) cycle

         ! Circle j is entirely inside circle i -- does not cut i's boundary
         if (d + r(j) <= r(i)) cycle

         ! Compute the two crossing angles via the law of cosines
         a = (r(i)**2 + d2 - r(j)**2) / (2.0d0 * r(i) * d)
         a = max(-1.0d0, min(1.0d0, a)) ! clamp against floating-point overshoot
         phi = atan2(dy, dx) ! bearing from centre i to centre j
         da = acos(a) ! half-angle to each intersection point

         nang = nang + 1
         angles(nang) = phi - da ! left intersection
         nang = nang + 1
         angles(nang) = phi + da ! right intersection
      end do

      ! ------------------------------------------------------------------
      ! Special case: no other circle intersects circle i at all.
      ! Either circle i is isolated or it fully contains others but is not
      ! itself cut.  Either way its full disk area belongs to the union.
      ! ------------------------------------------------------------------
      if (nang == 0) then
         area = area + pi * r(i)**2
         cycle
      end if

      ! ------------------------------------------------------------------
      ! Step 3: normalise all angles to [0, 2*pi) and sort them.
      !
      ! After normalisation the sorted list partitions the full circle
      ! into nang consecutive arcs.  We also handle the wrap-around arc
      ! from angles(nang) back to angles(1) + 2*pi in the loop below.
      ! ------------------------------------------------------------------
      do k = 1, nang
         angles(k) = mod(angles(k), two_pi)
         if (angles(k) < 0.0d0) angles(k) = angles(k) + two_pi
      end do

      call isort(angles, nang) ! ascending sort; see subroutine below

      ! ------------------------------------------------------------------
      ! Step 4: for each arc, test whether it lies on the union boundary.
      !
      ! An arc belongs to the boundary of the union if and only if its
      ! interior is NOT covered by any other circle.  We test this at the
      ! arc's angular midpoint: if that single point is outside all other
      ! circles then the entire arc (between two consecutive intersection
      ! events) must also be outside them all, because the only places
      ! where coverage can change are exactly the intersection angles we
      ! already collected.
      !
      ! If the arc is on the boundary, add its contribution via the
      ! closed-form Green's theorem integral derived in the header.
      ! ------------------------------------------------------------------
      do k = 1, nang
         t1 = angles(k)

         ! The last arc wraps around from angles(nang) back to angles(1)
         if (k < nang) then
            t2 = angles(k + 1)
         else
            t2 = angles(1) + two_pi
         end if

         ! Skip numerically degenerate arcs (two intersection points that
         ! landed at almost the same angle due to near-tangency)
         if (t2 - t1 < 1.0d-12) cycle

         ! Cartesian coordinates of the arc midpoint on circle i
         tmid = 0.5d0 * (t1 + t2)
         xm = xc(i) + r(i) * cos(tmid)
         ym = yc(i) + r(i) * sin(tmid)

         ! Is this midpoint outside every other circle?
         arc_outside = .true.
         do j = 1, n
            if (i == j) cycle
            dx = xm - xc(j)
            dy = ym - yc(j)
            ! Using squared distance avoids an unnecessary sqrt
            if (dx * dx + dy * dy < r(j)**2) then
               arc_outside = .false.
               exit
            end if
         end do

         ! If the arc is exposed, accumulate its area contribution.
         ! Green's theorem for a circular arc from t1 to t2:
         !   dA = (1/2) * r * [ cx*(sin(t2)-sin(t1))
         !                     - cy*(cos(t2)-cos(t1))
         !                     + r*(t2-t1) ]
         ! The r*(t2-t1) term is the "pure sector" part; the cx/cy terms
         ! correct for the fact that the centre is not at the origin.
         if (arc_outside) then
            area = area + 0.5d0 * r(i) * (xc(i) * (sin(t2) - sin(t1)) &
                  - yc(i) * (cos(t2) - cos(t1)) + r(i) * (t2 - t1))
         end if
      end do

   end do ! end loop over circles

   write(*, '(a,f16.10)') 'Area = ', area

contains

   ! --------------------------------------------------------------------
   ! Insertion sort for a small real(kind=real64) array a(1:m).
   ! Insertion sort is O(m^2) but m <= 2*(n-1) = 48 here, so it is fast
   ! and avoids the overhead of a recursive quicksort.
   ! --------------------------------------------------------------------
   subroutine isort(a, m)
      real(kind=real64), intent(inout) :: a(*) ! array to sort (only first m elements used)
      integer, intent(in) :: m ! number of elements to sort
      integer :: p, q
      real(kind=real64) :: tmp
      do p = 2, m
         tmp = a(p) ! element being inserted into sorted prefix
         q = p - 1
         do while (q >= 1 .and. a(q) > tmp)
            a(q + 1) = a(q) ! shift larger elements one position right
            q = q - 1
         end do
         a(q + 1) = tmp ! drop the element into its sorted position
      end do
   end subroutine isort

end program circle_union
