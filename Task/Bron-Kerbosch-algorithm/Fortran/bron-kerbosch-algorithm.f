program bron_kerbosch_cliques
    implicit none

    ! Maximum number of vertices and cliques
    integer, parameter :: MAX_VERTICES = 100
    integer, parameter :: MAX_CLIQUES = 1000
    integer, parameter :: MAX_EDGES = 1000
    integer, parameter :: MAX_NAME_LEN = 10

    ! Graph representation using adjacency matrix and vertex names
    logical :: adjacency_matrix(MAX_VERTICES, MAX_VERTICES)
    character(len=MAX_NAME_LEN) :: vertex_names(MAX_VERTICES)
    integer :: num_vertices

    ! Cliques storage
    integer :: cliques(MAX_CLIQUES, MAX_VERTICES)
    integer :: clique_sizes(MAX_CLIQUES)
    integer :: num_cliques

    ! Edge structure
    type :: edge_type
        character(len=MAX_NAME_LEN) :: start
        character(len=MAX_NAME_LEN) :: end
    end type edge_type

    ! Local variables
    type(edge_type) :: edges(MAX_EDGES)
    integer :: num_edges
    logical :: current_clique(MAX_VERTICES)
    logical :: candidates(MAX_VERTICES)
    logical :: processed(MAX_VERTICES)
    integer :: i, j

    ! Initialize
    num_vertices = 0
    num_cliques = 0
    num_edges = 12

    ! Initialize adjacency matrix
    adjacency_matrix = .false.

    ! Define edges
    edges(1) = edge_type("a", "b")
    edges(2) = edge_type("b", "a")
    edges(3) = edge_type("a", "c")
    edges(4) = edge_type("c", "a")
    edges(5) = edge_type("b", "c")
    edges(6) = edge_type("c", "b")
    edges(7) = edge_type("d", "e")
    edges(8) = edge_type("e", "d")
    edges(9) = edge_type("d", "f")
    edges(10) = edge_type("f", "d")
    edges(11) = edge_type("e", "f")
    edges(12) = edge_type("f", "e")

    ! Build graph
    call build_graph(edges, num_edges)

    ! Initialize sets for Bron-Kerbosch
    current_clique = .false.
    candidates = .false.
    processed = .false.

    ! Set all vertices as candidates
    do i = 1, num_vertices
        candidates(i) = .true.
    end do

    ! Run Bron-Kerbosch algorithm
    call bron_kerbosch_recursive(current_clique, candidates, processed)

    ! Sort and display cliques
    call sort_cliques()
    call print_cliques()

