module vlist_mod
   implicit none

   type :: block
      integer :: size
      character, allocatable :: elements(:)
      type(block), pointer :: next => null()
   end type block

   type, public :: vlist
      private
      type(block), pointer :: base => null()
      integer :: offset = -1
      integer :: length = 0
      contains
      procedure :: init => vlist_init
      procedure :: cons => vlist_cons
      procedure :: car => vlist_car
      procedure :: cdr => vlist_cdr
      procedure :: nth => vlist_nth
      procedure :: nth_cdr => vlist_nth_cdr
      procedure :: get_length => vlist_length
      procedure :: deep_copy => vlist_deep_copy
      generic :: assignment(=) => vlist_assign
      procedure, private :: vlist_assign
   end type vlist

   type, extends(vlist) :: stringvlist
      contains
      procedure :: prefix => string_prefix
   end type stringvlist

contains

   subroutine vlist_init(this)
      class(vlist), intent(inout) :: this
      if (associated(this%base)) then
         call free_blocks(this%base)
      end if
      this%base => null()
      this%offset = -1
      this%length = 0
   end subroutine vlist_init

   subroutine free_blocks(blockx)
      type(block), pointer :: blockx
      type(block), pointer :: temp
      do while (associated(blockx))
         temp => blockx%next
         if (allocated(blockx%elements)) deallocate(blockx%elements)
         deallocate(blockx)
         blockx => temp
      end do
   end subroutine free_blocks

   subroutine vlist_cons(this, element)
      class(vlist), intent(inout) :: this
      character, intent(in) :: element
      type(block), pointer :: new_block

      this%length = this%length + 1

      if (.not.associated(this%base)) then
         allocate(this%base)
         this%base%size = 1
         allocate(this%base%elements(0:0))
         this%base%elements(0) = element
         this%offset = 0
      else if (this%offset + 1 == this%base%size) then
         allocate(new_block)
         new_block%size = 2 * this%base%size
         allocate(new_block%elements(0:new_block%size - 1))
         new_block%elements(0) = element
         new_block%next => this%base
         this%base => new_block
         this%offset = 0
      else
         this%offset = this%offset + 1
         this%base%elements(this%offset) = element
      end if
   end subroutine vlist_cons

   function vlist_car(this) result(element)
      class(vlist), intent(in) :: this
      character :: element
      element = this%base%elements(this%offset)
   end function vlist_car

   subroutine vlist_cdr(this)
      class(vlist), intent(inout) :: this
      type(block), pointer :: temp

      if (this%offset == 0) then
         temp => this%base
         this%base => this%base%next
         if (associated(this%base)) then
            this%offset = this%base%size - 1
         else
            this%offset = -1
         end if
         if (allocated(temp%elements)) deallocate(temp%elements)
         deallocate(temp)
      else
         this%offset = this%offset - 1
      end if
      this%length = this%length - 1
   end subroutine vlist_cdr

   function vlist_nth(this, k) result(element)
      class(vlist), intent(in) :: this
      integer, intent(in) :: k
      character :: element
      type(block), pointer :: current
      integer :: remaining, max_index

      current => this%base
      remaining = k

      do
         if (.not.associated(current)) exit
         if (associated(current, this%base)) then
            max_index = this%offset
         else
            max_index = current%size - 1
         end if

         if (remaining > max_index) then
            remaining = remaining - (max_index + 1)
            current => current%next
         else
            element = current%elements(max_index - remaining)
            return
         end if
      end do
      element = '?' ! Should not happen
   end function vlist_nth

   subroutine vlist_nth_cdr(this, k)
      class(vlist), intent(inout) :: this
      integer, intent(in) :: k
      integer :: i
      do i = 1, k
         call this%cdr()
      end do
   end subroutine vlist_nth_cdr

   integer function vlist_length(this)
      class(vlist), intent(in) :: this
      vlist_length = this%length
   end function vlist_length

   subroutine string_prefix(this, str)
      class(stringvlist), intent(inout) :: this
      character(*), intent(in) :: str
      integer :: i
      do i = len(str), 1, -1
         call this%cons(str(i:i))
      end do
   end subroutine string_prefix

   function get_string(vl) result(str)
      class(stringvlist), intent(in) :: vl
      character(:), allocatable :: str
      integer :: i
      str = ''
      do i = 0, vl%get_length() - 1
         str = str // vl%nth(i)
      end do
   end function get_string

   subroutine display(name, vl)
      character(*), intent(in) :: name
      class(stringvlist), intent(in) :: vl
      character(:), allocatable :: stored
      character(len=1000) :: temp
      integer :: block_num, k, temp_len
      type(block), pointer :: current

      current => vl%base
      stored = ''
      block_num = 0

      do while (associated(current))
         block_num = block_num + 1
         if (block_num > 1) stored = stored // '|'
         temp = ''
         temp_len = 0

         if (block_num == 1) then
            ! Reverse iteration for base block
            do k = vl%offset, 0, -1
               temp(temp_len + 1:temp_len + 1) = current%elements(k)
               temp_len = temp_len + 1
            end do
         else
            ! Reverse iteration for other blocks
            do k = current%size - 1, 0, -1
               temp(temp_len + 1:temp_len + 1) = current%elements(k)
               temp_len = temp_len + 1
            end do
         end if

         stored = stored // temp(1:temp_len)
         current => current%next
      end do

      print '(a,a,a,i0,a,a)', &
            name // ' = "', get_string(vl), '"; length = ', vl%get_length(), &
            '; stored as "', stored // '"'
   end subroutine display

   subroutine vlist_assign(lhs, rhs)
      class(vlist), intent(inout) :: lhs
      class(vlist), intent(in) :: rhs
      call lhs%deep_copy(rhs)
   end subroutine vlist_assign

   subroutine vlist_deep_copy(this, other)
      class(vlist), intent(inout) :: this
      class(vlist), intent(in) :: other
      type(block), pointer :: curr_other, prev_block, new_block, first_block

      call this%init()
      curr_other => other%base
      prev_block => null()
      first_block => null()

      do while (associated(curr_other))
         allocate(new_block)
         new_block%size = curr_other%size
         allocate(new_block%elements(0:new_block%size - 1))
         new_block%elements = curr_other%elements
         new_block%next => null()
         if (.not.associated(first_block)) then
            first_block => new_block
         else
            prev_block%next => new_block
         end if
         prev_block => new_block
         curr_other => curr_other%next
      end do

      this%base => first_block
      this%offset = other%offset
      this%length = other%length
   end subroutine vlist_deep_copy

