module doubly_linked_list
    implicit none
    private

    type, public :: node
        integer :: value
        type(node), pointer :: prev => null()
        type(node), pointer :: next => null()
    end type node

    type, public :: dlist_iterator
        type(node), pointer :: current => null()
    contains
        procedure :: next => iterator_next
        procedure :: prev => iterator_prev
        procedure :: valid => iterator_valid
        procedure :: value => iterator_value
    end type dlist_iterator

    type, public :: dlist
        type(node), pointer :: head => null()
        type(node), pointer :: tail => null()
        integer :: size = 0
    contains
        procedure :: insert_sorted => insert_sorted_dlist
        procedure :: destroy => destroy_dlist
        procedure :: print_list => print_dlist
        procedure :: insert_head => insert_head_dlist
        procedure :: insert_tail => insert_tail_dlist
        procedure :: delete_value => delete_value_dlist
        procedure :: find_value => find_value_dlist
        procedure :: reverse => reverse_dlist
        procedure :: remove_duplicates => remove_duplicates_dlist
        procedure :: begin => dlist_begin
        procedure :: end => dlist_end
        procedure :: sort => dlist_tree_sort   ! <-- Added sort procedure
    end type dlist

contains

! Iterator implementation

function dlist_begin(this) result(it)
    class(dlist), intent(in) :: this
    type(dlist_iterator) :: it
    it%current => this%head
end function dlist_begin

function dlist_end(this) result(it)
    class(dlist), intent(in) :: this
    type(dlist_iterator) :: it
    it%current => this%tail
end function dlist_end

subroutine iterator_next(this)
    class(dlist_iterator), intent(inout) :: this
    if (associated(this%current)) this%current => this%current%next
end subroutine iterator_next

subroutine iterator_prev(this)
    class(dlist_iterator), intent(inout) :: this
    if (associated(this%current)) this%current => this%current%prev
end subroutine iterator_prev

logical function iterator_valid(this)
    class(dlist_iterator), intent(in) :: this
    iterator_valid = associated(this%current)
end function iterator_valid

function iterator_value(this) result(val)
    class(dlist_iterator), intent(in) :: this
    integer :: val
    val = this%current%value
end function iterator_value

! Insert a value into the list in sorted order
subroutine insert_sorted_dlist(this, value)
    class(dlist), intent(inout) :: this
    integer, intent(in) :: value
    type(node), pointer :: new_node, current

    allocate(new_node)
    new_node%value = value
    new_node%prev => null()
    new_node%next => null()

    if (.not. associated(this%head)) then
        this%head => new_node
        this%tail => new_node
        this%size = 1
        return
    end if

    current => this%head
    do while (associated(current))
        if (value <= current%value) then
            new_node%next => current
            new_node%prev => current%prev
            current%prev => new_node
            if (associated(new_node%prev)) then
                new_node%prev%next => new_node
            else
                this%head => new_node
            end if
            this%size = this%size + 1
            return
        end if
        if (.not. associated(current%next)) then
            new_node%prev => current
            current%next => new_node
            this%tail => new_node
            this%size = this%size + 1
            return
        end if
        current => current%next
    end do
end subroutine insert_sorted_dlist

! Destroy the list and deallocate all nodes
subroutine destroy_dlist(this)
    class(dlist), intent(inout) :: this
    type(node), pointer :: current, next
    current => this%head
    do while (associated(current))
        next => current%next
        deallocate(current)
        current => next
    end do
    this%head => null()
    this%tail => null()
    this%size = 0
end subroutine destroy_dlist

! Print the list for debugging/testing
subroutine print_dlist(this)
    class(dlist), intent(in) :: this
    type(node), pointer :: current
    print *, 'List (size = ', this%size, '):'
    if (.not. associated(this%head)) then
        print *, ' (empty)'
        return
    end if
    current => this%head
    do while (associated(current))
        print *, ' Value: ', current%value
        current => current%next
    end do
end subroutine print_dlist

