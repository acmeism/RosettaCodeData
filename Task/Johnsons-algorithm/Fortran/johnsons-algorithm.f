program johnsons_algorithm
    implicit none

    ! Constants
    integer, parameter :: dp = selected_real_kind(15, 307)
    real(dp), parameter :: INF = huge(0.0_dp)
    integer, parameter :: MAX_VERTICES = 100
    integer, parameter :: MAX_EDGES = 1000

    ! Type definitions
    type :: edge_type
        integer :: u, v
        real(dp) :: weight
    end type edge_type

    type :: vertex_weight_type
        integer :: vertex
        real(dp) :: weight
    end type vertex_weight_type

    ! Variables
    integer :: vertex_count, edge_count
    real(dp) :: graph(4, 4)
    real(dp), allocatable :: result(:, :)
    logical :: success
    integer :: i, j

    ! Initialize the test graph
    vertex_count = 4

    ! Initialize all elements to INF
    graph = INF

    ! Set diagonal to 0
    do i = 1, vertex_count
        graph(i, i) = 0.0_dp
    end do

    ! Set the actual edges (converting from 0-based to 1-based indexing)
    graph(1, 2) = -5.0_dp
    graph(1, 3) = 2.0_dp
    graph(1, 4) = 3.0_dp
    graph(2, 3) = 4.0_dp
    graph(3, 4) = 1.0_dp

    ! Allocate result matrix
    allocate(result(vertex_count, vertex_count))

    ! Run Johnson's algorithm
    call run_johnsons_algorithm(graph, vertex_count, result, success)

    ! Print results
    if (success) then
        write(*, '(A)') 'All pairs shortest paths:'
        write(*, '(A)') 'The element (i, j) is the shortest path between vertex i and vertex j.'
        do i = 1, vertex_count
            write(*, '(A)', advance='no') '['
            do j = 1, vertex_count
                if (result(i, j) >= INF * 0.9_dp) then
                    write(*, '(A)', advance='no') 'INF '
                else
                    write(*, '(F8.1)', advance='no') result(i, j)
                    write(*, '(A)', advance='no') ' '
                end if
            end do
            write(*, '(A)') ']'
        end do
    else
        write(*, '(A)') 'A negative cycle was detected in the graph.'
    end if

    deallocate(result)

