module suffix_tree_mod
   implicit none
   private
   public :: suffix_tree_t, build_suffix_tree, lrs_find, destroy_suffix_tree

   integer, parameter :: INF  = huge(0)
   integer, parameter :: ALPHA = 128

   type :: node_t
      integer :: children(0:ALPHA-1)
      integer :: start, ending, suffixlink, suffixindex
   end type node_t

   type :: suffix_tree_t
      type(node_t), allocatable :: nodes(:)
      integer,      allocatable :: text(:)
      integer :: n, root, position, currentnode
      integer :: needsuffixlink, remainder
      integer :: activenode, activelength, activeedge
   end type suffix_tree_t

contains

   integer function edgelen(st, nd)
      type(suffix_tree_t), intent(in) :: st
      type(node_t),        intent(in) :: nd
      edgelen = min(nd%ending, st%position + 1) - nd%start
   end function edgelen

   integer function newnode(st, s, e)
      type(suffix_tree_t), intent(inout) :: st
      integer, intent(in) :: s, e
      st%currentnode = st%currentnode + 1
      newnode = st%currentnode
      associate(nd => st%nodes(newnode))
         nd%children    = 0
         nd%start       = s
         nd%ending      = e
         nd%suffixlink  = 0
         nd%suffixindex = -1
      end associate
   end function newnode

   subroutine add_sfx_link(st, node)
      type(suffix_tree_t), intent(inout) :: st
      integer, intent(in) :: node
      if (st%needsuffixlink > 0) &
         st%nodes(st%needsuffixlink)%suffixlink = node
      st%needsuffixlink = node
   end subroutine add_sfx_link

   logical function walkdown(st, curr)
      type(suffix_tree_t), intent(inout) :: st
      integer, intent(in) :: curr
      integer :: len
      len = edgelen(st, st%nodes(curr))
      if (st%activelength < len) then
         walkdown = .false.; return
      end if
      st%activeedge   = st%activeedge + len
      st%activelength = st%activelength - len
      st%activenode   = curr
      walkdown = .true.
   end function walkdown

   subroutine extend_tree(st, pos)
      type(suffix_tree_t), intent(inout) :: st
      integer, intent(in) :: pos
      integer :: leaf, nxt, splt, ae

      st%position       = pos
      st%needsuffixlink = 0
      st%remainder      = st%remainder + 1

      do while (st%remainder > 0)
         if (st%activelength == 0) st%activeedge = pos
         ae = st%text(st%activeedge)

         if (st%nodes(st%activenode)%children(ae) == 0) then
            leaf = newnode(st, pos, INF)
            st%nodes(st%activenode)%children(ae) = leaf
            call add_sfx_link(st, st%activenode)
         else
            nxt = st%nodes(st%activenode)%children(ae)
            if (walkdown(st, nxt)) cycle
            if (st%text(st%nodes(nxt)%start + st%activelength) == st%text(pos)) then
               call add_sfx_link(st, st%activenode)
               st%activelength = st%activelength + 1
               exit
            end if
            splt = newnode(st, st%nodes(nxt)%start, &
                              st%nodes(nxt)%start + st%activelength)
            st%nodes(st%activenode)%children(ae) = splt
            leaf = newnode(st, pos, INF)
            st%nodes(splt)%children(st%text(pos)) = leaf
            st%nodes(nxt)%start = st%nodes(nxt)%start + st%activelength
            st%nodes(splt)%children(st%text(st%nodes(nxt)%start)) = nxt
            call add_sfx_link(st, splt)
         end if

         st%remainder = st%remainder - 1
         if (st%activenode == st%root .and. st%activelength > 0) then
            st%activelength = st%activelength - 1
            st%activeedge   = pos - st%remainder + 1
         else if (st%activenode /= st%root) then
            st%activenode = st%nodes(st%activenode)%suffixlink
         end if
      end do
   end subroutine extend_tree

   recursive subroutine set_sfx_idx(st, nidx, lh)
      type(suffix_tree_t), intent(inout) :: st
      integer, intent(in) :: nidx, lh
      integer :: c, cidx
      logical :: isleaf
      isleaf = .true.
      do c = 0, ALPHA-1
         cidx = st%nodes(nidx)%children(c)
         if (cidx /= 0) then
            isleaf = .false.
            call set_sfx_idx(st, cidx, lh + edgelen(st, st%nodes(cidx)))
         end if
      end do
      if (isleaf) st%nodes(nidx)%suffixindex = st%n - lh
   end subroutine set_sfx_idx

   subroutine build_suffix_tree(st, str)
      type(suffix_tree_t), intent(out) :: st
      character(len=*), intent(in) :: str
      integer :: i, n
      n = len(str)
      st%n              = n
      st%position       = 0
      st%currentnode    = 0
      st%needsuffixlink = 0
      st%remainder      = 0
      st%activelength   = 0
      st%activeedge     = 1
      st%root           = 0
      st%activenode     = 0
      allocate(st%text(n))
      allocate(st%nodes(2*n + 2))
      do i = 1, n
         st%text(i) = iachar(str(i:i))
      end do
      do i = 1, 2*n + 2
         st%nodes(i)%children   = 0
         st%nodes(i)%start      = 0
         st%nodes(i)%ending     = INF
         st%nodes(i)%suffixlink = 0
         st%nodes(i)%suffixindex = -1
      end do
      st%root     = newnode(st, 0, 0)
      st%activenode = st%root
      do i = 1, n
         call extend_tree(st, i)
      end do
      call set_sfx_idx(st, st%root, 0)
   end subroutine build_suffix_tree

   subroutine destroy_suffix_tree(st)
      type(suffix_tree_t), intent(inout) :: st
      if (allocated(st%nodes)) deallocate(st%nodes)
      if (allocated(st%text))  deallocate(st%text)
   end subroutine destroy_suffix_tree

   recursive subroutine traverse(st, nidx, lh, maxh, starts, ns)
      type(suffix_tree_t), intent(in) :: st
      integer, intent(in)    :: nidx, lh
      integer, intent(inout) :: maxh, ns
      integer, intent(inout) :: starts(:)
      integer :: c, cidx, ph
      if (st%nodes(nidx)%suffixindex == -1) then
         do c = 0, ALPHA-1
            cidx = st%nodes(nidx)%children(c)
            if (cidx /= 0) call traverse(st, cidx, &
               lh + edgelen(st, st%nodes(cidx)), maxh, starts, ns)
         end do
      else
         ph = lh - edgelen(st, st%nodes(nidx))
         if (maxh < ph) then
            maxh = ph
            ns = 1
            starts(1) = st%nodes(nidx)%suffixindex + 1
         else if (maxh == ph) then
            ns = ns + 1
            if (ns <= size(starts)) starts(ns) = st%nodes(nidx)%suffixindex + 1
         end if
      end if
   end subroutine traverse

   subroutine lrs_find(st, length, starts, nstarts)
      type(suffix_tree_t), intent(in) :: st
      integer, intent(out) :: length, nstarts
      integer, allocatable, intent(out) :: starts(:)
      integer, allocatable :: tmp(:)
      integer :: maxh, ns
      maxh = 0; ns = 0
      allocate(tmp(st%n))
      call traverse(st, st%root, 0, maxh, tmp, ns)
      length  = maxh
      nstarts = ns
      allocate(starts(max(ns,1)))
      if (ns > 0) starts(1:ns) = tmp(1:ns)
      deallocate(tmp)
   end subroutine lrs_find

