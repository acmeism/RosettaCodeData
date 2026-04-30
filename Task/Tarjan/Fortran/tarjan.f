! =============================================================================
! TARJAN'S STRONGLY CONNECTED COMPONENTS -- Fortran implementation
! =============================================================================
!
! DATASET -- USA48 TRAVELLING SALESMAN PROBLEM:
!   The 48 nodes are the classic USA48 benchmark dataset used in Travelling
!   Salesman Problem research.  Each node represents one of the 48 contiguous
!   US state capitals (Alaska and Hawaii excluded).  The coordinates are scaled
!   integer (x, y) positions derived from a map projection, not geographic
!   latitude/longitude.  The dataset appears widely in combinatorial
!   optimisation literature as a standard small-to-medium TSP benchmark.
!
! GRAPH CONSTRUCTION -- DESIGN DECISION:
!   The USA48 dataset supplies node positions only; it carries no explicit
!   edge list.  To obtain a directed graph suitable for demonstrating Tarjan's
!   algorithm, edges are constructed spatially: each city receives a directed
!   edge to its K_EDGES nearest neighbours by Euclidean distance (self-loops
!   excluded).  K_EDGES = 3 was chosen because:
!     - k=1 produces only 1- and 2-node SCCs (too sparse to be interesting).
!     - k=3 gives enough cross-connections to form larger cycles while keeping
!       the graph sparse and the output readable.
!     - Squared distances are used throughout the construction to avoid the
!       cost of sqrt() -- squaring preserves the relative ordering of distances
!       so the nearest-neighbour ranking is identical.
!   Mutual nearest neighbours (city A points to B AND B points to A) are the
!   primary source of 2-city SCCs.  Chains of mutual neighbours occasionally
!   produce larger components.
!
! WHY TARJAN'S ALGORITHM:
!   Tarjan's runs in O(V + E) time -- one DFS pass over the entire graph.
!   Alternative SCC algorithms (Kosaraju's, path-based) also achieve O(V+E)
!   but require either two DFS passes or an extra stack discipline.  Tarjan's
!   single-pass approach makes it straightforward to implement recursively in
!   Fortran, where internal (CONTAINS) subroutines share host variables without
!   needing explicit argument passing for the algorithm state.
!
! TARJAN'S ALGORITHM -- HOW IT WORKS:
!   The DFS assigns two integers to every node v as it is visited:
!
!     disc(v)  -- "discovery time": a counter incremented on each first visit.
!                 Nodes visited earlier have a lower disc value.
!
!     low(v)   -- "low-link": the smallest disc value reachable from v's
!                 DFS subtree via zero or more tree edges followed by at most
!                 one back-edge to a node that is still on the SCC stack.
!                 Intuitively, low(v) measures "how far back" v can reach.
!
!   A separate stack (distinct from the Fortran call stack) holds nodes in
!   the order they were first visited.  Every node is pushed on entry and
!   remains there until its SCC is identified and popped.
!
!   After fully exploring all neighbours of v, two cases arise:
!
!     CASE 1 -- neighbour w not yet visited (tree edge):
!       Recurse into w.  On return, inherit the best low-link:
!         low(v) = min(low(v), low(w))
!       This propagates upward any back-edge that w's subtree can reach.
!
!     CASE 2 -- neighbour w already visited AND still on the SCC stack
!               (back edge or cross edge within the current SCC candidate):
!       w is an ancestor reachable from v, so v and w are mutually reachable
!       and belong to the same SCC.  Update:
!         low(v) = min(low(v), disc(w))
!       Note: disc(w) is used rather than low(w).  Using low(w) is also
!       correct when w is on the stack, but disc(w) is the canonical form
!       and sidesteps a subtle issue with cross-edges between different
!       branches of the DFS tree.
!
!     CASE 3 -- neighbour w already visited AND NOT on the stack:
!       w belongs to a previously completed SCC.  No path from w can lead
!       back into v's current SCC, so w is ignored entirely.
!
!   SCC ROOT DETECTION:
!     After processing all edges of v, check:
!       low(v) == disc(v)
!     This means no edge from v's entire subtree reaches any node discovered
!     before v -- v is the "root" (topmost node) of a complete SCC.
!     Pop the stack down to and including v; every popped node is a member
!     of this SCC.
!
!   COMPLEXITY: each node is pushed and popped exactly once (O(V)); each
!   edge is examined exactly once (O(E)).  Total: O(V + E).
!
! OUTPUT:
!   1. The full directed adjacency list (which city points to which).
!   2. All SCCs with their sizes, listed in reverse topological order
!      (the order Tarjan's naturally produces them).
!   3. A summary of non-trivial SCCs (size > 1) -- the genuine cycles.
! =============================================================================

program tarjan_scc
    use iso_fortran_env, only: real64
    implicit none

    ! Total number of cities in the USA48 TSP dataset
    integer, parameter :: n = 48

    ! Number of directed out-edges per city (nearest-neighbour fan-out).
    ! See header for the rationale behind choosing 3.
    integer, parameter :: k_edges = 3

    ! ---- USA48 node data embedded as compile-time constants -----------------
    ! Column 1: sequential node id (1..48)
    ! Column 2: x coordinate (scaled map projection units)
    ! Column 3: y coordinate (scaled map projection units)
    integer, parameter :: node_id(n) = [ &
         1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16, &
        17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32, &
        33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48 ]

    integer, parameter :: raw_x(n) = [ &
        6734,2233,5530, 401,3082,7608,7573,7265,6898,1112, &
        5468,5989,4706,4612,6347,6107,7611,7462,7732,5900, &
        4483,6101,5199,1633,4307, 675,7555,7541,3177,7352, &
        7545,3245,6426,4608,  23,7248,7762,7392,3484,6271, &
        4985,1916,7280,7509,  10,6807,5185,3023 ]

    integer, parameter :: raw_y(n) = [ &
        1453,  10,1424, 841,1644,4458,3716,1268,1885,2049, &
        2606,2873,2674,2035,2683, 669,5184,3590,4723,3561, &
        3369,1110,2182,2809,2322,1006,4819,3981, 756,4506, &
        2801,3305,3173,1198,2216,3779,4595,2244,2829,2135, &
         140,1569,4899,3239,2676,2993,3258,1942 ]

    ! Working copies as real64 for distance arithmetic
    real(kind=real64) :: cx(n), cy(n)

    ! Directed adjacency list.
    ! adj(i, 1..k_edges) holds the internal array indices (1..n) of the
    ! k nearest neighbours of city i, ordered closest to furthest.
    integer :: adj(n, k_edges)

    ! ---- Tarjan algorithm state ---------------------------------------------
    ! All variables below are accessed by the internal DFS subroutine via
    ! Fortran host association -- no explicit argument passing needed.

    integer :: disc(n)    ! discovery time of each node; -1 = not yet visited
    integer :: low(n)     ! low-link value: lowest disc reachable from subtree
    logical :: stacked(n) ! .true. while the node is sitting on the SCC stack
    integer :: stk(n)     ! the SCC accumulation stack (explicit array-based)
    integer :: stk_top    ! index of the top element of stk; 0 = empty
    integer :: timer      ! global clock; incremented on each node's first visit
    integer :: comp(n)    ! SCC component id for each node (assigned 1, 2, 3...)
    integer :: n_comp     ! running count of completed SCCs

    ! ---- local loop variables -----------------------------------------------
    integer :: i, j, sz
    logical :: found_multi   ! set true if any SCC has more than one member

    ! =========================================================================
    ! INITIALISATION
    ! =========================================================================

    ! Convert integer coordinates to real64 for floating-point distance work
    cx = real(raw_x, real64)
    cy = real(raw_y, real64)

    ! Build the k-nearest-neighbour directed graph from city positions
    call build_knn_graph()

    ! Initialise all Tarjan state before the DFS begins.
    ! disc = -1 is the sentinel meaning "not yet visited".
    disc    = -1
    low     = 0
    stacked = .false.
    stk_top = 0
    timer   = 0
    comp    = 0
    n_comp  = 0

    ! =========================================================================
    ! MAIN DFS LOOP
    ! Launch a DFS from every city that has not yet been visited.
    ! In a strongly connected graph a single call would suffice, but the
    ! k-NN graph may have multiple weakly connected components, so we iterate.
    ! =========================================================================
    do i = 1, n
        if (disc(i) < 0) call dfs(i)
    end do

    ! =========================================================================
    ! OUTPUT
    ! =========================================================================

    ! Print the full directed adjacency list so the graph is transparent
    write(*, '(A)') 'USA48 directed graph  (each city -> its 3 nearest neighbours):'
    write(*, '(A)') '----------------------------------------------------------------'
    do i = 1, n
        write(*, '(A, I3, A)', advance='no') '  Node', node_id(i), '  ->'
        do j = 1, k_edges
            write(*, '(A, I3)', advance='no') '  ', node_id(adj(i, j))
        end do
        write(*, *)
    end do
    write(*, *)

    ! Print every SCC with its size and member node ids
    write(*, '(A, I0, A)') 'Tarjan SCC results: ', n_comp, ' components'
    write(*, '(A)') '----------------------------------------------------------------'
    found_multi = .false.
    do i = 1, n_comp
        sz = count(comp == i)   ! number of cities in this component
        write(*, '(A, I0, A, I0, A)', advance='no') &
            '  SCC ', i, '  size=', sz, '  nodes:'
        do j = 1, n
            if (comp(j) == i) write(*, '(A, I0)', advance='no') '  ', node_id(j)
        end do
        write(*, *)
        if (sz > 1) found_multi = .true.
    end do

    ! Summarise only the non-trivial (cyclic) components
    write(*, *)
    if (found_multi) then
        write(*, '(A)') 'Non-trivial SCCs (size > 1) -- genuine directed cycles:'
        do i = 1, n_comp
            sz = count(comp == i)
            if (sz > 1) then
                write(*, '(A, I0, A)', advance='no') '  SCC ', i, ': nodes'
                do j = 1, n
                    if (comp(j) == i) write(*, '(A, I0)', advance='no') '  ', node_id(j)
                end do
                write(*, *)
            end if
        end do
    else
        write(*, '(A)') 'All SCCs are singletons -- no directed cycles in this k-NN graph.'
    end if

contains

    ! =========================================================================
    ! BUILD_KNN_GRAPH
    !
    ! PURPOSE:
    !   Populate the global adjacency array adj(n, k_edges).
    !   For every city i, find the k_edges other cities closest to it
    !   (by squared Euclidean distance) and store their array indices.
    !
    ! METHOD:
    !   For each source city i:
    !     1. Compute squared distances to all other cities.
    !        Squaring is valid because sqrt() is monotone: the ranking is
    !        preserved and the sqrt computation is avoided entirely.
    !     2. Set dist(i) = HUGE to exclude the self-loop.
    !     3. Run k_edges rounds of "find the minimum unselected distance"
    !        (selection-sort style).  For k=3 and n=48 this is negligible.
    !
    ! COMPLEXITY: O(n^2 * k_edges) -- acceptable for n=48.
    ! =========================================================================
    subroutine build_knn_graph()
        real(kind=real64) :: dist(n)   ! squared distances from current source city
        real(kind=real64) :: dx, dy    ! coordinate differences (scratch)
        real(kind=real64) :: best_d    ! distance to the current nearest candidate
        logical :: used(n)             ! marks neighbours already selected this round
        integer :: i, j, m, best      ! loop indices and index of best candidate

        do i = 1, n

            ! Compute squared distance from city i to every city j
            do j = 1, n
                dx      = cx(i) - cx(j)
                dy      = cy(i) - cy(j)
                dist(j) = dx*dx + dy*dy
            end do

            ! Remove the self-distance so city i never selects itself
            dist(i) = huge(dist(i))

            ! Select the k_edges nearest neighbours one at a time.
            ! 'used' prevents selecting the same city twice.
            used = .false.
            do m = 1, k_edges

                best   = -1
                best_d = huge(best_d)

                ! Linear scan for the closest city not yet picked this round
                do j = 1, n
                    if (.not. used(j) .and. dist(j) < best_d) then
                        best_d = dist(j)
                        best   = j
                    end if
                end do

                adj(i, m) = best      ! record the m-th nearest neighbour
                used(best) = .true.   ! mark it so we skip it next round
            end do

        end do
    end subroutine build_knn_graph

    ! =========================================================================
    ! DFS  (recursive)
    !
    ! PURPOSE:
    !   Depth-first search from city v.  The body implements Tarjan's three
    !   rules (see file header) using variables shared via host association.
    !
    ! ARGUMENTS:
    !   v -- internal array index (1..n) of the city being visited
    !
    ! SIDE EFFECTS (on host variables):
    !   timer, disc, low, stk, stk_top, stacked, comp, n_comp
    ! =========================================================================
    recursive subroutine dfs(v)
        integer, intent(in) :: v
        integer :: e   ! edge index (1..k_edges)
        integer :: w   ! internal index of the neighbour at the other end

        ! --- ENTRY: stamp this node and push it onto the SCC stack -----------

        ! Assign the next available discovery time.
        ! Both disc and low start equal; low may decrease as we explore.
        timer   = timer + 1
        disc(v) = timer
        low(v)  = timer

        ! Push v onto the explicit SCC stack.
        ! The node stays here until its entire SCC is identified.
        stk_top      = stk_top + 1
        stk(stk_top) = v
        stacked(v)   = .true.

        ! --- EDGE EXPLORATION: visit every outgoing edge from v --------------
        do e = 1, k_edges
            w = adj(v, e)   ! the city this edge points to

            if (disc(w) < 0) then
                ! TREE EDGE: w has not been visited yet.
                ! Recurse into w; when it returns, its entire subtree has been
                ! processed and low(w) holds the best back-edge reach from that
                ! subtree.  Pull that value up into v.
                call dfs(w)
                low(v) = min(low(v), low(w))

            else if (stacked(w)) then
                ! BACK EDGE (or forward/cross edge within current SCC):
                ! w is an ancestor of v still sitting on the stack, meaning
                ! there is a cycle: v can reach w and w can reach v (via the
                ! DFS tree path from w down to v).  They must be in the same
                ! SCC.  Record that v can reach as far back as disc(w).
                !
                ! We use disc(w) rather than low(w): low(w) would also be
                ! valid when w is on the stack, but disc(w) is the canonical
                ! Tarjan formulation and is safer against cross-edge anomalies.
                low(v) = min(low(v), disc(w))

            ! else: w is visited but NOT on the stack -- it belongs to a
            ! previously completed SCC.  No node in that SCC can feed back
            ! into v's current SCC, so this edge is silently ignored.
            end if

        end do

        ! --- SCC ROOT CHECK: identify and pop a complete component -----------
        !
        ! After all outgoing edges of v are processed:
        ! If low(v) == disc(v), then no edge from v or anywhere in v's subtree
        ! leads to a node that was discovered before v.  v is therefore the
        ! topmost (root) node of a maximal strongly connected component.
        !
        ! Pop everything off the SCC stack down to and including v.
        ! All popped nodes form exactly one SCC.
        if (low(v) == disc(v)) then
            n_comp = n_comp + 1   ! open a new SCC slot
            do
                w          = stk(stk_top)   ! pop the top node
                stk_top    = stk_top - 1
                stacked(w) = .false.         ! mark it as no longer on the stack
                comp(w)    = n_comp          ! assign it to the current SCC
                if (w == v) exit             ! stop when we reach the root v
            end do
        end if

    end subroutine dfs

end program tarjan_scc
