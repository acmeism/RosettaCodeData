program boruvka_mst
    implicit none

    ! Constants
    integer, parameter :: MAX_VERTICES = 100
    integer, parameter :: MAX_EDGES = 1000
    real(8), parameter :: INVALID_WEIGHT = -1.0d0

    ! Edge type
    type :: edge_type
        integer :: u, v
        real(8) :: weight
    end type edge_type

    ! Graph type
    type :: graph_type
        type(edge_type) :: edges(MAX_EDGES)
        integer :: vertex_count
        integer :: edge_count
    end type graph_type

    ! Variables
    type(graph_type) :: graph

    ! Initialize graph and run algorithm
    call init_graph(graph, 4)
    call add_edge(graph, 0, 1, 10.0d0)
    call add_edge(graph, 0, 2, 6.0d0)
    call add_edge(graph, 0, 3, 5.0d0)
    call add_edge(graph, 1, 3, 15.0d0)
    call add_edge(graph, 2, 3, 4.0d0)

    call boruvka_minimum_spanning_tree(graph)

contains

    ! Initialize graph with given vertex count
    subroutine init_graph(g, vertex_count)
        type(graph_type), intent(out) :: g
        integer, intent(in) :: vertex_count

        g%vertex_count = vertex_count
        g%edge_count = 0
    end subroutine init_graph

    ! Add edge to graph
    subroutine add_edge(g, u, v, weight)
        type(graph_type), intent(inout) :: g
        integer, intent(in) :: u, v
        real(8), intent(in) :: weight

        g%edge_count = g%edge_count + 1
        g%edges(g%edge_count)%u = u
        g%edges(g%edge_count)%v = v
        g%edges(g%edge_count)%weight = weight
    end subroutine add_edge

    ! Find root of vertex using path compression
    recursive function find_root(parent, vertex) result(root)
        integer, intent(inout) :: parent(0:)
        integer, intent(in) :: vertex
        integer :: root

        if (parent(vertex) /= vertex) then
            parent(vertex) = find_root(parent, parent(vertex))
        end if

        root = parent(vertex)
    end function find_root

    ! Union two sets by rank
    subroutine union_sets(parent, rank, u, v)
        integer, intent(inout) :: parent(0:), rank(0:)
        integer, intent(in) :: u, v
        integer :: u_root, v_root

        u_root = find_root(parent, u)
        v_root = find_root(parent, v)

        if (rank(u_root) < rank(v_root)) then
            parent(u_root) = v_root
        else if (rank(u_root) > rank(v_root)) then
            parent(v_root) = u_root
        else
            parent(v_root) = u_root
            rank(u_root) = rank(u_root) + 1
        end if
    end subroutine union_sets

    ! Borůvka's minimum spanning tree algorithm
    subroutine boruvka_minimum_spanning_tree(g)
        type(graph_type), intent(in) :: g
        integer :: parent(0:g%vertex_count-1)
        integer :: rank(0:g%vertex_count-1)
        type(edge_type) :: cheapest(0:g%vertex_count-1)
        integer :: tree_count
        real(8) :: minimum_spanning_tree_weight
        integer :: i, u, v, vertex
        real(8) :: weight
        integer :: index1, index2

        ! Initialize parent array (each vertex is its own parent initially)
        do i = 0, g%vertex_count - 1
            parent(i) = i
            rank(i) = 0
        end do

        ! Initialize cheapest edges array
        do i = 0, g%vertex_count - 1
            cheapest(i)%u = -1
            cheapest(i)%v = -1
            cheapest(i)%weight = INVALID_WEIGHT
        end do

        tree_count = g%vertex_count
        minimum_spanning_tree_weight = 0.0d0

        ! Combine trees until all are combined into single MST
        do while (tree_count > 1)
            ! Reset cheapest edges for this iteration
            do i = 0, g%vertex_count - 1
                cheapest(i)%u = -1
                cheapest(i)%v = -1
                cheapest(i)%weight = INVALID_WEIGHT
            end do

            ! Find cheapest edge for each tree
            do i = 1, g%edge_count
                u = g%edges(i)%u
                v = g%edges(i)%v
                weight = g%edges(i)%weight

                index1 = find_root(parent, u)
                index2 = find_root(parent, v)

                ! If vertices belong to different trees
                if (index1 /= index2) then
                    ! Update cheapest edge for first tree
                    if (cheapest(index1)%weight == INVALID_WEIGHT .or. &
                        cheapest(index1)%weight > weight) then
                        cheapest(index1)%u = u
                        cheapest(index1)%v = v
                        cheapest(index1)%weight = weight
                    end if

                    ! Update cheapest edge for second tree
                    if (cheapest(index2)%weight == INVALID_WEIGHT .or. &
                        cheapest(index2)%weight > weight) then
                        cheapest(index2)%u = u
                        cheapest(index2)%v = v
                        cheapest(index2)%weight = weight
                    end if
                end if
            end do

            ! Add cheapest edges to MST
            do vertex = 0, g%vertex_count - 1
                if (cheapest(vertex)%weight /= INVALID_WEIGHT) then
                    u = cheapest(vertex)%u
                    v = cheapest(vertex)%v
                    weight = cheapest(vertex)%weight

                    index1 = find_root(parent, u)
                    index2 = find_root(parent, v)

                    if (index1 /= index2) then
                        minimum_spanning_tree_weight = minimum_spanning_tree_weight + weight
                        call union_sets(parent, rank, index1, index2)
                        write(*,'(A,I0,A,I0,A,F0.1,A)') 'Edge ', u, '--', v, &
                            ' with weight ', weight, ' is included in the minimum spanning tree'
                        tree_count = tree_count - 1
                    end if
                end if
            end do
        end do

        write(*,*)
        write(*,'(A,F0.1)') 'Weight of minimum spanning tree is ', minimum_spanning_tree_weight
    end subroutine boruvka_minimum_spanning_tree

end program boruvka_mst