end module vlist_mod

!==============================================================================
! VList primary-operations harness
!
! Demonstrates all four operations required by the Rosetta Code task:
!
!   1. cons  -- add an element to the front              O(1) amortised
!   2. nth   -- locate the k-th element (0-based)        O(1) average
!   3. cdr   -- obtain a sub-list starting at element 1  O(1)
!   4. length-- compute the number of elements           O(1) here*
!
! * The stored %length field gives O(1) lookup.  The O(log n) bound in the
!   task description applies to computing length from scratch by summing
!   block sizes (1 + 2 + 4 + ... + 2^k); the implementation shortcircuits
!   this with a running counter updated on every cons/cdr.
!
! The VList stores characters; single-digit numerals ('1'..'9') are used
! so the output reads naturally as a sequence of integers.
!
! Block-growth trace for 9 cons operations (newest block listed first):
!   After 1 cons : [1-elem  block]  -> 1 block
!   After 2 cons : [2-elem  block] -> [1-elem  block]
!   After 3 cons : [2-elem  block] -> [1-elem  block]
!   After 4 cons : [4-elem  block] -> [2-elem block] -> [1-elem block]
!   After 8 cons : [8-elem  block] -> [4-elem block] -> [2-elem block] -> [1-elem block]
!   After 9 cons : [8-elem  block] -> [4-elem block] -> [2-elem block] -> [1-elem block]
!                  (head block partially filled, offset=1)
!==============================================================================
program vlist_harness
   use vlist_mod
   implicit none
   call demonstrate()