! Insert a value at the head of the list
subroutine insert_head_dlist(this, value)
    class(dlist), intent(inout) :: this
    integer, intent(in) :: value
    type(node), pointer :: new_node
    allocate(new_node)
    new_node%value = value
    new_node%prev => null()
    new_node%next => null()
    if (.not. associated(this%head)) then
        this%head => new_node
        this%tail => new_node
        this%size = 1
        return
    end if
    new_node%next => this%head
    this%head%prev => new_node
    this%head => new_node
    this%size = this%size + 1
end subroutine insert_head_dlist

! Insert a value at the tail of the list
subroutine insert_tail_dlist(this, value)
    class(dlist), intent(inout) :: this
    integer, intent(in) :: value
    type(node), pointer :: new_node
    allocate(new_node)
    new_node%value = value
    new_node%prev => null()
    new_node%next => null()
    if (.not. associated(this%head)) then
        this%head => new_node
        this%tail => new_node
        this%size = 1
        return
    end if
    new_node%prev => this%tail
    this%tail%next => new_node
    this%tail => new_node
    this%size = this%size + 1
end subroutine insert_tail_dlist

! Delete the first occurrence of a value from the list
subroutine delete_value_dlist(this, value)
    class(dlist), intent(inout) :: this
    integer, intent(in) :: value
    type(node), pointer :: current
    current => this%head
    do while (associated(current))
        if (current%value == value) then
            if (associated(current%prev)) then
                current%prev%next => current%next
            else
                this%head => current%next
            end if
            if (associated(current%next)) then
                current%next%prev => current%prev
            else
                this%tail => current%prev
            end if
            deallocate(current)
            this%size = this%size - 1
            return
        end if
        current => current%next
    end do
end subroutine delete_value_dlist

! Find the first occurrence of a value in the list
function find_value_dlist(this, value, found_node) result(found)
    class(dlist), intent(in) :: this
    integer, intent(in) :: value
    type(node), pointer, intent(out) :: found_node
    logical :: found
    type(node), pointer :: current
    found = .false.
    found_node => null()
    current => this%head
    do while (associated(current))
        if (current%value == value) then
            found = .true.
            found_node => current
            return
        end if
        current => current%next
    end do
end function find_value_dlist

! Reverse the list in-place
subroutine reverse_dlist(this)
    class(dlist), intent(inout) :: this
    type(node), pointer :: current, temp
    if (.not. associated(this%head) .or. .not. associated(this%head%next)) return
    current => this%head
    do while (associated(current))
        temp => current%prev
        current%prev => current%next
        current%next => temp
        current => current%prev
    end do
    temp => this%head
    this%head => this%tail
    this%tail => temp
    if (associated(this%tail)) this%tail%next => null()
    if (associated(this%head)) this%head%prev => null()
end subroutine reverse_dlist

! Remove duplicates, keeping the first occurrence (O(n) with hash table)
subroutine remove_duplicates_dlist(this)
    class(dlist), intent(inout) :: this
    integer, allocatable :: seen_values(:)
    type(node), pointer :: current, prev_node, to_delete
    integer :: count
    if (.not. associated(this%head)) return
    ! First pass to count unique values
    count = 0
    current => this%head
    do while (associated(current))
        count = count + 1
        current => current%next
    end do
    allocate(seen_values(count))
    seen_values = huge(0) ! Initialize with large value
    count = 0
    current => this%head
    prev_node => null()
    do while (associated(current))
        if (.not. any(seen_values(1:count) == current%value)) then
            count = count + 1
            seen_values(count) = current%value
            prev_node => current
            current => current%next
        else
            to_delete => current
            current => current%next
            if (associated(prev_node)) then
                prev_node%next => current
            else
                this%head => current
            end if
            if (associated(current)) then
                current%prev => prev_node
            else
                this%tail => prev_node
            end if
            deallocate(to_delete)
            this%size = this%size - 1
        end if
    end do
    deallocate(seen_values)
end subroutine remove_duplicates_dlist