end module suffix_tree_mod

! ============================================================================
! Ukkonen's linear-time suffix tree - direct Fortran translation of the
! canonical Julia reference implementation.
! ============================================================================
program cannonical
   use suffix_tree_mod
   use iso_fortran_env, only: int64
   implicit none

   type(suffix_tree_t) :: st
   integer :: length, nstarts, i, unit, ios
   integer, allocatable :: starts(:)
   character(:), allocatable :: text, pi_str
   character(1100000) :: line
   integer(int64) :: t1, t2, rate
   real(8) :: secs
   integer, parameter :: limits(4) = [1000, 10000, 100000, 1000000]

   print *, "Longest Repeated Substring in:"
   print *
   call run_test("CAAAABAAAABD")
   call run_test("GEEKSFORGEEKS")
   call run_test("AAAAAAAAAA")
   call run_test("ABCDEFG")
   call run_test("ABABABA")
   call run_test("ATCGATCGA")
   call run_test("banana")
   call run_test("abcpqrabpqpq")
   call run_test("pqrpqpqabab")
   print *

   ! Read the 1000000-digit line (line 4) and use prefixes for all cases
   open(newunit=unit, file='..\piDigits.txt', status='old', action='read', iostat=ios)
   if (ios /= 0) stop "piDigits.txt not found"
   read(unit, '(a)') line   ! line 1: 1000 digits
   read(unit, '(a)') line   ! line 2: 10000 digits
   read(unit, '(a)') line   ! line 3: 100000 digits
   read(unit, '(a)', iostat=ios) line   ! line 4: 1000000 digits
   close(unit)
   pi_str = trim(line)

   do i = 1, 4
      if (limits(i) > len(pi_str)) cycle
      text = pi_str(1:limits(i)) // '$'
      call system_clock(t1, rate)
      call build_suffix_tree(st, text)
      call lrs_find(st, length, starts, nstarts)
      call system_clock(t2)
      secs = real(t2 - t1, 8) / real(rate, 8)
      write(*, '(a,i0,a)', advance='no') "first ", limits(i), " d.p. of pi: "
      if (length == 0) then
         write(*, '(a)') "No repeated substring."
      else
         write(*, '(a)') lrs_string(text, length, starts, nstarts)
      end if
      write(*, '(f8.6,a)') secs, " seconds"
      print *
      call destroy_suffix_tree(st)
      if (allocated(starts)) deallocate(starts)
   end do

contains

   subroutine run_test(s)
      character(*), intent(in) :: s
      character(:), allocatable :: treestr
      integer :: length, nstarts
      integer, allocatable :: starts(:)
      treestr = s // '$'
      call build_suffix_tree(st, treestr)
      call lrs_find(st, length, starts, nstarts)
      write(*, '(3a)', advance='no') "  ", s, ": "
      if (length == 0) then
         write(*, '(a)') "No repeated substring."
      else
         write(*, '(a)') lrs_string(treestr, length, starts, nstarts)
      end if
      call destroy_suffix_tree(st)
      if (allocated(starts)) deallocate(starts)
   end subroutine run_test

   ! Returns all unique LRS substrings joined with " (or) "
   function lrs_string(text, length, starts, nstarts) result(res)
      character(*), intent(in) :: text
      integer, intent(in) :: length, nstarts
      integer, intent(in) :: starts(:)
      character(:), allocatable :: res
      integer, allocatable :: ui(:)
      integer :: i, j, n
      logical :: found
      allocate(ui(nstarts))
      n = 0
      do i = 1, nstarts
         found = .false.
         do j = 1, n
            if (text(ui(j):ui(j)+length-1) == text(starts(i):starts(i)+length-1)) then
               found = .true.; exit
            end if
         end do
         if (.not. found) then
            n = n + 1
            ui(n) = starts(i)
         end if
      end do
      res = ""
      do i = 1, n
         if (i > 1) res = res // " (or) "
         res = res // text(ui(i):ui(i)+length-1)
      end do
      deallocate(ui)
   end function lrs_string

end program cannonical