contains

    subroutine run_johnsons_algorithm(graph_matrix, n_vertices, shortest_paths, success)
        implicit none
        real(dp), intent(in) :: graph_matrix(:, :)
        integer, intent(in) :: n_vertices
        real(dp), intent(out) :: shortest_paths(:, :)
        logical, intent(out) :: success

        type(edge_type) :: original_edges(MAX_EDGES)
        type(edge_type) :: augmented_edges(MAX_EDGES)
        real(dp) :: h_values(n_vertices + 1)
        real(dp) :: values(n_vertices)
        integer :: n_original_edges, n_augmented_edges
        integer :: adjacency_list(n_vertices, n_vertices)
        real(dp) :: adjacency_weights(n_vertices, n_vertices)
        integer :: adjacency_counts(n_vertices)
        integer :: i, j, u
        real(dp) :: reweight
        logical :: bf_success

        success = .true.

        ! Step 0: Build list of edges for the original graph
        n_original_edges = 0
        do i = 1, n_vertices
            do j = 1, n_vertices
                if (i == j) then
                    if (abs(graph_matrix(i, j)) > 1e-10) then
                        write(*, '(A, I0, A, F8.3, A)') 'Warning: graph(', i, ',', i, ') is ', &
                            graph_matrix(i, j), ', expected to be 0.0, resetting it to 0.0'
                    end if
                else if (graph_matrix(i, j) < INF * 0.9_dp) then
                    n_original_edges = n_original_edges + 1
                    original_edges(n_original_edges)%u = i
                    original_edges(n_original_edges)%v = j
                    original_edges(n_original_edges)%weight = graph_matrix(i, j)
                end if
            end do
        end do

        ! Step 1: Form the augmented graph
        n_augmented_edges = n_original_edges
        do i = 1, n_original_edges
            augmented_edges(i) = original_edges(i)
        end do

        ! Add edges from new vertex (n_vertices + 1) to all original vertices
        do i = 1, n_vertices
            n_augmented_edges = n_augmented_edges + 1
            augmented_edges(n_augmented_edges)%u = n_vertices + 1
            augmented_edges(n_augmented_edges)%v = i
            augmented_edges(n_augmented_edges)%weight = 0.0_dp
        end do

        ! Step 2: Run Bellman-Ford algorithm
        call bellman_ford_algorithm(n_vertices + 1, augmented_edges, n_augmented_edges, &
                                   n_vertices + 1, h_values, bf_success)

        if (.not. bf_success) then
            success = .false.
            return
        end if

        ! Extract h values for original vertices
        do i = 1, n_vertices
            values(i) = h_values(i)
        end do

        ! Step 3: Reweight the edges and build adjacency representation
        adjacency_counts = 0
        do i = 1, n_original_edges
            u = original_edges(i)%u
            reweight = original_edges(i)%weight + values(u) - values(original_edges(i)%v)

            adjacency_counts(u) = adjacency_counts(u) + 1
            adjacency_list(u, adjacency_counts(u)) = original_edges(i)%v
            adjacency_weights(u, adjacency_counts(u)) = reweight
        end do

        ! Step 4: Run Dijkstra's algorithm from each vertex
        do u = 1, n_vertices
            call dijkstra_algorithm(n_vertices, adjacency_list, adjacency_weights, &
                                   adjacency_counts, u, values, shortest_paths(u, :))
        end do

    end subroutine run_johnsons_algorithm

    subroutine dijkstra_algorithm(n_vertices, adj_list, adj_weights, adj_counts, &
                                 source_vertex, h_vals, distances)
        implicit none
        integer, intent(in) :: n_vertices
        integer, intent(in) :: adj_list(:, :)
        real(dp), intent(in) :: adj_weights(:, :)
        integer, intent(in) :: adj_counts(:)
        integer, intent(in) :: source_vertex
        real(dp), intent(in) :: h_vals(:)
        real(dp), intent(out) :: distances(:)

        real(dp) :: dist(n_vertices)
        real(dp) :: final_dist(n_vertices)
        logical :: visited(n_vertices)
        integer :: i, j, u, v, min_vertex
        real(dp) :: min_dist, alt_dist

        ! Initialize distances
        dist = INF
        final_dist = INF
        visited = .false.
        dist(source_vertex) = 0.0_dp

        do i = 1, n_vertices
            ! Find minimum distance vertex not yet visited
            min_dist = INF
            min_vertex = -1

            do j = 1, n_vertices
                if (.not. visited(j) .and. dist(j) < min_dist) then
                    min_dist = dist(j)
                    min_vertex = j
                end if
            end do

            if (min_vertex == -1) exit

            u = min_vertex
            visited(u) = .true.

            ! Store final distance (translated back to original graph)
            if (dist(u) >= INF * 0.9_dp) then
                final_dist(u) = INF
            else
                final_dist(u) = dist(u) - h_vals(source_vertex) + h_vals(u)
            end if

            ! Relax edges
            do j = 1, adj_counts(u)
                v = adj_list(u, j)
                if (.not. visited(v)) then
                    alt_dist = dist(u) + adj_weights(u, j)
                    if (alt_dist < dist(v)) then
                        dist(v) = alt_dist
                    end if
                end if
            end do
        end do

        ! Handle remaining vertices
        do i = 1, n_vertices
            if (final_dist(i) >= INF * 0.9_dp .and. dist(i) < INF * 0.9_dp) then
                final_dist(i) = dist(i) - h_vals(source_vertex) + h_vals(i)
            end if
        end do

        distances = final_dist

    end subroutine dijkstra_algorithm

    subroutine bellman_ford_algorithm(n_vertices, edges, n_edges, source_vertex, distances, success)
        implicit none
        integer, intent(in) :: n_vertices, n_edges, source_vertex
        type(edge_type), intent(in) :: edges(:)
        real(dp), intent(out) :: distances(:)
        logical, intent(out) :: success

        integer :: i, j
        logical :: updated
        real(dp) :: new_dist

        success = .true.

        ! Initialize distances
        distances = INF
        distances(source_vertex) = 0.0_dp

        ! Relax edges (n_vertices - 1) times
        do i = 1, n_vertices - 1
            updated = .false.
            do j = 1, n_edges
                if (distances(edges(j)%u) < INF * 0.9_dp) then
                    new_dist = distances(edges(j)%u) + edges(j)%weight
                    if (new_dist < distances(edges(j)%v)) then
                        distances(edges(j)%v) = new_dist
                        updated = .true.
                    end if
                end if
            end do
            if (.not. updated) exit
        end do

        ! Check for negative cycles
        do j = 1, n_edges
            if (distances(edges(j)%u) < INF * 0.9_dp) then
                new_dist = distances(edges(j)%u) + edges(j)%weight
                if (new_dist < distances(edges(j)%v)) then
                    success = .false.
                    return
                end if
            end if
        end do

    end subroutine bellman_ford_algorithm

end program johnsons_algorithm
