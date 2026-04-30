! ==============================================================================
! Module : kdtree_mod
! Purpose: k-d tree construction and nearest-neighbour search for k-dimensional
!          point sets.
!
! A k-d tree is a binary space-partitioning tree.  At depth d the splitting
! axis cycles as axis = mod(d, k) + 1.  The median point along the chosen axis
! becomes the node; the smaller and larger halves recurse left and right.
! The result is a balanced tree of height ceil(log2 n).
!
! Nearest-neighbour search:
!   Descend to the leaf that would contain the query, then unwind.  At each
!   node the algorithm checks whether the splitting hyperplane is close enough
!   that the far subtree might contain a nearer point; if so, that subtree is
!   also searched.  This gives O(log n) average complexity while guaranteeing
!   the true nearest neighbour.
!
! Node-visit counting:
!   A node is counted as visited the moment its coordinates or split axis are
!   first read (i.e., at the top of nn_search for that node index).
!
! Public interface:
!   max_dim          -- compile-time maximum dimensionality (= 3)
!   kdnode           -- derived type: coords(max_dim), left, right, axis
!   pool(1:pool_n)   -- flat array in which the tree lives
!   pool_n           -- number of allocated nodes (= number of points)
!   pool_reset(n)    -- allocate pool for n points; call before build_kdtree
!   build_kdtree(pts, n_pts, idx, n, k) -> root node index
!   nn_search(root, query, k, best_dist2, best_idx, visited)
! ==============================================================================
module kdtree_mod
   implicit none
   private

   integer, parameter, public :: max_dim = 3   ! max k supported at compile time

   ! --------------------------------------------------------------------------
   ! One node in the k-d tree.
   !   coords -- coordinates of the point stored here (max_dim elements)
   !   left   -- pool index of the left  child (0 = no child)
   !   right  -- pool index of the right child (0 = no child)
   !   axis   -- splitting axis for this node (1-based; cycles 1..k by depth)
   ! --------------------------------------------------------------------------
   type, public :: kdnode
      real    :: coords(max_dim) = 0.0
      integer :: left            = 0
      integer :: right           = 0
      integer :: axis            = 0
   end type

   ! Pool is allocatable: sized exactly to the point count at build time.
   ! This replaces the old compile-time max_pool constant, which caused silent
   ! memory corruption when the static array was smaller than the point count.
   type(kdnode), allocatable, public :: pool(:)
   integer,                   public :: pool_n = 0

   public :: pool_reset, build_kdtree, nn_search