contains

    ! Function to find vertex index by name
    function find_vertex_index(name) result(index)
        implicit none
        character(len=*), intent(in) :: name
        integer :: index
        integer :: i

        do i = 1, num_vertices
            if (trim(vertex_names(i)) == trim(name)) then
                index = i
                return
            end if
        end do

        ! Add new vertex if not found
        num_vertices = num_vertices + 1
        vertex_names(num_vertices) = trim(name)
        index = num_vertices
    end function find_vertex_index

    ! Subroutine to build graph from edges
    subroutine build_graph(edges_array, n_edges)
        implicit none
        type(edge_type), intent(in) :: edges_array(:)
        integer, intent(in) :: n_edges
        integer :: i, start_idx, end_idx

        do i = 1, n_edges
            start_idx = find_vertex_index(edges_array(i)%start)
            end_idx = find_vertex_index(edges_array(i)%end)
            adjacency_matrix(start_idx, end_idx) = .true.
        end do
    end subroutine build_graph

    ! Count number of true values in logical array
    function count_true(logical_array) result(count)
        implicit none
        logical, intent(in) :: logical_array(:)
        integer :: count
        integer :: i

        count = 0
        do i = 1, num_vertices
            if (logical_array(i)) count = count + 1
        end do
    end function count_true

    ! Find pivot vertex with maximum degree
    function find_pivot(candidates_set, processed_set) result(pivot)
        implicit none
        logical, intent(in) :: candidates_set(:), processed_set(:)
        integer :: pivot
        integer :: i, max_degree, current_degree
        logical :: union_set(MAX_VERTICES)

        ! Create union of candidates and processed
        do i = 1, num_vertices
            union_set(i) = candidates_set(i) .or. processed_set(i)
        end do

        max_degree = -1
        pivot = 1

        do i = 1, num_vertices
            if (union_set(i)) then
                current_degree = count_neighbors(i)
                if (current_degree > max_degree) then
                    max_degree = current_degree
                    pivot = i
                end if
            end if
        end do
    end function find_pivot

    ! Count neighbors of a vertex
    function count_neighbors(vertex) result(count)
        implicit none
        integer, intent(in) :: vertex
        integer :: count
        integer :: i

        count = 0
        do i = 1, num_vertices
            if (adjacency_matrix(vertex, i)) count = count + 1
        end do
    end function count_neighbors

    ! Set difference: result = set_a - set_b
    subroutine set_difference(set_a, set_b, result_set)
        implicit none
        logical, intent(in) :: set_a(:), set_b(:)
        logical, intent(out) :: result_set(:)
        integer :: i

        do i = 1, num_vertices
            result_set(i) = set_a(i) .and. .not. set_b(i)
        end do
    end subroutine set_difference

    ! Set intersection: result = set_a ∩ set_b
    subroutine set_intersection(set_a, set_b, result_set)
        implicit none
        logical, intent(in) :: set_a(:), set_b(:)
        logical, intent(out) :: result_set(:)
        integer :: i

        do i = 1, num_vertices
            result_set(i) = set_a(i) .and. set_b(i)
        end do
    end subroutine set_intersection

    ! Get neighbors of a vertex
    subroutine get_neighbors(vertex, neighbors_set)
        implicit none
        integer, intent(in) :: vertex
        logical, intent(out) :: neighbors_set(:)
        integer :: i

        do i = 1, num_vertices
            neighbors_set(i) = adjacency_matrix(vertex, i)
        end do
    end subroutine get_neighbors

    ! Recursive Bron-Kerbosch algorithm
    recursive subroutine bron_kerbosch_recursive(current_clique_set, candidates_set, processed_set)
        implicit none
        logical, intent(in) :: current_clique_set(:)
        logical, intent(inout) :: candidates_set(:), processed_set(:)

        logical :: new_clique(MAX_VERTICES)
        logical :: new_candidates(MAX_VERTICES)
        logical :: new_processed(MAX_VERTICES)
        logical :: possibles(MAX_VERTICES)
        logical :: neighbors(MAX_VERTICES)
        logical :: pivot_neighbors(MAX_VERTICES)
        integer :: pivot, vertex
        integer :: clique_size, i

        ! If both candidates and processed are empty, we found a maximal clique
        if (count_true(candidates_set) == 0 .and. count_true(processed_set) == 0) then
            clique_size = count_true(current_clique_set)
            if (clique_size > 2) then
                call store_clique(current_clique_set)
            end if
            return
        end if

        ! Find pivot vertex
        pivot = find_pivot(candidates_set, processed_set)
        call get_neighbors(pivot, pivot_neighbors)

        ! Get vertices in candidates that are not neighbors of pivot
        call set_difference(candidates_set, pivot_neighbors, possibles)

        ! For each vertex in possibles
        do vertex = 1, num_vertices
            if (.not. possibles(vertex)) cycle

            ! Create new clique including vertex
            new_clique = current_clique_set
            new_clique(vertex) = .true.

            ! Get neighbors of vertex
            call get_neighbors(vertex, neighbors)

            ! New candidates = candidates ∩ neighbors(vertex)
            call set_intersection(candidates_set, neighbors, new_candidates)

            ! New processed = processed ∩ neighbors(vertex)
            call set_intersection(processed_set, neighbors, new_processed)

            ! Recursive call
            call bron_kerbosch_recursive(new_clique, new_candidates, new_processed)

            ! Move vertex from candidates to processed
            candidates_set(vertex) = .false.
            processed_set(vertex) = .true.
        end do
    end subroutine bron_kerbosch_recursive

    ! Store a clique
    subroutine store_clique(clique_set)
        implicit none
        logical, intent(in) :: clique_set(:)
        integer :: i, size

        if (num_cliques >= MAX_CLIQUES) return

        num_cliques = num_cliques + 1
        size = 0

        do i = 1, num_vertices
            if (clique_set(i)) then
                size = size + 1
                cliques(num_cliques, size) = i
            end if
        end do

        clique_sizes(num_cliques) = size
    end subroutine store_clique

    ! Sort cliques for consistent output
    subroutine sort_cliques()
        implicit none
        integer :: i, j, k
        integer :: temp_clique(MAX_VERTICES)
        integer :: temp_size
        logical :: swap_needed

        ! Simple bubble sort
        do i = 1, num_cliques - 1
            do j = i + 1, num_cliques
                swap_needed = .false.

                ! Compare cliques lexicographically
                do k = 1, min(clique_sizes(i), clique_sizes(j))
                    if (vertex_names(cliques(i, k)) < vertex_names(cliques(j, k))) then
                        exit
                    else if (vertex_names(cliques(i, k)) > vertex_names(cliques(j, k))) then
                        swap_needed = .true.
                        exit
                    end if
                end do

                if (.not. swap_needed .and. clique_sizes(i) > clique_sizes(j)) then
                    swap_needed = .true.
                end if

                if (swap_needed) then
                    ! Swap cliques
                    temp_clique(1:clique_sizes(i)) = cliques(i, 1:clique_sizes(i))
                    temp_size = clique_sizes(i)

                    cliques(i, 1:clique_sizes(j)) = cliques(j, 1:clique_sizes(j))
                    clique_sizes(i) = clique_sizes(j)

                    cliques(j, 1:temp_size) = temp_clique(1:temp_size)
                    clique_sizes(j) = temp_size
                end if
            end do
        end do
    end subroutine sort_cliques

    ! Print all cliques
    subroutine print_cliques()
        implicit none
        integer :: i, j

        write(*, '(A)', advance='no') '['
        do i = 1, num_cliques
            write(*, '(A)', advance='no') '['
            do j = 1, clique_sizes(i)
                write(*, '(A)', advance='no') trim(vertex_names(cliques(i, j)))
                if (j < clique_sizes(i)) write(*, '(A)', advance='no') ', '
            end do
            write(*, '(A)', advance='no') ']'
            if (i < num_cliques) write(*, '(A)', advance='no') ', '
        end do
        write(*, '(A)') ']'
    end subroutine print_cliques

end program bron_kerbosch_cliques
