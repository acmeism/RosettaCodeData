module floyd_warshall_algorithm

  use, intrinsic :: ieee_arithmetic

  implicit none

  integer, parameter :: floating_point_kind = &
       & ieee_selected_real_kind (6, 37)
  integer, parameter :: fpk = floating_point_kind

  integer, parameter :: nil_vertex = 0

  type :: edge
     integer :: u
     real(kind = fpk) :: weight
     integer :: v
  end type edge

  type :: edge_list
     type(edge), allocatable :: element(:)
  end type edge_list

contains

  subroutine make_example_graph (edges)
    type(edge_list), intent(out) :: edges

    allocate (edges%element(1:5))
    edges%element(1) = edge (1, -2.0, 3)
    edges%element(2) = edge (3, +2.0, 4)
    edges%element(3) = edge (4, -1.0, 2)
    edges%element(4) = edge (2, +4.0, 1)
    edges%element(5) = edge (2, +3.0, 3)
  end subroutine make_example_graph

  function find_max_vertex (edges) result (n)
    type(edge_list), intent(in) :: edges
    integer n

    integer i

    n = 1
    do i = lbound (edges%element, 1), ubound (edges%element, 1)
       n = max (n, edges%element(i)%u)
       n = max (n, edges%element(i)%v)
    end do
  end function find_max_vertex

  subroutine floyd_warshall (edges, max_vertex, distance, next_vertex)

    type(edge_list), intent(in) :: edges
    integer, intent(out) :: max_vertex
    real(kind = fpk), allocatable, intent(out) :: distance(:,:)
    integer, allocatable, intent(out) :: next_vertex(:,:)

    integer :: n
    integer :: i, j, k
    integer :: u, v
    real(kind = fpk) :: dist_ikj
    real(kind = fpk) :: infinity

    n = find_max_vertex (edges)
    max_vertex = n

    allocate (distance(1:n, 1:n))
    allocate (next_vertex(1:n, 1:n))

    infinity = ieee_value (1.0_fpk,  ieee_positive_inf)

    ! Initialize.

    do i = 1, n
       do j = 1, n
          distance(i, j) = infinity
          next_vertex (i, j) = nil_vertex
       end do
    end do
    do i = lbound (edges%element, 1), ubound (edges%element, 1)
       u = edges%element(i)%u
       v = edges%element(i)%v
       distance(u, v) = edges%element(i)%weight
       next_vertex(u, v) = v
    end do
    do i = 1, n
       distance(i, i) = 0.0_fpk ! Distance from a vertex to itself.
       next_vertex(i, i) = i
    end do

    ! Perform the algorithm.

    do k = 1, n
       do i = 1, n
          do j = 1, n
             dist_ikj = distance(i, k) + distance(k, j)
             if (dist_ikj < distance(i, j)) then
                distance(i, j) = dist_ikj
                next_vertex(i, j) = next_vertex(i, k)
             end if
          end do
       end do
    end do

  end subroutine floyd_warshall

  subroutine print_path (next_vertex, u, v)
    integer, intent(in) :: next_vertex(:,:)
    integer, intent(in) :: u, v

    integer i

    if (next_vertex(u, v) /= nil_vertex) then
       i = u
       write (*, '(I0)', advance = 'no') i
       do while (i /= v)
          i = next_vertex(i, v)
          write (*, '('' -> '', I0)', advance = 'no') i
       end do
    end if
  end subroutine print_path

end module floyd_warshall_algorithm

program floyd_warshall_task

  use, non_intrinsic :: floyd_warshall_algorithm

  implicit none

  type(edge_list) :: example_graph
  integer :: max_vertex
  real(kind = fpk), allocatable :: distance(:,:)
  integer, allocatable :: next_vertex(:,:)
  integer :: u, v

  call make_example_graph (example_graph)
  call floyd_warshall (example_graph, max_vertex, distance, &
       &               next_vertex)

1000 format (1X, I0, ' -> ', I0, 5X, F4.1, 6X)

  write (*, '(''  pair     distance    path'')')
  write (*, '(''---------------------------------------'')')
  do u = 1, max_vertex
     do v = 1, max_vertex
        if (u /= v) then
           write (*, 1000, advance = 'no') u, v, distance(u, v)
           call print_path (next_vertex, u, v)
           write (*, '()', advance = 'yes')
        end if
     end do
  end do

end program floyd_warshall_task