contains

   ! --------------------------------------------------------------------------
   ! pool_reset(n) -- (re)allocate the pool for exactly n points and reset
   !                  the node counter.  Call once before each build_kdtree.
   ! --------------------------------------------------------------------------
   subroutine pool_reset(n)
      integer, intent(in) :: n
      if (allocated(pool)) deallocate(pool)
      allocate(pool(n))
      pool_n = 0
   end subroutine

   ! --------------------------------------------------------------------------
   ! alloc_node -- claim the next pool slot, initialise it, return its index.
   ! --------------------------------------------------------------------------
   integer function alloc_node(coords, axis)
      real,    intent(in) :: coords(max_dim)   ! full coordinate column
      integer, intent(in) :: axis              ! splitting axis for this node
      pool_n              = pool_n + 1
      alloc_node          = pool_n
      pool(pool_n)%coords = coords
      pool(pool_n)%axis   = axis
      pool(pool_n)%left   = 0
      pool(pool_n)%right  = 0
   end function

   ! --------------------------------------------------------------------------
   ! isort -- insertion-sort idx(1:n) ascending by pts(dim, idx(i)).
   ! O(n^2) but branchless and cache-friendly for tiny n; used only as the
   ! base case of qsort for partitions of size <= 20.
   ! --------------------------------------------------------------------------
   subroutine isort(idx, n, pts, n_pts, dim)
      integer, intent(inout) :: idx(n)
      integer, intent(in)    :: n, n_pts, dim
      real,    intent(in)    :: pts(max_dim, n_pts)
      integer :: i, j, tmp
      do i = 2, n
         tmp = idx(i)
         j   = i - 1
         do while (j >= 1)
             if(pts(dim, idx(j)) <= pts(dim, tmp))exit
            idx(j+1) = idx(j)
            j = j - 1
         end do
         idx(j+1) = tmp
      end do
   end subroutine

   ! --------------------------------------------------------------------------
   ! qsort -- iterative quicksort of idx(1:n) ascending by pts(dim, idx(i)).
   !
   ! Non-recursive: uses an explicit integer stack (slo/shi) instead of the
   ! Fortran call stack.  This is essential for large n because the recursive
   ! version caused stack overflow: build_kdtree (~19 deep) called recursive
   ! qsort (~19 deep), and gfortran allocated per-frame bookkeeping for the
   ! pts(max_dim, n_pts) dummy at each level, exhausting the Windows stack.
   !
   ! Median-of-three pivot selection avoids O(n^2) on sorted input.
   ! Small partitions (<= 20 elements) are finished with isort.
   !
   ! Stack depth is bounded to O(log n) by the "smaller-half-first" rule:
   ! push the LARGER partition first so the SMALLER sits on top and is
   ! processed next.  For n = 400,000, log2(n) ~ 19; SMAX = 128 is ample.
   ! --------------------------------------------------------------------------
   subroutine qsort(idx, n, pts, n_pts, dim)
      integer, intent(inout) :: idx(n)
      integer, intent(in)    :: n, n_pts, dim
      real,    intent(in)    :: pts(max_dim, n_pts)

      integer, parameter :: SMAX = 128
      integer :: slo(SMAX), shi(SMAX)        ! explicit partition-boundary stack
      integer :: top, lo, hi, p, i, mid, tmp
      real    :: pivot

      if (n <= 1) return

      top      = 1
      slo(top) = 1
      shi(top) = n

      do while (top > 0)
         lo  = slo(top)
         hi  = shi(top)
         top = top - 1

         ! Base case: insertion sort for small partitions
         if (hi - lo < 20) then
            call isort(idx(lo:hi), hi - lo + 1, pts, n_pts, dim)
            cycle
         end if

         ! Median-of-three: compare lo, mid, hi; place median at hi as pivot
         mid = lo + (hi - lo) / 2
         if (pts(dim,idx(lo))  > pts(dim,idx(mid))) then; tmp=idx(lo);  idx(lo)=idx(mid); idx(mid)=tmp; end if
         if (pts(dim,idx(lo))  > pts(dim,idx(hi)))  then; tmp=idx(lo);  idx(lo)=idx(hi);  idx(hi)=tmp;  end if
         if (pts(dim,idx(mid)) > pts(dim,idx(hi)))  then; tmp=idx(mid); idx(mid)=idx(hi); idx(hi)=tmp;  end if
         tmp = idx(mid); idx(mid) = idx(hi); idx(hi) = tmp   ! median -> pivot slot

         ! Lomuto partition on idx(lo:hi)
         pivot = pts(dim, idx(hi))
         p = lo - 1
         do i = lo, hi - 1
            if (pts(dim, idx(i)) <= pivot) then
               p = p + 1
               tmp = idx(p); idx(p) = idx(i); idx(i) = tmp
            end if
         end do
         p = p + 1
         tmp = idx(p); idx(p) = idx(hi); idx(hi) = tmp   ! place pivot at p

         ! Push sub-problems: LARGER partition goes below SMALLER (O(log n) stack)
         if ((p - lo) >= (hi - p)) then      ! left [lo,p-1] is larger
            if (lo   < p - 1) then; top=top+1; slo(top)=lo;  shi(top)=p-1; end if
            if (p + 1 < hi)   then; top=top+1; slo(top)=p+1; shi(top)=hi;  end if
         else                                ! right [p+1,hi] is larger
            if (p + 1 < hi)   then; top=top+1; slo(top)=p+1; shi(top)=hi;  end if
            if (lo   < p - 1) then; top=top+1; slo(top)=lo;  shi(top)=p-1; end if
         end if
      end do
   end subroutine

   ! --------------------------------------------------------------------------
   ! build_kdtree -- iterative balanced k-d tree construction.
   !
   !   pts(max_dim, n_pts) : full point array (not modified)
   !   idx(n)              : working index array (rearranged in-place)
   !   n                   : number of points (0 = empty tree)
   !   k                   : dimensionality (1..max_dim)
   !
   ! Returns the pool index of the root node (0 if n = 0).
   !
   ! Algorithm -- iterative DFS using five parallel integer arrays as a stack.
   ! Each stack entry records the subproblem: index range [lo,hi] in idx,
   ! current depth (determines splitting axis), parent node index, and which
   ! child slot (0=left, 1=right) to write the new node index into.
   !
   ! At each iteration:
   !   axis = mod(depth, k) + 1
   !   sort idx(lo:hi) along that axis
   !   median = lo + (hi-lo)/2  (lower median, 1-based in the full idx array)
   !   create a node for idx(median), wire it into the parent's child slot
   !   push left  sub-problem [lo,      median-1] if non-empty
   !   push right sub-problem [median+1, hi     ] if non-empty
   !
   ! Stack depth is O(log n); SMAX=64 handles up to 2^63 points.
   ! --------------------------------------------------------------------------
   integer function build_kdtree(pts, n_pts, idx, n, k) result(root_nd)
      integer, intent(in)    :: n_pts, n, k
      real,    intent(in)    :: pts(max_dim, n_pts)
      integer, intent(inout) :: idx(n)

      integer, parameter :: SMAX = 64
      integer :: st_lo(SMAX), st_hi(SMAX), st_dep(SMAX)
      integer :: st_par(SMAX), st_sid(SMAX)       ! parent node index; child side
      integer :: top, lo, hi, dep, par, sid
      integer :: axis, med, nd

      root_nd = 0
      if (n == 0) return

      top        = 1
      st_lo(top) = 1;  st_hi(top) = n
      st_dep(top)= 0;  st_par(top)= 0;  st_sid(top)= 0

      do while (top > 0)
         lo  = st_lo(top);  hi  = st_hi(top)
         dep = st_dep(top); par = st_par(top);  sid = st_sid(top)
         top = top - 1

         axis = mod(dep, k) + 1
         call qsort(idx(lo:hi), hi - lo + 1, pts, n_pts, axis)
         med  = lo + (hi - lo) / 2          ! median index in full idx array

         nd = alloc_node(pts(:, idx(med)), axis)

         ! Wire this node into the tree
         if (par == 0) then
            root_nd = nd                    ! first node popped is the root
         else if (sid == 0) then
            pool(par)%left  = nd
         else
            pool(par)%right = nd
         end if

         ! Push non-empty child sub-problems (left first so right is on top
         ! and processed next -- keeps the near branch hot in cache)
         if (lo < med) then
            top = top + 1
            st_lo(top) = lo;    st_hi(top) = med - 1
            st_dep(top)= dep+1; st_par(top)= nd;  st_sid(top)= 0
         end if
         if (med < hi) then
            top = top + 1
            st_lo(top) = med+1; st_hi(top) = hi
            st_dep(top)= dep+1; st_par(top)= nd;  st_sid(top)= 1
         end if
      end do
   end function

   ! --------------------------------------------------------------------------
   ! nn_search -- iterative nearest-neighbour search in a k-d tree.
   !
   !   root       : pool index of the tree root (0 = empty tree)
   !   query(k)   : the point being searched for
   !   k          : dimensionality
   !   best_dist2 : squared distance to the current best candidate (updated)
   !   best_idx   : pool index of the current best candidate (updated)
   !   visited    : running count of nodes accessed (updated)
   !
   ! Algorithm -- iterative DFS with pruning, using two parallel stacks:
   !   stk_nd(i)  : node index to visit
   !   stk_pd2(i) : squared distance from query to this subtree's splitting
   !                hyperplane (0.0 for the near subtree, split_diff^2 for far)
   !
   ! At each iteration:
   !   1. Pop (nd, plane_dist2).  If plane_dist2 >= best_dist2, prune.
   !   2. Visit nd: compute distance, update best.
   !   3. Push far  child with plane_dist2 = split_diff^2.
   !      Push near child with plane_dist2 = 0.0 (on top, visited first).
   !   The pruning check at pop time uses the CURRENT best_dist2, so it is
   !   at least as tight as the recursive check at call time.
   !
   ! Stack depth O(log n); SMAX=128 is ample for any practical tree.
   ! --------------------------------------------------------------------------
   subroutine nn_search(root, query, k, best_dist2, best_idx, visited)
      integer, intent(in)    :: root, k
      real,    intent(in)    :: query(k)
      real,    intent(inout) :: best_dist2
      integer, intent(inout) :: best_idx, visited

      integer, parameter :: SMAX = 128
      integer :: stk_nd(SMAX)
      real    :: stk_pd2(SMAX)             ! lower-bound dist^2 for each entry
      integer :: top, nd, near_child, far_child, i
      real    :: d2, split_diff

      if (root == 0) return

      top          = 1
      stk_nd(top)  = root
      stk_pd2(top) = 0.0

      do while (top > 0)
         nd   = stk_nd(top)
         top  = top - 1

         if (nd == 0) cycle
         if (stk_pd2(top + 1) >= best_dist2) cycle   ! prune: can't beat current best

         ! ---- Visit this node -----------------------------------------------
         visited = visited + 1

         d2 = 0.0
         do i = 1, k
            d2 = d2 + (query(i) - pool(nd)%coords(i))**2
         end do
         if (d2 < best_dist2) then
            best_dist2 = d2
            best_idx   = nd
         end if

         ! ---- Choose near / far children ------------------------------------
         split_diff = query(pool(nd)%axis) - pool(nd)%coords(pool(nd)%axis)
         if (split_diff <= 0.0) then
            near_child = pool(nd)%left
            far_child  = pool(nd)%right
         else
            near_child = pool(nd)%right
            far_child  = pool(nd)%left
         end if

         ! Push far child first (lower in stack), near child on top.
         ! Near child always has plane_dist2 = 0 (query is on that side).
         ! Far child has plane_dist2 = split_diff^2; pruned at pop time if
         ! best_dist2 has improved enough since this push.
         if (far_child /= 0) then
            top = top + 1
            stk_nd(top)  = far_child
            stk_pd2(top) = split_diff**2
         end if
         if (near_child /= 0) then
            top = top + 1
            stk_nd(top)  = near_child
            stk_pd2(top) = 0.0
         end if
      end do
   end subroutine