! ==========================
! In-situ BST sort routine
! ==========================
subroutine dlist_tree_sort(this)
    class(dlist), intent(inout) :: this
    type(node), pointer :: root, current, next_node

    if (this%size < 2) return

    ! Phase 1: Build BST from list
    root => null()
    current => this%head
    do while (associated(current))
        next_node => current%next
        current%prev => null()
        current%next => null()
        call tree_insert(root, current)
        current => next_node
    end do

    ! Phase 2: Convert BST back to sorted list
    this%head => null()
    this%tail => null()
    call tree_to_list(this, root)
end subroutine dlist_tree_sort

recursive subroutine tree_insert(root, n)
    type(node), pointer, intent(inout) :: root
    type(node), pointer, intent(in) :: n
!
    if (.not. associated(root)) then
        root => n
        root%prev => null()
        root%next => null()
        return
    end if
    if (n%value < root%value) then
        call tree_insert(root%prev, n)
    else
        call tree_insert(root%next, n)
    end if
end subroutine tree_insert
recursive subroutine tree_to_list(this, n)
    class(dlist), intent(inout) :: this
    type(node), pointer, intent(in) :: n
    type(node), pointer :: right
    if (.not. associated(n)) return
    call tree_to_list(this, n%prev)
    right => n%next ! Save right child before modifying n%next
    if (.not. associated(this%head)) then
        this%head => n
        this%tail => n
        n%prev => null()
        n%next => null()
    else
        n%prev => this%tail
        this%tail%next => n
        this%tail => n
        n%next => null()
    end if
    call tree_to_list(this, right)
end subroutine tree_to_list

end module doubly_linked_list

! ==========================
! Test harness program
! ==========================

    program test_doubly_linked_list
    use doubly_linked_list
    implicit none
    type(dlist) :: list
    type(node), pointer :: found_node
    type(dlist_iterator) :: it
    logical :: found
    integer :: i, j
    real :: temp

    ! Test 1: Create empty list and print
    print *, 'Test 1: Empty list'
    call list%print_list()

    ! Test 2: Insert values in various orders (sorted)
    print *, 'Test 2: Insert sorted values (5, 2, 7, 2, 10, 4)'
    call list%insert_sorted(5)
    call list%insert_sorted(2)
    call list%insert_sorted(7)
    call list%insert_sorted(2)
    call list%insert_sorted(10)
    call list%insert_sorted(4)
    call list%print_list()

    ! Test 3: Insert values at head
    print *, 'Test 3: Insert at head (8, 1)'
    call list%insert_head(8)
    call list%insert_head(1)
    call list%print_list()

    ! Test 4: Insert values at tail
    print *, 'Test 4: Insert at tail (9, 12)'
    call list%insert_tail(9)
    call list%insert_tail(12)
    call list%print_list()

    ! Test 5: Delete value (2)
    print *, 'Test 5: Delete first occurrence of value 2'
    call list%delete_value(2)
    call list%print_list()

    ! Test 6: Find value (7)
    print *, 'Test 6: Find value 7'
    found = list%find_value(7, found_node)
    if (found) then
        print *, '  Value 7 found at node with value: ', found_node%value
    else
        print *, '  Value 7 not found'
    end if
    call list%print_list()

    ! Test 7: Reverse list (multi-node)
    print *, 'Test 7: Reverse list (multi-node)'
    call list%reverse()
    call list%print_list()

    ! Test 8: Remove duplicates (existing list)
    print *, 'Test 8: Remove duplicates from existing list'
    call list%remove_duplicates()
    call list%print_list()

    ! Test 9: Remove duplicates (list with non-consecutive duplicates)
    print *, 'Test 9: Insert non-consecutive duplicates (1, 1, 1, 4, 4, 1) and remove duplicates'
    call list%insert_sorted(1)
    call list%insert_sorted(-1)
    call list%insert_sorted(1)
    call list%insert_sorted(4)
    call list%insert_sorted(-4)
    call list%insert_sorted(4)
    call list%insert_tail(1)
    call list%print_list()
    call list%remove_duplicates()
    call list%print_list()

    ! Test 10: Remove duplicates (list with duplicates at head and tail)
    print *, 'Test 10: Create list with duplicates at head and tail (2, 2, 3, 4, 4)'
    call list%destroy()
    call list%insert_sorted(2)
    call list%insert_sorted(2)
    call list%insert_sorted(3)
    call list%insert_sorted(4)
    call list%insert_sorted(4)
    call list%print_list()
    call list%remove_duplicates()
    call list%print_list()

    ! Test 11: Remove duplicates (single node)
    print *, 'Test 11: Create single-node list and remove duplicates'
    call list%destroy()
    call list%insert_head(1)
    call list%print_list()
    call list%remove_duplicates()
    call list%print_list()

    ! Test 12: Remove duplicates (empty list)
    print *, 'Test 12: Remove duplicates from empty list'
    call list%destroy()
    call list%print_list()
    call list%remove_duplicates()
    call list%print_list()

    ! Test 13: Destroy list and verify
    print *, 'Test 13: Destroy list'
    call list%destroy()
    call list%print_list()

    ! Test 14: Insert at tail after destroy
    print *, 'Test 14: Insert at tail after destroy (6)'
    call list%insert_tail(6)
    call list%print_list()

    ! Test 15: Insert mixed (head, tail, sorted)
    print *, 'Test 15: Insert mixed (head: 2, sorted: 4, tail: 8)'
    call list%insert_head(2)
    call list%insert_sorted(4)
    call list%insert_tail(8)
    call list%print_list()

    ! Test 16: Final destroy
    print *, 'Test 16: Final destroy'
    call list%destroy()
    call list%print_list()

    ! Test 17: Remove duplicates (list with negative and large values)
    print *, 'Test 17: Create list with negative and large values (-5, -5, 100000, 3, 100000)'
    call list%destroy()
    call list%insert_sorted(5)
    call list%insert_sorted(15)
    call list%insert_sorted(19008)
    call list%insert_sorted(-33)
    call list%insert_sorted(-9000)
    call list%print_list()
    call list%remove_duplicates()
    call list%print_list()
