! topology.f90
! Topological sort for VHDL file compilation order.
!
! Given a table of file dependencies (each line: file dep1 dep2 ...),
! the program:
!   1. Identifies top-level files: files that have a dependency entry and
!      are not themselves a dependency of any other file.
!   2. Produces a levelled compile order for any file or set of files.
!
! Levelled compile order
! ----------------------
! Files are grouped into levels so that every file in level N depends only
! on files in levels 0..N-1 and can be compiled in parallel with other
! files at level N.
!
! Algorithm per compile-order request:
!   a. Collect the subgraph (all nodes reachable from the requested root(s))
!      via DFS.
!   b. Topological-sort the subgraph: DFS post-order gives reverse topo
!      order; reverse it to get roots-first order.
!   c. DP for longest path from any root: process nodes in topo order;
!      for each node u at depth d, set depth[v] = max(depth[v], d+1) for
!      every dependency v of u that is in the subgraph.
!      This gives the LATEST level at which each node must be compiled,
!      ensuring nodes shared between multiple paths (e.g. extra1, ipcommon)
!      are deferred to the deepest level they are needed.
!   d. compile_level(v) = max_depth - depth(v).
!      Level 0 ("First") contains leaves and deeply-nested shared nodes;
!      the root(s) sit at the highest level ("Then").
!   e. Sort each level alphabetically before printing.
!
! Self-dependencies are silently ignored.
! Input data is hard-coded in load_dependencies().
!
program topology
    implicit none

    integer, parameter :: MAX_FILES  = 100
    integer, parameter :: MAX_DEPS   = 50
    integer, parameter :: NAME_LEN   = 24
    integer, parameter :: MAX_LEVELS = 20

    character(len=NAME_LEN) :: names(MAX_FILES)
    integer :: num_files
    integer :: deps(MAX_FILES, MAX_DEPS)
    integer :: ndeps(MAX_FILES)

    integer :: i, k
    logical :: is_dep(MAX_FILES)
    logical :: has_entry(MAX_FILES)
    integer :: top_ids(MAX_FILES)
    integer :: num_top
    character(len=200) :: clabel
    integer :: tmp(1)

    num_files = 0
    ndeps     = 0

    call load_dependencies()

    ! Classify files
    is_dep    = .false.
    has_entry = .false.
    do i = 1, num_files
        if (ndeps(i) > 0) has_entry(i) = .true.
        do k = 1, ndeps(i)
            is_dep(deps(i,k)) = .true.
        end do
    end do

    ! Collect top-level file ids (in discovery order = input order)
    num_top = 0
    do i = 1, num_files
        if (has_entry(i) .and. .not. is_dep(i)) then
            num_top = num_top + 1
            top_ids(num_top) = i
        end if
    end do

    ! Print top-level list
    write(*,'(A)', advance='no') 'The top levels of the dependency graph are: '
    do k = 1, num_top
        if (k > 1) write(*,'(A)', advance='no') ', '
        write(*,'(A)', advance='no') trim(names(top_ids(k)))
    end do
    write(*,*)
    write(*,*)

    ! Individual compile orders for each top-level file
    do k = 1, num_top
        tmp(1) = top_ids(k)
        call show_compile_order(tmp, 'top level', trim(names(top_ids(k))))
    end do

    ! Combined compile order for all top-level files (stretch goal)
    clabel = ''
    do k = 1, num_top
        if (k > 1) clabel = trim(clabel) // ', '
        clabel = trim(clabel) // trim(names(top_ids(k)))
    end do
    call show_compile_order(top_ids(1:num_top), 'top levels', trim(clabel))

    ! Compile order for a specific non-top-level file
    i = find_file('ip1')
    if (i > 0) then
        tmp(1) = i
        call show_compile_order(tmp, 'file', 'ip1')
    end if