end module kdtree_mod

! ==============================================================================
! Program : kd_demo
! Purpose : Demonstrates k-d tree construction and nearest-neighbour search on
!           two datasets.
!
! Test 1 -- Wikipedia 2-D example:
!   Points : (2,3) (5,4) (9,6) (4,7) (8,1) (7,2)
!   Query  : (9, 2)
!   Expected: nearest = (8,1), distance = sqrt(2) â‰ˆ 1.4142
!
! Test 2 -- 1000 random 3-D points uniformly distributed in [0,1)^3:
!   Query  : a random point also drawn from [0,1)^3
!   A brute-force linear scan verifies the k-d tree result.
!
! Test 3 -- 400000 random 3-D points (same setup as Test 2, larger scale):
!   Timings for tree build, k-d tree search, and brute-force search are
!   reported so the O(log n) vs O(n) scaling can be observed directly.
!
! Output fields for each case:
!   Searched for    -- the query point
!   Nearest neighbor -- the closest point found in the tree
!   Distance        -- Euclidean distance from query to nearest neighbor
!   Nodes visited   -- number of tree nodes accessed during the search
! ==============================================================================
program kd_demo
   use kdtree_mod
   implicit none

   integer, parameter :: N2 = 6      ! Wikipedia 2-D example: 6 points
   integer, parameter :: N3 = 1000  ! random 3-D test: 1000 points
   integer, parameter :: N4 = 400000 ! large random 3-D test: 400000 points

   ! pts3, pts4, and idx are allocatable so they land on the heap rather than
   ! the stack.  Under -O3 gfortran can stack-allocate program-unit locals;
   ! pts4 alone is 4.8 MB and idx is 1.6 MB, which together exhaust the
   ! typical 8 MB Windows stack long before any computation begins.
   real    :: pts2(max_dim, N2)          ! 2-D points (tiny -- stack is fine)
   real,    allocatable :: pts3(:,:)     ! 3-D random points (1000)
   real,    allocatable :: pts4(:,:)     ! 3-D random points (400000)
   integer, allocatable :: idx(:)        ! working index scratch for builder

   integer :: root                  ! pool index of tree root
   integer :: best_idx              ! pool index of nearest neighbour found
   integer :: visited               ! nodes visited during NN search
   integer :: i
   integer :: t0, t1, t2, t3, rate ! system_clock variables for timing

   real    :: query(max_dim)        ! search point
   real    :: best_dist2            ! squared distance to best candidate
   real    :: best_dist             ! Euclidean distance (sqrt of above)

   ! Allocate all large arrays on the heap up front
   allocate(pts3(max_dim, N3))
   allocate(pts4(max_dim, N4))
   allocate(idx(max(N2, N4)))

   ! Seed the RNG from the system clock so results differ each run
   call set_rng_seed()

   ! ==========================================================================
   ! Test 1: Wikipedia 2-D example
   ! ==========================================================================
   pts2 = 0.0                        ! zero-fill; unused 3rd coord stays 0
   pts2(1,1) = 2.0;  pts2(2,1) = 3.0
   pts2(1,2) = 5.0;  pts2(2,2) = 4.0
   pts2(1,3) = 9.0;  pts2(2,3) = 6.0
   pts2(1,4) = 4.0;  pts2(2,4) = 7.0
   pts2(1,5) = 8.0;  pts2(2,5) = 1.0
   pts2(1,6) = 7.0;  pts2(2,6) = 2.0

   call pool_reset(N2)
   idx(1:N2) = [(i, i = 1, N2)]
   root = build_kdtree(pts2, N2, idx(1:N2), N2, 2)

   query    = 0.0
   query(1) = 9.0
   query(2) = 2.0

   best_dist2 = huge(best_dist2)
   best_idx   = 0
   visited    = 0
   call nn_search(root, query(1:2), 2, best_dist2, best_idx, visited)
   best_dist = sqrt(best_dist2)

   write(*, '(a)')         '--- Wikipedia 2-D Example ---'
   write(*, '(a,2f6.1)')   'Searched for:      ', query(1:2)
   write(*, '(a,2f6.1)')   'Nearest neighbor:  ', pool(best_idx)%coords(1:2)
   write(*, '(a,f9.4)')    'Distance:          ', best_dist
   write(*, '(a,i0)')      'Nodes visited:     ', visited

   ! ==========================================================================
   ! Test 2: 1000 random 3-D points in the unit cube [0,1)^3
   ! ==========================================================================
   call random_number(pts3)          ! all 3 * 1000 values filled uniformly

   call pool_reset(N3)
   idx(1:N3) = [(i, i = 1, N3)]
   root = build_kdtree(pts3, N3, idx(1:N3), N3, 3)

   call random_number(query(1:3))    ! query point also in [0,1)^3

   best_dist2 = huge(best_dist2)
   best_idx   = 0
   visited    = 0
   call nn_search(root, query(1:3), 3, best_dist2, best_idx, visited)
   best_dist = sqrt(best_dist2)

   write(*, '(a)')         ''
   write(*, '(a)')         '--- 1000 Random 3-D Points (unit cube) ---'
   write(*, '(a,3f9.5)')   'Searched for:      ', query(1:3)
   write(*, '(a,3f9.5)')   'Nearest neighbor:  ', pool(best_idx)%coords(1:3)
   write(*, '(a,f9.6)')    'Distance:          ', best_dist
   write(*, '(a,i0)')      'Nodes visited:     ', visited

   ! Brute-force linear scan to verify correctness
   call brute_force_nn(pts3, N3, query(1:3), 3)

   ! ==========================================================================
   ! Test 3: 400000 random 3-D points in the unit cube [0,1)^3, with timing.
   ! Three phases are timed separately:
   !   build  -- construct the k-d tree from 400000 points
   !   search -- single nearest-neighbour query via k-d tree
   !   brute  -- exhaustive O(n) scan for the same query (reference)
   ! ==========================================================================
   call random_number(pts4)          ! 3 * 400000 uniform values in [0,1)

   ! -- Build -----------------------------------------------------------------
   call pool_reset(N4)
   idx(1:N4) = [(i, i = 1, N4)]
   call system_clock(t0, rate)
   root = build_kdtree(pts4, N4, idx(1:N4), N4, 3)
   call system_clock(t1)

   ! -- k-d tree search -------------------------------------------------------
   call random_number(query(1:3))

   best_dist2 = huge(best_dist2)
   best_idx   = 0
   visited    = 0
   call system_clock(t2)
   call nn_search(root, query(1:3), 3, best_dist2, best_idx, visited)
   call system_clock(t3)
   best_dist = sqrt(best_dist2)

   write(*, '(a)')         ''
   write(*, '(a)')         '--- 400000 Random 3-D Points (unit cube) ---'
   write(*, '(a,f9.4,a)')  'Build time:        ', real(t1-t0)/real(rate)*1000.0, ' ms'
   write(*, '(a,3f9.5)')   'Searched for:      ', query(1:3)
   write(*, '(a,3f9.5)')   'Nearest neighbor:  ', pool(best_idx)%coords(1:3)
   write(*, '(a,f9.6)')    'Distance:          ', best_dist
   write(*, '(a,i0)')      'Nodes visited:     ', visited
   write(*, '(a,f9.4,a)')  'Search time (k-d): ', real(t3-t2)/real(rate)*1e6, ' us'

   ! -- Brute-force (timed) ---------------------------------------------------
   call system_clock(t2)
   call brute_force_nn(pts4, N4, query(1:3), 3)
   call system_clock(t3)
   write(*, '(a,f12.4,a)')  'Search time (BF):  ', real(t3-t2)/real(rate)*1e6, ' us'

