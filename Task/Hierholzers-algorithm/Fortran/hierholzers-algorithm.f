module circuit_mod
  implicit none

contains

  subroutine printCircuit(adj, n)
    integer, intent(in) :: n
    integer, intent(in) :: adj(0:n-1, n)
    integer :: edge_count(0:n-1)
    integer :: curr_path(n), top
    integer :: circuit(n), circuit_index
    integer :: curr_v, next_v, i

    ! Initialize edge_count
    edge_count = 0
    do i = 0, n-1
      edge_count(i) = count(adj(i, :) /= -1)
    end do

    if (n == 0) return ! empty graph

    ! Initialize stack and circuit
    top = -1
    circuit_index = 0
    curr_v = 0

    do
      if (edge_count(curr_v) > 0) then
        ! Push the vertex
        top = top + 1
        curr_path(top) = curr_v

        ! Find the next vertex using an edge
        next_v = adj(curr_v, edge_count(curr_v))
        edge_count(curr_v) = edge_count(curr_v) - 1

        ! Move to next vertex
        curr_v = next_v
      else
        ! Add to circuit
        circuit_index = circuit_index + 1
        circuit(circuit_index) = curr_v

        ! Back-tracking
        if (top == -1) exit
        curr_v = curr_path(top)
        top = top - 1
      end if
    end do

    ! Print the circuit in reverse
    do i = circuit_index, 1, -1
      write(*, fmt='(i0)', advance='no') circuit(i)
      if (i > 1) write(*, fmt='(" -> ")', advance='no')
    end do
    write(*, *)
  end subroutine printCircuit

end module circuit_mod

program main
  use circuit_mod
  implicit none

  integer :: adj1(0:2, 3), adj2(0:6, 7)
  integer :: i

  ! Initialize adjacency lists
  adj1 = -1
  adj1(0, 1) = 1
  adj1(1, 1) = 2
  adj1(2, 1) = 0

  adj2 = -1
  adj2(0, 1) = 1
  adj2(0, 2) = 6
  adj2(1, 1) = 2
  adj2(2, 1) = 0
  adj2(2, 2) = 3
  adj2(3, 1) = 4
  adj2(4, 1) = 2
  adj2(4, 2) = 5
  adj2(5, 1) = 0
  adj2(6, 1) = 4

  call printCircuit(adj1, 3)
  write(*, *)
  call printCircuit(adj2, 7)

end program main