!
    ! New iterator tests
    print *, 'Test 18: Forward iterator traversal'
    call list%destroy()
    call list%insert_tail(10)
    call list%insert_tail(20)
    call list%insert_tail(-30)
    call list%insert_tail(30)
    call list%insert_tail(130)
    call list%insert_tail(40)
    call list%insert_tail(99)
    call list%insert_tail(-300)

    it = list%begin()
    do while (it%valid())
        print *, '  Forward value: ', it%value()
        call it%next()
    end do

    print *, 'Test 19: Backward iterator traversal'
    it = list%end()
    do while (it%valid())
        print *, '  Backward value: ', it%value()
        call it%prev()
    end do
! Test 20: Sort mixed list
print *, 'Test 20: Sort mixed list (5, 2, 7, 2, 10, 4)'
call list%destroy()
call list%insert_tail(5)
call list%insert_tail(10)
call list%insert_tail(2)
call list%insert_tail(7)
call list%insert_tail(-7)
call list%insert_tail(2)
call list%insert_tail(10)
call list%insert_tail(4)
do i = 1,10
    call random_number(temp)
    j = ceiling(temp*33)
    if(mod(j,2) /=0)then
        call list%insert_tail(j)
    else
        call list%insert_head(j)
    endif
end do
call list%print_list()
call list%sort()
print *, 'After sorting:'
call list%print_list()

! Test 21: Sort reverse-ordered list
print *, 'Test 21: Sort reverse-ordered list (9, 6, 3, 1)'
call list%destroy()
call list%insert_tail(9)
call list%insert_tail(6)
call list%insert_tail(3)
call list%insert_tail(1)
call list%insert_tail(3)
call list%print_list()
call list%sort()
print *, 'After sorting:'
call list%print_list()

end program test_doubly_linked_list

