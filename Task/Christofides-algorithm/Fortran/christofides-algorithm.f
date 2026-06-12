module christofides_tsp
   implicit none
   integer, parameter :: dp = kind(1.0d0)

contains

   subroutine christofides(ncity, iorder, x, y)
      integer, intent(in) :: ncity
      integer, intent(inout) :: iorder(ncity)
      real(kind=dp), intent(in) :: x(ncity), y(ncity)

      real(kind=dp) :: dist(ncity, ncity)
      integer :: mst_edges(ncity - 1, 2)
      integer :: odd_vertices(ncity), nodd
      integer :: matching(ncity / 2, 2), nmatch
      integer :: multigraph(ncity, ncity)
      integer :: euler_tour(4 * ncity), ntour
      integer :: hamilton_tour(ncity)
      integer :: i, j

      ! Compute distance matrix
        do i = 1, ncity
              do j = 1, ncity   ! includes i == j ? hypot(0,0) = 0.0
                 dist(i, j) = hypot(x(i) - x(j), y(i) - y(j))
              end do
        end do

      ! 1. Build minimum spanning tree
      call prim_mst(ncity, dist, mst_edges)

      ! 2. Find odd-degree vertices in MST
      call find_odd_vertices(ncity, mst_edges, odd_vertices, nodd)

      ! 3. Minimum weight perfect matching on odd vertices
      call min_weight_matching_improved(nodd, odd_vertices, dist, ncity, matching, nmatch)

      ! 4. Combine MST and matching to form Eulerian multigraph
      call build_multigraph(ncity, mst_edges, nodd, odd_vertices, matching, nmatch, multigraph)

      ! 5. Find Eulerian tour (FIXED)
      call find_euler_tour_hierholzer(ncity, multigraph, euler_tour, ntour)

      ! 6. Convert to Hamiltonian tour by proper shortcutting
      call euler_to_hamilton_fixed(ncity, euler_tour, ntour, hamilton_tour)

      ! Update iorder
      iorder = hamilton_tour

      ! 7. CRITICAL: Refine with 2-opt (Christofides is just construction heuristic)
      call two_opt_refinement(iorder, dist, ncity)

   end subroutine christofides

   ! 2-opt refinement for Christofides output
   subroutine two_opt_refinement(route, dist, n)
      integer, intent(inout) :: route(n)
      real(kind=dp), intent(in) :: dist(n, n)
      integer, intent(in) :: n

      integer :: i, j, k, temp, a, b, c, d
      real(kind=dp) :: delta
      logical :: improved

      do
         improved = .false.

         do i = 1, n - 2
            do j = i + 2, n
               a = route(i)
               b = route(i + 1)
               c = route(j)
               if (j < n) then
                  d = route(j + 1)
               else
                  d = route(1)
               end if

               delta = dist(a, c) + dist(b, d) - dist(a, b) - dist(c, d)

               if (delta < -1.0e-6_dp) then
                  ! Reverse segment from i+1 to j
                  do k = 0, (j - i - 1) / 2
                     temp = route(i + 1 + k)
                     route(i + 1 + k) = route(j - k)
                     route(j - k) = temp
                  end do
                  improved = .true.
               end if
            end do
         end do

         if (.not.improved) exit
      end do
   end subroutine two_opt_refinement

   subroutine prim_mst(n, dist, edges)
      integer, intent(in) :: n
      real(kind=dp), intent(in) :: dist(n, n)
      integer, intent(out) :: edges(n - 1, 2)

      logical :: in_tree(n)
      real(kind=dp) :: min_cost(n)
      integer :: parent(n)
      integer :: i, j, u, nedges
      real(kind=dp) :: min_val

      in_tree = .false.
      min_cost = huge(1.0_dp)
      parent = 0

      in_tree(1) = .true.
      min_cost(1) = 0.0_dp

      do i = 1, n
         if (i /= 1) then
            min_cost(i) = dist(1, i)
            parent(i) = 1
         end if
      end do

      nedges = 0
      do i = 1, n - 1
         min_val = huge(1.0_dp)
         u = -1
         do j = 1, n
            if (.not.in_tree(j) .and. min_cost(j) < min_val) then
               min_val = min_cost(j)
               u = j
            end if
         end do

         in_tree(u) = .true.
         nedges = nedges + 1
         edges(nedges, 1) = parent(u)
         edges(nedges, 2) = u

         do j = 1, n
            if (.not.in_tree(j) .and. dist(u, j) < min_cost(j)) then
               min_cost(j) = dist(u, j)
               parent(j) = u
            end if
         end do
      end do
   end subroutine prim_mst

   subroutine find_odd_vertices(n, edges, odd_verts, nodd)
      integer, intent(in) :: n
      integer, intent(in) :: edges(n - 1, 2)
      integer, intent(out) :: odd_verts(n), nodd

      integer :: degree(n), i

      degree = 0
      do i = 1, n - 1
         degree(edges(i, 1)) = degree(edges(i, 1)) + 1
         degree(edges(i, 2)) = degree(edges(i, 2)) + 1
      end do

      nodd = 0
      do i = 1, n
         if (mod(degree(i), 2) == 1) then
            nodd = nodd + 1
            odd_verts(nodd) = i
         end if
      end do
   end subroutine find_odd_vertices

   ! Improved greedy matching with 2-opt refinement
   subroutine min_weight_matching_improved(nodd, odd_verts, dist, n, matching, nmatch)
      integer, intent(in) :: nodd, n
      integer, intent(in) :: odd_verts(nodd)
      real(kind=dp), intent(in) :: dist(n, n)
      integer, intent(out) :: matching(nodd / 2, 2), nmatch

      real(kind=dp) :: pair_dist(nodd, nodd)
      logical :: used(nodd)
      integer :: i, j, best_i, best_j
      real(kind=dp) :: min_dist, d

      ! Build distance matrix for odd vertices only
      do i = 1, nodd
         do j = 1, nodd
            pair_dist(i, j) = dist(odd_verts(i), odd_verts(j))
         end do
      end do

      ! Greedy matching
      used = .false.
      nmatch = 0

      do while (count(.not.used) >= 2)
         min_dist = huge(1.0_dp)
         best_i = -1
         best_j = -1

         do i = 1, nodd
            if (used(i)) cycle
            do j = i + 1, nodd
               if (used(j)) cycle
               d = pair_dist(i, j)
               if (d < min_dist) then
                  min_dist = d
                  best_i = i
                  best_j = j
               end if
            end do
         end do

         if (best_i > 0) then
            nmatch = nmatch + 1
            matching(nmatch, 1) = odd_verts(best_i)
            matching(nmatch, 2) = odd_verts(best_j)
            used(best_i) = .true.
            used(best_j) = .true.
         else
            exit
         end if
      end do

      ! 2-opt style refinement on matching
      call refine_matching(nmatch, matching, dist, n)

   end subroutine min_weight_matching_improved

   ! Refine matching with simple swaps
   subroutine refine_matching(nmatch, matching, dist, n)
      integer, intent(in) :: nmatch, n
      integer, intent(inout) :: matching(nmatch, 2)
      real(kind=dp), intent(in) :: dist(n, n)

      integer :: i, j, a1, a2, b1, b2, iter
      real(kind=dp) :: old_cost, new_cost
      logical :: improved

      do iter = 1, 10 ! Limited iterations
         improved = .false.

         do i = 1, nmatch - 1
            do j = i + 1, nmatch
               a1 = matching(i, 1)
               a2 = matching(i, 2)
               b1 = matching(j, 1)
               b2 = matching(j, 2)

               old_cost = dist(a1, a2) + dist(b1, b2)
               new_cost = dist(a1, b1) + dist(a2, b2)

               if (new_cost < old_cost - 1.0e-9_dp) then
                  ! Swap: (a1,a2) + (b1,b2) -> (a1,b1) + (a2,b2)
                  matching(i, 2) = b1
                  matching(j, 1) = a2
                  improved = .true.
               end if

               ! Try other swap
               new_cost = dist(a1, b2) + dist(a2, b1)
               if (new_cost < old_cost - 1.0e-9_dp) then
                  ! Swap: (a1,a2) + (b1,b2) -> (a1,b2) + (a2,b1)
                  matching(i, 2) = b2
                  matching(j, 2) = a2
                  improved = .true.
               end if
            end do
         end do

         if (.not.improved) exit
      end do
   end subroutine refine_matching

   subroutine build_multigraph(n, mst_edges, nodd, odd_verts, matching, nmatch, graph)
      integer, intent(in) :: n, nodd, nmatch
      integer, intent(in) :: mst_edges(n - 1, 2)
      integer, intent(in) :: odd_verts(nodd), matching(nmatch, 2)
      integer, intent(out) :: graph(n, n)
      integer :: i

      graph = 0

      do i = 1, n - 1
         graph(mst_edges(i, 1), mst_edges(i, 2)) = graph(mst_edges(i, 1), mst_edges(i, 2)) + 1
         graph(mst_edges(i, 2), mst_edges(i, 1)) = graph(mst_edges(i, 2), mst_edges(i, 1)) + 1
      end do

      do i = 1, nmatch
         graph(matching(i, 1), matching(i, 2)) = graph(matching(i, 1), matching(i, 2)) + 1
         graph(matching(i, 2), matching(i, 1)) = graph(matching(i, 2), matching(i, 1)) + 1
      end do
   end subroutine build_multigraph

   ! Hierholzer's algorithm with proper edge selection
   subroutine find_euler_tour_hierholzer(n, graph, tour, ntour)
      integer, intent(in) :: n
      integer, intent(inout) :: graph(n, n)
      integer, intent(out) :: tour(4 * n), ntour

      integer :: stack(4 * n), top
      integer :: curr, next, i, edge_count
      integer :: temp_graph(n, n)
      real(kind=dp) :: rand

      temp_graph = graph
      ntour = 0
      top = 0
      curr = 1

      do while (.true.)
         ! Count available edges from current vertex
         edge_count = 0
         do i = 1, n
            edge_count = edge_count + temp_graph(curr, i)
         end do

         if (edge_count > 0) then
            ! Pick next edge (choose randomly to avoid bias)
            call random_number(rand)
            edge_count = int(rand * edge_count) + 1

            next = 0
            do i = 1, n
               if (temp_graph(curr, i) > 0) then
                  edge_count = edge_count - temp_graph(curr, i)
                  if (edge_count <= 0) then
                     next = i
                     exit
                  end if
               end if
            end do

            if (next == 0) next = 1 ! Fallback

            ! Push current onto stack and traverse edge
            top = top + 1
            stack(top) = curr
            temp_graph(curr, next) = temp_graph(curr, next) - 1
            temp_graph(next, curr) = temp_graph(next, curr) - 1
            curr = next
         else
            ! No more edges, add to tour and backtrack
            ntour = ntour + 1
            tour(ntour) = curr
            if (top == 0) exit
            curr = stack(top)
            top = top - 1
         end if
      end do
   end subroutine find_euler_tour_hierholzer

   ! Proper shortcutting preserving tour structure
   subroutine euler_to_hamilton_fixed(n, euler, ntour, hamilton)
      integer, intent(in) :: n, ntour
      integer, intent(in) :: euler(ntour)
      integer, intent(out) :: hamilton(n)

      logical :: visited(n)
      integer :: i, nham, start_pos, pos

      visited = .false.
      nham = 0

      ! Find position of city 1 in Euler tour
      start_pos = 1
      do i = 1, ntour
         if (euler(i) == 1) then
            start_pos = i
            exit
         end if
      end do

      ! Walk from city 1, skip repeats
      do i = 0, ntour - 1
         pos = mod(start_pos + i - 1, ntour) + 1
         if (.not.visited(euler(pos))) then
            nham = nham + 1
            hamilton(nham) = euler(pos)
            visited(euler(pos)) = .true.
            if (nham == n) exit
         end if
      end do

      ! Ensure we have exactly n cities
      if (nham /= n) then
         print *, 'WARNING: Hamilton tour has', nham, 'cities, expected', n
      end if
   end subroutine euler_to_hamilton_fixed

end module christofides_tsp