end program vlist_harness

subroutine demonstrate()
   use vlist_mod
   implicit none

   type(stringvlist) :: vl    ! the list under test
   type(stringvlist) :: tail  ! used to show cdr result without destroying vl
   integer :: k

   print '(A)', repeat('=', 60)
   print '(A)', ' VList Primary Operations Demonstration'
   print '(A)', repeat('=', 60)

   ! ------------------------------------------------------------------
   ! Operation 1: cons -- add elements to the FRONT of the list.
   !
   ! We cons '1' first and '9' last, so '9' ends up at the logical front
   ! (position 0) and '1' at the back (position 8).  This matches the
   ! LIFO / stack convention: the most recently added element is always
   ! accessible at nth(0) in O(1).
   !
   ! Nine elements trigger block allocations at sizes 1, 2, 4, 8,
   ! demonstrating the exponential-growth property that keeps pointer
   ! overhead at O(log n).
   ! ------------------------------------------------------------------
   print '(/,A)', ' --- Operation 1: cons (add to front) ---'
   call vl%init()

   do k = 1, 9
      call vl%cons(char(ichar('0') + k))   ! cons character '1'..'9'
      print '(A,I0,A)', '   After cons(''', k, '''):'
      call display('   vl', vl)
   end do

   ! ------------------------------------------------------------------
   ! Operation 2: nth(k) -- locate the k-th element.
   !
   ! The VList walks the block chain; because block sizes are powers of
   ! two (1, 2, 4, 8, ...) at most O(log n) blocks are ever traversed,
   ! giving O(log n) worst-case.  On average, half the elements live in
   ! the largest (newest) block, making the expected traversal O(1).
   ! ------------------------------------------------------------------
   print '(/,A)', ' --- Operation 2: nth(k) -- locate k-th element (0-based) ---'
   print '(A)',   '   Position 0 is the most recently added element (front).'
   do k = 0, vl%get_length() - 1
      print '(A,I0,A,A,A)', '   nth(', k, ') = ''', vl%nth(k), ''''
   end do

   ! ------------------------------------------------------------------
   ! Operation 3: cdr -- obtain a new list starting at the 2nd element.
   !
   ! A single cdr call drops the front element in O(1): if the head
   ! block still has elements, only the offset is decremented; if the
   ! head block is exhausted the pointer simply advances to the next
   ! block.  No data is copied.  The result is a view of the tail of
   ! the original logical sequence.
   ! ------------------------------------------------------------------
   print '(/,A)', ' --- Operation 3: cdr (sub-list from 2nd element) ---'
   tail = vl                   ! deep copy so vl is not modified
   print '(A,I0)', '   Before cdr, length = ', tail%get_length()
   call display('   before', tail)
   call tail%cdr()             ! O(1): drop the front element
   print '(A,I0)', '   After  cdr, length = ', tail%get_length()
   call display('   after ', tail)
   print '(A)', '   (original vl is unchanged)'
   call display('   vl    ', vl)

   ! ------------------------------------------------------------------
   ! Operation 4: length -- number of elements in the list.
   !
   ! get_length() returns the stored counter directly: O(1).
   ! To illustrate how length changes across all four operations,
   ! we apply a sequence of cons and cdr calls and report the length
   ! after each one.
   ! ------------------------------------------------------------------
   print '(/,A)', ' --- Operation 4: length ---'
   print '(A,I0)', '   Current length of vl            : ', vl%get_length()

   call vl%cons('X')
   print '(A,I0)', '   After cons(''X'')                 : ', vl%get_length()

   call vl%cdr()
   print '(A,I0)', '   After cdr                        : ', vl%get_length()

   call vl%nth_cdr(3)          ! drop 3 more elements from the front
   print '(A,I0)', '   After dropping 3 more (nth_cdr)  : ', vl%get_length()

   print '(/,A)', repeat('=', 60)
   print '(A)', ' All four primary operations demonstrated.'
   print '(A)', repeat('=', 60)

end subroutine demonstrate

