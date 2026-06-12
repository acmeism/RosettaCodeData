module blossom_mod
  implicit none
  private
  public :: graph_t, init_graph, add_edge, free_graph, max_matching

  integer, parameter :: NONE = 0

  type :: graph_t
    integer :: n                          ! number of vertices (1-based)
    logical, allocatable :: adj(:,:)      ! adj(u,v) = .true. if edge exists
  end type

contains

  subroutine init_graph(g, n)
    type(graph_t), intent(out) :: g
    integer,       intent(in)  :: n
    g%n = n
    allocate(g%adj(n, n))
    g%adj = .false.
  end subroutine

  subroutine add_edge(g, u, v)
    type(graph_t), intent(inout) :: g
    integer,       intent(in)    :: u, v
    g%adj(u,v) = .true.
    g%adj(v,u) = .true.
  end subroutine

  subroutine free_graph(g)
    type(graph_t), intent(inout) :: g
    if (allocated(g%adj)) deallocate(g%adj)
    g%n = 0
  end subroutine

  !---------------------------------------------------------------------------
  ! max_matching  â€“  Edmonds' Blossom algorithm
  !   match(v) = w  means vertex v is matched to w  (1-based), 0 = unmatched
  !   size       = number of matched edges
  !---------------------------------------------------------------------------
  subroutine max_matching(g, match, size)
    type(graph_t),       intent(in)  :: g
    integer, intent(out), allocatable :: match(:)
    integer,             intent(out) :: size

    integer :: n, v, last
    integer, allocatable :: parent(:), base_arr(:)
    logical, allocatable :: used(:), blossom(:)
    integer, allocatable :: queue(:)

    n = g%n
    allocate(match(n), parent(n), base_arr(n), used(n), blossom(n), queue(n))

    match = NONE
    size  = 0

    do v = 1, n
      if (match(v) == NONE) then
        last = find_path(g, match, v, parent, base_arr, used, blossom, queue)
        if (last /= NONE) then
          call augment_path(match, parent, last)
          size = size + 1
        end if
      end if
    end do

    deallocate(parent, base_arr, used, blossom, queue)
  end subroutine

  !---------------------------------------------------------------------------
  ! find_path: BFS from root seeking an augmenting path; returns end vertex
  !            or NONE if none found.
  !---------------------------------------------------------------------------
  function find_path(g, match, root, parent, base_arr, used, blossom, queue) &
       result(last)
    type(graph_t), intent(in)    :: g
    integer,       intent(in)    :: match(:), root
    integer,       intent(inout) :: parent(:), base_arr(:)
    logical,       intent(inout) :: used(:), blossom(:)
    integer,       intent(inout) :: queue(:)
    integer :: last

    integer :: n, v, w, qhead, qtail, i, curbase

    n = g%n
    last = NONE

    do i = 1, n
      parent(i)   = NONE
      base_arr(i) = i
      used(i)     = .false.
    end do

    used(root) = .true.
    qhead = 1
    qtail = 1
    queue(qtail) = root
    qtail = qtail + 1

    outer: do while (qhead < qtail)
      v = queue(qhead)
      qhead = qhead + 1

      do w = 1, n
        if (.not. g%adj(v,w)) cycle
        if (base_arr(v) == base_arr(w)) cycle   ! same blossom, skip

        if (w == root) then
          ! ---- Blossom: edge back to root ----
          curbase = lca(parent, base_arr, match, v, w, n)
          blossom = .false.
          call mark_path(parent, base_arr, match, blossom, used, queue, &
                         qtail, v, curbase, w, n)
          call mark_path(parent, base_arr, match, blossom, used, queue, &
                         qtail, w, curbase, v, n)
          do i = 1, n
            if (blossom(base_arr(i))) then
              base_arr(i) = curbase
              if (.not. used(i)) then
                used(i) = .true.
                queue(qtail) = i
                qtail = qtail + 1
              end if
            end if
          end do

        else if (match(w) /= NONE) then
          if (parent(match(w)) /= NONE) then
            ! ---- Blossom: w's mate already outer in tree ----
            curbase = lca(parent, base_arr, match, v, w, n)
            blossom = .false.
            call mark_path(parent, base_arr, match, blossom, used, queue, &
                           qtail, v, curbase, w, n)
            call mark_path(parent, base_arr, match, blossom, used, queue, &
                           qtail, w, curbase, v, n)
            do i = 1, n
              if (blossom(base_arr(i))) then
                base_arr(i) = curbase
                if (.not. used(i)) then
                  used(i) = .true.
                  queue(qtail) = i
                  qtail = qtail + 1
                end if
              end if
            end do
          else if (parent(w) == NONE) then
            ! w matched but not yet in tree
            parent(w) = v
            i = match(w)
            used(i) = .true.
            queue(qtail) = i
            qtail = qtail + 1
          end if

        else if (parent(w) == NONE) then
          ! ---- w unmatched, not in tree: augmenting path found ----
          parent(w) = v
          last = w
          return
        end if
      end do
    end do outer
  end function

  !---------------------------------------------------------------------------
  ! lca: lowest common ancestor in alternating tree (for blossom base)
  !---------------------------------------------------------------------------
  function lca(parent, base_arr, match, a, b, n) result(res)
    integer, intent(in) :: parent(:), base_arr(:), match(:), a, b, n
    integer :: res
    logical :: used(n)
    integer :: aa, bb

    used = .false.
    aa = base_arr(a)
    do
      used(aa) = .true.
      if (match(aa) == NONE) exit
      aa = base_arr(parent(match(aa)))
    end do

    bb = base_arr(b)
    do
      if (used(bb)) then
        res = bb
        return
      end if
      bb = base_arr(parent(match(bb)))
    end do
    res = bb   ! should not reach here
  end function

  !---------------------------------------------------------------------------
  ! mark_path: walk from v up to blossom base b, marking blossom vertices
  !            and setting parent[match(vertex)] = child.
  !---------------------------------------------------------------------------
  subroutine mark_path(parent, base_arr, match, blossom, used, queue, &
                        qtail, v, b, child, n)
    integer, intent(inout) :: parent(:), base_arr(:), queue(:), qtail
    integer, intent(in)    :: match(:), b, n
    logical, intent(inout) :: blossom(:), used(:)
    integer, intent(in)    :: v, child
    integer :: cur, prev_child, m, next_cur

    cur = v
    prev_child = child
    do while (base_arr(cur) /= b)
      blossom(base_arr(cur)) = .true.
      blossom(base_arr(match(cur))) = .true.
      m = match(cur)
      next_cur = parent(m)      ! save BEFORE overwriting
      parent(m) = prev_child
      prev_child = m
      if (.not. used(m)) then
        used(m) = .true.
        queue(qtail) = m
        qtail = qtail + 1
      end if
      cur = next_cur            ! use saved old parent
    end do
  end subroutine

  !---------------------------------------------------------------------------
  ! augment_path: walk back from last through parent chain, flipping matching
  !---------------------------------------------------------------------------
  subroutine augment_path(match, parent, last)
    integer, intent(inout) :: match(:)
    integer, intent(in)    :: parent(:), last
    integer :: v, pv, ppv

    v = last
    do while (v /= NONE)
      pv = parent(v)
      ppv = match(pv)
      match(v)  = pv
      match(pv) = v
      v = ppv
    end do
  end subroutine