contains

   ! --------------------------------------------------------------------------
   ! set_rng_seed -- seed Fortran's intrinsic RNG from the system clock.
   ! Each element of the seed array is shifted by 37*(i-1) so adjacent
   ! elements differ, reducing the chance of a degenerate seed state.
   ! --------------------------------------------------------------------------
   subroutine set_rng_seed()
      integer :: clock, sz, j
      integer, allocatable :: seed(:)
      call system_clock(clock)
      call random_seed(size=sz)
      allocate(seed(sz))
      seed = clock + 37 * [(j - 1, j = 1, sz)]
      call random_seed(put=seed)
      deallocate(seed)
   end subroutine

   ! --------------------------------------------------------------------------
   ! brute_force_nn -- O(n) exhaustive nearest-neighbour scan.
   ! Used to verify that the k-d tree search returned the correct answer.
   ! --------------------------------------------------------------------------
   subroutine brute_force_nn(pts, n, query, k)
      integer, intent(in) :: n, k
      real,    intent(in) :: pts(max_dim, n), query(k)
      integer :: i, j, best
      real    :: d2, best_d2
      best_d2 = huge(best_d2)
      best    = 0
      do i = 1, n
         d2 = 0.0
         do j = 1, k
            d2 = d2 + (query(j) - pts(j, i))**2
         end do
         if (d2 < best_d2) then
            best_d2 = d2
            best    = i
         end if
      end do
      write(*, '(a,3f9.5)') 'Brute-force check: ', pts(1:3, best)
      write(*, '(a,f9.6)')  'Brute-force dist:  ', sqrt(best_d2)
   end subroutine

end program kd_demo