contains

    ! Return id of named file, 0 if not found.
    function find_file(name) result(id)
        character(len=*), intent(in) :: name
        integer :: id, k
        id = 0
        do k = 1, num_files
            if (trim(names(k)) == trim(name)) then
                id = k
                return
            end if
        end do
    end function find_file

    ! Return id of named file, creating a new entry if absent.
    function find_or_add(name) result(id)
        character(len=*), intent(in) :: name
        integer :: id, k
        do k = 1, num_files
            if (trim(names(k)) == trim(name)) then
                id = k
                return
            end if
        end do
        num_files        = num_files + 1
        names(num_files) = trim(name)
        ndeps(num_files) = 0
        id               = num_files
    end function find_or_add

    ! Parse "file dep1 dep2 ..." and add to the dependency graph.
    subroutine parse_line(line)
        character(len=*), intent(in) :: line
        character(len=NAME_LEN) :: token
        integer :: fid, did, pos, start, llen
        llen = len_trim(line)
        pos  = 1
        do while (pos <= llen .and. line(pos:pos) == ' ') ; pos = pos+1 ; end do
        start = pos
        do while (pos <= llen .and. line(pos:pos) /= ' ') ; pos = pos+1 ; end do
        token = line(start:pos-1)
        fid = find_or_add(token)
        do while (pos <= llen)
            do while (pos <= llen .and. line(pos:pos) == ' ') ; pos = pos+1 ; end do
            if (pos > llen) exit
            start = pos
            do while (pos <= llen .and. line(pos:pos) /= ' ') ; pos = pos+1 ; end do
            token = line(start:pos-1)
            did = find_or_add(token)
            if (did /= fid) then
                ndeps(fid) = ndeps(fid) + 1
                deps(fid, ndeps(fid)) = did
            end if
        end do
    end subroutine parse_line

    subroutine load_dependencies()
        call parse_line('top1  des1 ip1 ip2')
        call parse_line('top2  des1 ip2 ip3')
        call parse_line('ip1   extra1 ip1a ipcommon')
        call parse_line('ip2   ip2a ip2b ip2c ipcommon')
        call parse_line('des1  des1a des1b des1c')
        call parse_line('des1a des1a1 des1a2')
        call parse_line('des1c des1c1 extra1')
    end subroutine load_dependencies

    ! Mark all nodes reachable from u as in_sub (DFS).
    recursive subroutine collect_sub(u, in_sub)
        integer, intent(in)    :: u
        logical, intent(inout) :: in_sub(MAX_FILES)
        integer :: j
        if (in_sub(u)) return
        in_sub(u) = .true.
        do j = 1, ndeps(u)
            call collect_sub(deps(u,j), in_sub)
        end do
    end subroutine collect_sub

    ! DFS post-order within in_sub, appending ids to topo.
    recursive subroutine dfs_post(u, in_sub, visited, topo, tsz)
        integer, intent(in)    :: u
        logical, intent(in)    :: in_sub(MAX_FILES)
        logical, intent(inout) :: visited(MAX_FILES)
        integer, intent(inout) :: topo(MAX_FILES)
        integer, intent(inout) :: tsz
        integer :: j
        if (visited(u)) return
        visited(u) = .true.
        do j = 1, ndeps(u)
            if (in_sub(deps(u,j))) call dfs_post(deps(u,j), in_sub, visited, topo, tsz)
        end do
        tsz = tsz + 1
        topo(tsz) = u
    end subroutine dfs_post

    ! Insertion sort of a file-id array by file name (alphabetical).
    subroutine sort_level(arr)
        integer, intent(inout) :: arr(:)
        integer :: i, j, tmp, n
        n = size(arr)
        do i = 2, n
            tmp = arr(i)
            j   = i - 1
            do while (j >= 1 .and. names(arr(j)) > names(tmp))
                arr(j+1) = arr(j)
                j = j - 1
            end do
            arr(j+1) = tmp
        end do
    end subroutine sort_level

    ! Compute and print the levelled compile order for roots(:).
    subroutine show_compile_order(roots, kind_label, name_label)
        integer,         intent(in) :: roots(:)
        character(len=*),intent(in) :: kind_label, name_label

        logical :: in_sub(MAX_FILES)
        logical :: visited(MAX_FILES)
        integer :: topo(MAX_FILES)
        integer :: tsz
        integer :: depth(MAX_FILES)
        integer :: level_ids(MAX_LEVELS, MAX_FILES)
        integer :: level_sz(MAX_LEVELS)
        integer :: num_levels, max_depth
        integer :: i, j, u, v, lev, tmp
        character(len=600) :: buf

        ! Step 1: collect subgraph
        in_sub = .false.
        do i = 1, size(roots)
            call collect_sub(roots(i), in_sub)
        end do

        ! Step 2: DFS post-order of subgraph (= reverse topological order)
        visited = .false.
        tsz     = 0
        do i = 1, size(roots)
            call dfs_post(roots(i), in_sub, visited, topo, tsz)
        end do

        ! Reverse to get forward topological order (roots first)
        do i = 1, tsz/2
            tmp              = topo(i)
            topo(i)          = topo(tsz-i+1)
            topo(tsz-i+1)    = tmp
        end do

        ! Step 3: DP -- longest path from any root to each node
        depth = 0
        do i = 1, tsz
            u = topo(i)
            do j = 1, ndeps(u)
                v = deps(u,j)
                if (in_sub(v)) depth(v) = max(depth(v), depth(u)+1)
            end do
        end do

        ! Step 4: max depth
        max_depth = 0
        do i = 1, tsz
            if (depth(topo(i)) > max_depth) max_depth = depth(topo(i))
        end do

        ! Step 5: assign compile levels  (level 1 = first to compile)
        num_levels = max_depth + 1
        level_sz   = 0
        do i = 1, tsz
            u          = topo(i)
            lev        = max_depth - depth(u) + 1
            level_sz(lev)              = level_sz(lev) + 1
            level_ids(lev,level_sz(lev)) = u
        end do

        ! Step 6: sort each level alphabetically
        do lev = 1, num_levels
            call sort_level(level_ids(lev, 1:level_sz(lev)))
        end do

        ! Step 7: print
        write(*,'(5A)') 'The compilation order for ', trim(kind_label), &
                        " '", trim(name_label), "' is:"
        do lev = 1, num_levels
            buf = '['
            do j = 1, level_sz(lev)
                if (j > 1) buf = trim(buf) // ', '
                buf = trim(buf) // trim(names(level_ids(lev,j)))
            end do
            buf = trim(buf) // ']'
            if (lev == 1) then
                write(*,'(2A)') 'First: ', trim(buf)
            else
                write(*,'(2A)') '    Then: ', trim(buf)
            end if
        end do
        write(*,*)
    end subroutine show_compile_order

end program topology

