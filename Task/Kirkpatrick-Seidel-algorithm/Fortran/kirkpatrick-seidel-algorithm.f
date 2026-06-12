! Kirkpatrick-Seidel convex hull algorithm
!
! Computes the convex hull of a set of 2D points in O(n log h) time,
! where n is the number of input points and h is the number of hull vertices.
!
! The algorithm works by separately computing the upper and lower hulls.
! The upper hull is built by the connect/bridge divide-and-conquer scheme:
!   - Split the point set at the median x-coordinate
!   - Find the "bridge": the unique upper-hull edge that crosses the split line
!   - Recurse on the left and right subsets
! The lower hull is obtained by negating all y-coordinates, running the
! same upper-hull logic, then negating y back.
!
! Key subroutines:
!   bridge_ks    -- finds the upper bridge across a vertical line
!   connect_ks   -- recursively assembles upper-hull vertices between two anchors
!   upper_hull_ks -- top-level upper hull driver
!   convex_hull_ks -- combines upper and lower hulls into the full convex hull

module ks_module
   implicit none

   ! A 2D point with double-precision coordinates
   type :: point
      real(kind=8) :: x = 0.0d0
      real(kind=8) :: y = 0.0d0
   end type point

contains

   ! -----------------------------------------------------------------------
   ! pt_eq: returns .true. if two points are within 1e-10 of each other
   ! -----------------------------------------------------------------------
   logical function pt_eq(p1, p2)
      type(point), intent(in) :: p1, p2
      pt_eq = abs(p1%x - p2%x) < 1.0d-10 .and. abs(p1%y - p2%y) < 1.0d-10
   end function pt_eq

   ! -----------------------------------------------------------------------
   ! pt_lt: lexicographic less-than -- compares x first, then y on a tie.
   ! This defines a total ordering used for pairing, sorting, and quickselect.
   ! -----------------------------------------------------------------------
   logical function pt_lt(p1, p2)
      type(point), intent(in) :: p1, p2
      if (abs(p1%x - p2%x) < 1.0d-10) then
         pt_lt = p1%y < p2%y      ! x is equal: compare y
      else
         pt_lt = p1%x < p2%x      ! compare x
      end if
   end function pt_lt

   ! -----------------------------------------------------------------------
   ! pt_min_arr: returns the lexicographically smallest point in pts(1:n)
   ! -----------------------------------------------------------------------
   type(point) function pt_min_arr(pts, n)
      integer, intent(in) :: n
      type(point), intent(in) :: pts(n)
      integer :: i
      pt_min_arr = pts(1)
      do i = 2, n
         if (pt_lt(pts(i), pt_min_arr)) pt_min_arr = pts(i)
      end do
   end function pt_min_arr

   ! -----------------------------------------------------------------------
   ! pt_max_arr: returns the lexicographically largest point in pts(1:n)
   ! -----------------------------------------------------------------------
   type(point) function pt_max_arr(pts, n)
      integer, intent(in) :: n
      type(point), intent(in) :: pts(n)
      integer :: i
      pt_max_arr = pts(1)
      do i = 2, n
         if (pt_lt(pt_max_arr, pts(i))) pt_max_arr = pts(i)
      end do
   end function pt_max_arr

   ! -----------------------------------------------------------------------
   ! quickselect_r: partial-sort a real(8) array so that arr(idx) contains
   ! the idx-th smallest value (1-based).  Uses Lomuto partition with the
   ! first element as pivot.  Only the segment arr(lo:hi) is touched.
   ! -----------------------------------------------------------------------
   recursive real(kind=8) function quickselect_r(arr, n, idx, lo, hi) result(res)
      integer, intent(in) :: n, idx, lo, hi
      real(kind=8), intent(inout) :: arr(n)
      integer :: cur, run
      real(kind=8) :: tmp

      if (lo >= hi) then
         res = arr(lo)   ! single element -- it is the answer
         return
      end if

      ! Partition: move elements smaller than arr(lo) to its left
      cur = lo
      do run = lo + 1, hi
         if (arr(run) < arr(lo)) then
            cur = cur + 1
            tmp = arr(cur); arr(cur) = arr(run); arr(run) = tmp
         end if
      end do
      ! Place pivot in its final position
      tmp = arr(cur); arr(cur) = arr(lo); arr(lo) = tmp

      ! Recurse into whichever half contains the target index
      if (idx < cur) then
         res = quickselect_r(arr, n, idx, lo, cur - 1)
      else if (idx > cur) then
         res = quickselect_r(arr, n, idx, cur + 1, hi)
      else
         res = arr(cur)
      end if
   end function quickselect_r

   ! -----------------------------------------------------------------------
   ! quickselect_p: same as quickselect_r but operates on a Point array,
   ! using the lexicographic pt_lt ordering.  Returns the point that would
   ! sit at position idx if the array were fully sorted.
   ! -----------------------------------------------------------------------
   recursive type(point) function quickselect_p(arr, n, idx, lo, hi) result(res)
      integer, intent(in) :: n, idx, lo, hi
      type(point), intent(inout) :: arr(n)
      integer :: cur, run
      type(point) :: tmp

      if (lo >= hi) then
         res = arr(lo)
         return
      end if

      cur = lo
      do run = lo + 1, hi
         if (pt_lt(arr(run), arr(lo))) then
            cur = cur + 1
            tmp = arr(cur); arr(cur) = arr(run); arr(run) = tmp
         end if
      end do
      tmp = arr(cur); arr(cur) = arr(lo); arr(lo) = tmp

      if (idx < cur) then
         res = quickselect_p(arr, n, idx, lo, cur - 1)
      else if (idx > cur) then
         res = quickselect_p(arr, n, idx, cur + 1, hi)
      else
         res = arr(cur)
      end if
   end function quickselect_p

   ! -----------------------------------------------------------------------
   ! bridge_ks: find the upper bridge of points(1:n) across the vertical
   ! line x = vline.
   !
   ! The "upper bridge" is the unique edge of the upper convex hull of the
   ! point set whose left endpoint has x <= vline and whose right endpoint
   ! has x > vline.  It is returned as (left_pt, right_pt).
   !
   ! Algorithm (Kirkpatrick-Seidel):
   !  1. Pair the points arbitrarily.  Sort each pair so left%x <= right%x.
   !     Any unpaired point goes straight to the candidate set.
   !  2. Compute the slope of each pair.  Vertical pairs are collapsed to
   !     their higher point and added to candidates.
   !  3. Find the median slope m among the remaining pairs via quickselect.
   !  4. Find the supporting line y = m*x + b that lies above all points
   !     (i.e. maximises b = y - m*x over all points in the set).
   !     The leftmost and rightmost points on this line are lft and rgt.
   !  5. If lft and rgt straddle vline, they ARE the bridge -- return them.
   !  6. Otherwise, discard half the pairs:
   !       vline to the right  (rgt%x <= vline): the bridge goes rightward,
   !         so large-slope pairs keep only their right point, small-slope
   !         pairs keep both, equal-slope pairs keep only their right point.
   !       vline to the left   (lft%x > vline): symmetric, mirrored rule.
   !  7. Recurse on the surviving candidate set.
   ! -----------------------------------------------------------------------
   recursive subroutine bridge_ks(points, n, vline, left_pt, right_pt)
      integer, intent(in) :: n
      type(point), intent(in) :: points(n)
      real(kind=8), intent(in) :: vline
      type(point), intent(out) :: left_pt, right_pt

      ! Working arrays -- allocated to safe upper-bound sizes
      type(point), allocatable :: candidates(:)  ! surviving candidate points
      type(point), allocatable :: nv_l(:), nv_r(:)  ! left/right of non-vertical pairs
      real(kind=8), allocatable :: slopes(:)     ! slope of each non-vertical pair
      real(kind=8), allocatable :: scopy(:)      ! scratch copy for quickselect
      type(point), allocatable :: mset(:)        ! supporting-line point set

      integer :: ncands    ! number of candidates accumulated so far
      integer :: npairs    ! number of pairs (reduces as verticals are removed)
      integer :: nslopes   ! number of non-vertical pairs (= slopes in use)
      integer :: nmset     ! size of supporting-line set

      type(point) :: p1, p2   ! temporary pair endpoints
      type(point) :: lft, rgt ! bridge candidate endpoints from supporting line

      integer :: i, j, pop, midx
      real(kind=8) :: mslope   ! median slope
      real(kind=8) :: maxval   ! max value of (y - mslope*x) across all points
      real(kind=8) :: val      ! per-point value of (y - mslope*x)

      ! ------------------------------------------------------------------
      ! Base cases
      ! ------------------------------------------------------------------
      if (n < 2) then
         ! Degenerate: cannot form a bridge, return the single point twice
         left_pt = points(1); right_pt = points(1)
         return
      end if

      if (n == 2) then
         ! Exactly two points: the bridge is trivially the segment between them
         if (pt_lt(points(1), points(2))) then
            left_pt = points(1); right_pt = points(2)
         else
            left_pt = points(2); right_pt = points(1)
         end if
         return
      end if

      ! ------------------------------------------------------------------
      ! Allocate working storage.
      ! candidates can grow to at most ~3n/2 in the worst case; 2*n is safe.
      ! pairs are at most n/2 in number.
      ! ------------------------------------------------------------------
      allocate(candidates(2*n))
      allocate(nv_l(n/2+2), nv_r(n/2+2))
      allocate(slopes(n/2+2), scopy(n/2+2))
      ncands = 0; npairs = 0

      ! ------------------------------------------------------------------
      ! Step 1: pair up points by taking them from the end of the array
      ! (arbitrary pairing, matching the set.pop() behaviour).
      ! Each pair is stored with the lexicographically smaller point on the left.
      ! ------------------------------------------------------------------
      pop = n
      do while (pop >= 2)
         p1 = points(pop);  pop = pop - 1
         p2 = points(pop);  pop = pop - 1
         npairs = npairs + 1
         if (pt_lt(p1, p2)) then
            nv_l(npairs) = p1;  nv_r(npairs) = p2
         else
            nv_l(npairs) = p2;  nv_r(npairs) = p1
         end if
      end do

      ! Any leftover odd point becomes an immediate candidate
      if (pop == 1) then
         ncands = ncands + 1
         candidates(ncands) = points(1)
      end if

      ! ------------------------------------------------------------------
      ! Step 2: handle vertical pairs (same x within tolerance).
      ! A vertical pair cannot have a meaningful slope, so collapse it to
      ! its higher point and remove it from the pair list.
      ! ------------------------------------------------------------------
      nslopes = 0
      i = 1
      do while (i <= npairs)
         if (abs(nv_l(i)%x - nv_r(i)%x) < 1.0d-10) then
            ! Vertical pair: keep the higher-y endpoint as a candidate
            ncands = ncands + 1
            if (nv_l(i)%y >= nv_r(i)%y) then
               candidates(ncands) = nv_l(i)
            else
               candidates(ncands) = nv_r(i)
            end if
            ! Remove this pair by shifting the remainder down
            do j = i, npairs - 1
               nv_l(j) = nv_l(j+1)
               nv_r(j) = nv_r(j+1)
            end do
            npairs = npairs - 1
            ! Do NOT advance i: recheck the slot just filled by the shift
         else
            ! Non-vertical pair: record its slope and advance
            nslopes = nslopes + 1
            slopes(nslopes) = (nv_l(i)%y - nv_r(i)%y) / (nv_l(i)%x - nv_r(i)%x)
            i = i + 1
         end if
      end do

      ! ------------------------------------------------------------------
      ! Edge case: all pairs were vertical; candidates contain the survivors.
      ! Return the first two in sorted order as a fallback bridge.
      ! ------------------------------------------------------------------
      if (nslopes == 0) then
         if (ncands >= 2) then
            if (pt_lt(candidates(1), candidates(2))) then
               left_pt = candidates(1);  right_pt = candidates(2)
            else
               left_pt = candidates(2);  right_pt = candidates(1)
            end if
         else
            ! Fewer than 2 candidates -- fall back to the first two input points
            if (pt_lt(points(1), points(2))) then
               left_pt = points(1);  right_pt = points(2)
            else
               left_pt = points(2);  right_pt = points(1)
            end if
         end if
         deallocate(candidates, nv_l, nv_r, slopes, scopy)
         return
      end if

      ! ------------------------------------------------------------------
      ! Step 3: find the median slope using quickselect.
      !
      ! The index formula mirrors the original algorithm:
      !   median_index = (count // 2) - (0 if odd count else 1)   [0-based]
      ! Converting to 1-based Fortran: add 1 to the 0-based result.
      ! ------------------------------------------------------------------
      midx = (nslopes / 2) - merge(0, 1, mod(nslopes, 2) /= 0) + 1
      do i = 1, nslopes
         scopy(i) = slopes(i)   ! quickselect modifies the array in place
      end do
      mslope = quickselect_r(scopy, nslopes, midx, 1, nslopes)

      ! ------------------------------------------------------------------
      ! Step 4: find the supporting line with slope mslope.
      ! The supporting line is y = mslope*x + b where b = max(y - mslope*x).
      ! Collect all points that lie ON this line into mset.
      ! lft = leftmost (min) and rgt = rightmost (max) point of mset.
      ! ------------------------------------------------------------------
      maxval = -huge(1.0d0)
      do i = 1, n
         val = points(i)%y - mslope * points(i)%x
         if (val > maxval) maxval = val
      end do

      allocate(mset(n))
      nmset = 0
      do i = 1, n
         if (abs(points(i)%y - mslope * points(i)%x - maxval) < 1.0d-10) then
            nmset = nmset + 1
            mset(nmset) = points(i)
         end if
      end do
      lft = pt_min_arr(mset, nmset)
      rgt = pt_max_arr(mset, nmset)
      deallocate(mset)

      ! ------------------------------------------------------------------
      ! Step 5: check whether lft-rgt already straddles the vertical line.
      ! If so, it IS the upper bridge -- return it immediately.
      ! ------------------------------------------------------------------
      if (lft%x <= vline .and. vline < rgt%x) then
         left_pt = lft;  right_pt = rgt
         deallocate(candidates, nv_l, nv_r, slopes, scopy)
         return
      end if

      ! ------------------------------------------------------------------
      ! Step 6: the bridge must lie entirely to one side of the supporting
      ! line endpoints.  Discard pairs that cannot contribute to the bridge:
      !
      ! Case A -- vline is to the RIGHT of the supporting pair (rgt%x <= vline):
      !   The real bridge has a slope >= mslope, so:
      !     large-slope pairs (slope > mslope): left point cannot be on the bridge
      !       -> keep only the right point
      !     equal-slope pairs: same reasoning -> keep only the right point
      !     small-slope pairs (slope < mslope): either endpoint might be needed
      !       -> keep both points
      !
      ! Case B -- vline is to the LEFT (lft%x > vline): symmetric mirror:
      !     small-slope pairs: keep only the left point
      !     equal-slope pairs: keep only the left point
      !     large-slope pairs: keep both points
      ! ------------------------------------------------------------------
      if (rgt%x <= vline) then
         do i = 1, nslopes
            if (slopes(i) > mslope + 1.0d-10) then        ! large: keep right only
               ncands = ncands + 1;  candidates(ncands) = nv_r(i)
            else if (abs(slopes(i) - mslope) <= 1.0d-10) then  ! equal: keep right only
               ncands = ncands + 1;  candidates(ncands) = nv_r(i)
            else                                             ! small: keep both
               ncands = ncands + 1;  candidates(ncands) = nv_l(i)
               ncands = ncands + 1;  candidates(ncands) = nv_r(i)
            end if
         end do
      end if

      if (lft%x > vline) then
         do i = 1, nslopes
            if (slopes(i) < mslope - 1.0d-10) then        ! small: keep left only
               ncands = ncands + 1;  candidates(ncands) = nv_l(i)
            else if (abs(slopes(i) - mslope) <= 1.0d-10) then  ! equal: keep left only
               ncands = ncands + 1;  candidates(ncands) = nv_l(i)
            else                                             ! large: keep both
               ncands = ncands + 1;  candidates(ncands) = nv_l(i)
               ncands = ncands + 1;  candidates(ncands) = nv_r(i)
            end if
         end do
      end if

      ! ------------------------------------------------------------------
      ! Step 7: recurse on the reduced candidate set.
      ! Each recursion reduces the problem size by a constant fraction,
      ! giving the O(n) bridge-finding cost at each level of connect_ks.
      ! ------------------------------------------------------------------
      call bridge_ks(candidates, ncands, vline, left_pt, right_pt)
      deallocate(candidates, nv_l, nv_r, slopes, scopy)
   end subroutine bridge_ks

   ! -----------------------------------------------------------------------
   ! connect_ks: recursively assemble the upper hull vertices that lie
   ! between the anchor points "lower" (leftmost) and "upper" (rightmost).
   !
   ! points(1:n) is the filtered working set: it contains lower, upper, and
   ! all input points whose x-coordinate lies strictly between them.
   !
   ! On return, result(1:nresult) holds the upper-hull vertices from lower
   ! to upper inclusive, in left-to-right order.
   !
   ! Algorithm:
   !  1. Base case: lower == upper -> return [lower].
   !  2. Find the median x split via quickselect on the point array.
   !  3. Call bridge_ks to find the bridge (lft, rgt) across the split.
   !  4. Recurse left:  connect(lower, lft, points with x <= lft%x)
   !     Recurse right: connect(rgt,   upper, points with x >= rgt%x)
   !  5. Concatenate left result + right result.
   ! -----------------------------------------------------------------------
   recursive subroutine connect_ks(lower, upper, points, n, result, nresult)
      type(point), intent(in) :: lower, upper
      integer, intent(in) :: n
      type(point), intent(in) :: points(n)
      type(point), allocatable, intent(out) :: result(:)
      integer, intent(out) :: nresult

      type(point) :: lft, rgt, qtmp
      type(point), allocatable :: pcopy(:)    ! scratch copy for quickselect
      type(point), allocatable :: pts_l(:)    ! left sub-problem point set
      type(point), allocatable :: pts_r(:)    ! right sub-problem point set
      type(point), allocatable :: res_l(:)    ! result from left recursion
      type(point), allocatable :: res_r(:)    ! result from right recursion
      integer :: i, j, nl, nr, nrl, nrr, midx
      real(kind=8) :: vline   ! x-coordinate of the vertical split line

      ! ------------------------------------------------------------------
      ! Base case: the two anchors are the same point
      ! ------------------------------------------------------------------
      if (pt_eq(lower, upper)) then
         allocate(result(1))
         result(1) = lower
         nresult = 1
         return
      end if

      ! ------------------------------------------------------------------
      ! Find the vertical split line as the midpoint between the median
      ! point and its neighbour (by lexicographic rank in the point set).
      ! midx is a 0-based index; convert to 1-based for quickselect_p.
      ! Using min(..., n) guards against the edge case where n == 1.
      ! ------------------------------------------------------------------
      midx = n / 2
      allocate(pcopy(n))

      pcopy = points
      qtmp = quickselect_p(pcopy, n, midx + 1, 1, n)      ! rank midx   (0-based)
      lft = qtmp

      pcopy = points
      qtmp = quickselect_p(pcopy, n, min(midx + 2, n), 1, n)  ! rank midx+1 (0-based)
      rgt = qtmp

      deallocate(pcopy)
      vline = (lft%x + rgt%x) / 2.0d0   ! split between the two median ranks

      ! ------------------------------------------------------------------
      ! Find the upper bridge across vline.
      ! After this call lft and rgt are overwritten with the actual bridge
      ! endpoints (discarding the quickselect approximations used for vline).
      ! ------------------------------------------------------------------
      call bridge_ks(points, n, vline, lft, rgt)

      ! ------------------------------------------------------------------
      ! Build the LEFT sub-problem:
      !   { lft } union { p in points : p%x < lft%x }
      ! lft itself is always the first element; remaining points follow.
      ! ------------------------------------------------------------------
      nl = 1
      do i = 1, n
         if (points(i)%x < lft%x) nl = nl + 1
      end do
      allocate(pts_l(nl))
      pts_l(1) = lft
      j = 1
      do i = 1, n
         if (points(i)%x < lft%x) then
            j = j + 1
            pts_l(j) = points(i)
         end if
      end do

      ! ------------------------------------------------------------------
      ! Build the RIGHT sub-problem:
      !   { rgt } union { p in points : p%x > rgt%x }
      ! ------------------------------------------------------------------
      nr = 1
      do i = 1, n
         if (points(i)%x > rgt%x) nr = nr + 1
      end do
      allocate(pts_r(nr))
      pts_r(1) = rgt
      j = 1
      do i = 1, n
         if (points(i)%x > rgt%x) then
            j = j + 1
            pts_r(j) = points(i)
         end if
      end do

      ! Recurse on both halves then free the sub-problem arrays
      call connect_ks(lower, lft, pts_l, nl, res_l, nrl)
      call connect_ks(rgt, upper, pts_r, nr, res_r, nrr)
      deallocate(pts_l, pts_r)

      ! Concatenate left and right results
      nresult = nrl + nrr
      allocate(result(nresult))
      do i = 1, nrl
         result(i) = res_l(i)
      end do
      do i = 1, nrr
         result(nrl + i) = res_r(i)
      end do
      deallocate(res_l, res_r)
   end subroutine connect_ks

   ! -----------------------------------------------------------------------
   ! upper_hull_ks: compute the upper convex hull of points(1:n).
   !
   ! Identifies the leftmost and rightmost anchors, filters out any points
   ! that lie strictly outside the x-range or below the baseline, then
   ! delegates to connect_ks to build the hull chain.
   !
   ! "Leftmost" means smallest x; ties broken by taking the highest y
   ! (so the leftmost anchor is always on the upper hull).
   ! "Rightmost" means largest x (lexicographic max).
   ! -----------------------------------------------------------------------
   subroutine upper_hull_ks(points, n, result, nresult)
      integer, intent(in) :: n
      type(point), intent(in) :: points(n)
      type(point), allocatable, intent(out) :: result(:)
      integer, intent(out) :: nresult

      type(point) :: lft, rgt
      type(point), allocatable :: filtered(:)
      integer :: i, j, nf

      ! Leftmost point: start with lexicographic min (smallest x, then smallest y)
      ! then scan for a higher y at the same x, so the anchor is on the upper hull
      lft = pt_min_arr(points, n)
      do i = 1, n
         if (abs(points(i)%x - lft%x) < 1.0d-10 .and. points(i)%y > lft%y) lft = points(i)
      end do

      ! Rightmost point: lexicographic max (largest x, then largest y)
      rgt = pt_max_arr(points, n)

      ! Collect the two anchors plus all points strictly between them in x.
      ! Points at x == lft%x or x == rgt%x (other than the anchors themselves)
      ! are excluded because they cannot be on the upper hull between lft and rgt.
      nf = 2   ! always includes lft and rgt
      do i = 1, n
         if (points(i)%x > lft%x .and. points(i)%x < rgt%x) nf = nf + 1
      end do
      allocate(filtered(nf))
      filtered(1) = lft
      filtered(2) = rgt
      j = 2
      do i = 1, n
         if (points(i)%x > lft%x .and. points(i)%x < rgt%x) then
            j = j + 1
            filtered(j) = points(i)
         end if
      end do

      call connect_ks(lft, rgt, filtered, nf, result, nresult)
      deallocate(filtered)
   end subroutine upper_hull_ks

   ! -----------------------------------------------------------------------
   ! convex_hull_ks: compute the full convex hull of points(1:n).
   !
   ! Returns result(1:nresult) as the hull vertices in CCW order:
   !   result(1..nupper)           upper hull, left to right
   !   result(nupper+1..nresult)   lower hull, left to right
   !                               (shared endpoints are deduplicated)
   !
   ! The lower hull is obtained by negating all y-coordinates, running
   ! upper_hull_ks on the flipped set, then negating y back.  This reuses
   ! the upper-hull logic without any separate lower-hull implementation.
   ! -----------------------------------------------------------------------
   subroutine convex_hull_ks(points, n, result, nresult)
      integer, intent(in) :: n
      type(point), intent(in) :: points(n)
      type(point), allocatable, intent(out) :: result(:)
      integer, intent(out) :: nresult

      type(point), allocatable :: upper(:)    ! upper hull vertices
      type(point), allocatable :: flipped(:)  ! y-negated input for lower hull
      type(point), allocatable :: fupper(:)   ! upper hull of flipped points
      type(point), allocatable :: lower(:)    ! lower hull vertices (y restored)
      integer :: nupper, nfupper, nlower
      integer :: i, ls, le   ! trimming indices for the lower hull

      ! --- Upper hull ---
      call upper_hull_ks(points, n, upper, nupper)

      ! --- Lower hull via y-negation trick ---
      allocate(flipped(n))
      do i = 1, n
         flipped(i)%x = -points(i)%x
         flipped(i)%y = -points(i)%y
      end do
      call upper_hull_ks(flipped, n, fupper, nfupper)
      deallocate(flipped)

      ! Restore y sign to get the actual lower hull
      allocate(lower(nfupper))
      do i = 1, nfupper
         lower(i)%x = -fupper(i)%x
         lower(i)%y = -fupper(i)%y
      end do
      deallocate(fupper)
      nlower = nfupper

      ! --- Deduplicate the junction points ---
      ! The upper hull ends at the rightmost point; the lower hull begins there.
      ! The lower hull ends at the leftmost point; the upper hull begins there.
      ! Trim whichever endpoints duplicate an already-included point.
      ls = 1;  le = nlower
      if (nupper > 0 .and. nlower > 0) then
         if (pt_eq(upper(nupper), lower(ls))) ls = ls + 1   ! trim lower start
      end if
      if (nupper > 0 .and. le >= ls) then
         if (pt_eq(upper(1), lower(le))) le = le - 1        ! trim lower end
      end if

      ! Assemble final result: upper hull followed by (trimmed) lower hull
      nresult = nupper + max(0, le - ls + 1)
      allocate(result(nresult))
      do i = 1, nupper
         result(i) = upper(i)
      end do
      do i = ls, le
         result(nupper + i - ls + 1) = lower(i)
      end do
      deallocate(upper, lower)
   end subroutine convex_hull_ks

end module ks_module

! =========================================================================
! Main program: read points from a file or use a built-in test, then print
! the convex hull produced by convex_hull_ks.
!
! Input file format:
!   line 1 : n          (integer number of points)
!   lines 2..n+1 : x y  (coordinates, comma or space separated)
! =========================================================================
program main
   use ks_module
   implicit none

   type(point), allocatable :: points(:), hull(:)
   integer :: n, nhull, i, ios
   character(len=256) :: fname

   write(*, '(a)', advance='no') 'Input file (or RETURN for built-in test): '
   read(*, '(a)') fname
   fname = adjustl(fname)

   if (len_trim(fname) == 0) then
      ! Built-in test: four points forming a triangle with one interior point
      n = 4
      allocate(points(n))
      points(1) = point(0.0d0, 0.0d0)
      points(2) = point(1.0d0, 0.0d0)
      points(3) = point(0.0d0, 1.0d0)
      points(4) = point(0.5d0, 0.5d0)   ! interior point; should not appear in hull
   else
      open(unit=10, file=trim(fname), status='old', iostat=ios)
      if (ios /= 0) then
         write(*, *) 'ERROR: cannot open ', trim(fname)
         stop 1
      end if
      read(10, *) n
      allocate(points(n))
      do i = 1, n
         read(10, *) points(i)%x, points(i)%y
      end do
      close(10)
   end if

   write(*, *) 'Input points:'
   do i = 1, n
      write(*, '(a,f0.6,a,f0.6,a)') '(', points(i)%x, ', ', points(i)%y, ')'
   end do
   write(*, *)

   call convex_hull_ks(points, n, hull, nhull)

   write(*, *) 'Convex hull points:'
   do i = 1, nhull
      write(*, '(a,f0.6,a,f0.6,a)') '(', hull(i)%x, ', ', hull(i)%y, ')'
   end do
   write(*, *)
   write(*, '(a,i0)') 'Hull vertex count: ', nhull

   deallocate(points, hull)
end program main