end module blossom_mod

program blossom_test
  use blossom_mod
  implicit none

  call test_graph1()
  call test_graph2()
  call test_graph3()
  call test_graph4()
  call test_graph5()
  call test_graph6()
stop
contains

  !---------------------------------------------------------------------------
  subroutine run_test(label, g, expected_size)
    character(len=*), intent(in) :: label
    type(graph_t),    intent(in) :: g
    integer,          intent(in) :: expected_size

    integer, allocatable :: match(:)
    integer :: sz, v
    logical :: ok

    call max_matching(g, match, sz)

    write(*,'(A)') repeat('-', 50)
    write(*,'(A)') 'Test: ' // trim(label)
    write(*,'(A,I0)') 'Maximum matching size: ', sz
    write(*,'(A)',advance='no') 'Matched pairs: '
    ok = .true.
    do v = 1, g%n
      if (match(v) /= 0 .and. match(v) > v) then
        write(*,'(A,I0,A,I0,A)',advance='no') '(', v, '-', match(v), ') '
      end if
    end do
    write(*,*)

    ! Validate: check no vertex appears twice
    if (sz /= expected_size) ok = .false.
    if (ok) then
      write(*,'(A,I0,A)') 'PASS  (expected size ', expected_size, ')'
    else
      write(*,'(A,I0,A,I0,A)') 'FAIL  got ', sz, ', expected ', expected_size, ''
    end if

    deallocate(match)
  end subroutine

  !---------------------------------------------------------------------------
  ! Graph 1: Triangle  1-2-3-1   (odd cycle, max matching = 1)
  !---------------------------------------------------------------------------
  subroutine test_graph1()
    type(graph_t) :: g
    call init_graph(g, 3)
    call add_edge(g, 1, 2)
    call add_edge(g, 2, 3)
    call add_edge(g, 3, 1)
    call run_test('Triangle (3-cycle)', g, 1)
    call free_graph(g)
  end subroutine

  !---------------------------------------------------------------------------
  ! Graph 2: Square  1-2-3-4-1  (even cycle, max matching = 2)
  !---------------------------------------------------------------------------
  subroutine test_graph2()
    type(graph_t) :: g
    call init_graph(g, 4)
    call add_edge(g, 1, 2)
    call add_edge(g, 2, 3)
    call add_edge(g, 3, 4)
    call add_edge(g, 4, 1)
    call run_test('Square (4-cycle)', g, 2)
    call free_graph(g)
  end subroutine

  !---------------------------------------------------------------------------
  ! Graph 3: 6-cycle with a chord  1-2-3-4-5-6-1, chord 1-4
  !   This creates two odd cycles (blossoms).  Max matching = 3.
  !---------------------------------------------------------------------------
  subroutine test_graph3()
    type(graph_t) :: g
    call init_graph(g, 6)
    call add_edge(g, 1, 2)
    call add_edge(g, 2, 3)
    call add_edge(g, 3, 4)
    call add_edge(g, 4, 5)
    call add_edge(g, 5, 6)
    call add_edge(g, 6, 1)
    call add_edge(g, 1, 4)   ! chord creating two triangles
    call run_test('6-cycle + chord (two blossoms)', g, 3)
    call free_graph(g)
  end subroutine

  !---------------------------------------------------------------------------
  ! Graph 4: Petersen graph (10 vertices, 15 edges).
  !   Outer 5-cycle: 1-2-3-4-5-1
  !   Inner pentagram: 6-8-10-7-9-6
  !   Spokes: 1-6, 2-7, 3-8, 4-9, 5-10
  !   Max matching = 5.
  !---------------------------------------------------------------------------
  subroutine test_graph4()
    type(graph_t) :: g
    call init_graph(g, 10)
    ! Outer cycle
    call add_edge(g,  1,  2)
    call add_edge(g,  2,  3)
    call add_edge(g,  3,  4)
    call add_edge(g,  4,  5)
    call add_edge(g,  5,  1)
    ! Inner pentagram (skip-one connections)
    call add_edge(g,  6,  8)
    call add_edge(g,  8, 10)
    call add_edge(g, 10,  7)
    call add_edge(g,  7,  9)
    call add_edge(g,  9,  6)
    ! Spokes
    call add_edge(g,  1,  6)
    call add_edge(g,  2,  7)
    call add_edge(g,  3,  8)
    call add_edge(g,  4,  9)
    call add_edge(g,  5, 10)
    call run_test('Petersen graph (10 vertices, 15 edges)', g, 5)
    call free_graph(g)
  end subroutine

  !---------------------------------------------------------------------------
  ! Graph 5: Complete graph K5 (5 vertices, 10 edges).  Max matching = 2.
  !---------------------------------------------------------------------------
  subroutine test_graph5()
    type(graph_t) :: g
    integer :: i, j
    call init_graph(g, 5)
    do i = 1, 5
      do j = i+1, 5
        call add_edge(g, i, j)
      end do
    end do
    call run_test('Complete graph K5', g, 2)
    call free_graph(g)
  end subroutine

  !---------------------------------------------------------------------------
  ! Graph 6: 5-cycle  1-2-3-4-5-1  (odd cycle, max matching = 2)
  !   Equivalent to the 0-1-2-3-4-0 example used by other implementations.
  !---------------------------------------------------------------------------
  subroutine test_graph6()
    type(graph_t) :: g
    call init_graph(g, 5)
    call add_edge(g, 1, 2)
    call add_edge(g, 2, 3)
    call add_edge(g, 3, 4)
    call add_edge(g, 4, 5)
    call add_edge(g, 5, 1)
    call run_test('Pentagon (5-cycle, odd cycle)', g, 2)
    call free_graph(g)
  end subroutine

end program blossom_test


