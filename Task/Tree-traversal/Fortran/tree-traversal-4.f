! =============================================================================
! tree_traversal.f90
!
! Demonstrates four classic binary-tree traversal algorithms on the following
! hand-built nine-node tree:
!
!          1
!         / \
!        2   3
!       / \ /
!      4  5 6
!     /   / \
!    7   8   9
!
! Expected output:
!   preorder:    1 2 4 7 5 3 6 8 9
!   inorder:     7 4 2 5 1 8 6 9 3
!   postorder:   7 4 5 2 8 9 6 3 1
!   level-order: 1 2 3 4 5 6 7 8 9
! =============================================================================
program tree_traversal
    implicit none

    ! ------------------------------------------------------------------
    ! node -- one element of the binary tree.
    !   val   : the integer payload stored at this node
    !   left  : pointer to the left  child (null => no left  child)
    !   right : pointer to the right child (null => no right child)
    ! ------------------------------------------------------------------
    type :: node
        integer             :: val
        type(node), pointer :: left  => null()
        type(node), pointer :: right => null()
    end type node

    ! ------------------------------------------------------------------
    ! node_ptr -- thin wrapper that lets us build an array of pointers.
    ! Fortran does not allow "type(node), pointer :: arr(n)" directly, so
    ! we embed the pointer in a derived type and make an array of that.
    ! Used only by level_order as a fixed-size FIFO queue.
    ! ------------------------------------------------------------------
    type :: node_ptr
        type(node), pointer :: p => null()
    end type node_ptr

    ! root is the entry point to the whole tree
    type(node), pointer :: root

    ! ------------------------------------------------------------------
    ! Build the tree by allocating nodes one at a time and wiring up the
    ! parent/child pointer relationships.  new_node() allocates a fresh
    ! node, stores the value, and nullifies both child pointers.
    !
    ! Visual layout of pointer assignments below:
    !
    !   root (1)
    !    +-- left  --> (2)
    !    |              +-- left  --> (4)
    !    |              |              +-- left  --> (7)   [leaf]
    !    |              |              +-- right --> [none]
    !    |              +-- right --> (5)   [leaf]
    !    +-- right --> (3)
    !                   +-- left  --> (6)
    !                   |              +-- left  --> (8)   [leaf]
    !                   |              +-- right --> (9)   [leaf]
    !                   +-- right --> [none]
    ! ------------------------------------------------------------------
    root                      => new_node(1)   ! tree root
    root%left                 => new_node(2)   ! depth 1, left subtree
    root%right                => new_node(3)   ! depth 1, right subtree
    root%left%left            => new_node(4)   ! depth 2
    root%left%right           => new_node(5)   ! depth 2, leaf
    root%right%left           => new_node(6)   ! depth 2
    root%left%left%left       => new_node(7)   ! depth 3, leaf
    root%right%left%left      => new_node(8)   ! depth 3, leaf
    root%right%left%right     => new_node(9)   ! depth 3, leaf

    ! ------------------------------------------------------------------
    ! Preorder: root -> left subtree -> right subtree
    ! Each node is visited BEFORE its children, so the root always
    ! appears first and every subtree root appears before its descendants.
    ! ------------------------------------------------------------------
    write(*,'(a)', advance='no') 'preorder:    '
    call preorder(root)
    write(*,*)                                  ! newline after values

    ! ------------------------------------------------------------------
    ! Inorder: left subtree -> root -> right subtree
    ! For a binary SEARCH tree this would yield sorted ascending order,
    ! but this tree is not a BST -- it merely demonstrates the traversal.
    ! ------------------------------------------------------------------
    write(*,'(a)', advance='no') 'inorder:     '
    call inorder(root)
    write(*,*)

    ! ------------------------------------------------------------------
    ! Postorder: left subtree -> right subtree -> root
    ! Each node is visited AFTER both its children, so the root always
    ! appears last.  Useful for safely deallocating a tree (free children
    ! before the parent).
    ! ------------------------------------------------------------------
    write(*,'(a)', advance='no') 'postorder:   '
    call postorder(root)
    write(*,*)

    ! ------------------------------------------------------------------
    ! Level-order (breadth-first): visit every node at depth d before any
    ! node at depth d+1, scanning left to right within each level.
    ! Implemented iteratively with a FIFO queue rather than recursion.
    ! ------------------------------------------------------------------
    write(*,'(a)', advance='no') 'level-order: '
    call level_order(root)
    write(*,*)

contains

    ! ------------------------------------------------------------------
    ! new_node(val)
    !   Allocate a new tree node, store val, null both child pointers.
    !   Returns a pointer to the newly allocated node.
    ! ------------------------------------------------------------------
    function new_node(val) result(n)
        integer, intent(in) :: val
        type(node), pointer :: n
        allocate(n)           ! heap-allocate one node record
        n%val   =  val
        n%left  => null()     ! no left  child yet
        n%right => null()     ! no right child yet
    end function new_node

    ! ------------------------------------------------------------------
    ! preorder(n)  --  recursive, depth-first
    !   Visit pattern:  SELF  left  right
    !   Base case: if n is not associated (null pointer) do nothing.
    ! ------------------------------------------------------------------
    recursive subroutine preorder(n)
        type(node), pointer, intent(in) :: n
        if (.not. associated(n)) return         ! null pointer: nothing to do
        write(*,'(i0," ")', advance='no') n%val ! print this node first
        call preorder(n%left)                   ! then recurse into left child
        call preorder(n%right)                  ! then recurse into right child
    end subroutine preorder

    ! ------------------------------------------------------------------
    ! inorder(n)  --  recursive, depth-first
    !   Visit pattern:  left  SELF  right
    !   The left subtree is fully exhausted before the current node is
    !   printed, and the right subtree is visited last.
    ! ------------------------------------------------------------------
    recursive subroutine inorder(n)
        type(node), pointer, intent(in) :: n
        if (.not. associated(n)) return         ! base case: null pointer
        call inorder(n%left)                    ! recurse left first
        write(*,'(i0," ")', advance='no') n%val ! print this node second
        call inorder(n%right)                   ! recurse right last
    end subroutine inorder

    ! ------------------------------------------------------------------
    ! postorder(n)  --  recursive, depth-first
    !   Visit pattern:  left  right  SELF
    !   Both subtrees are fully exhausted before the current node is
    !   printed, so leaves always appear before their parents.
    ! ------------------------------------------------------------------
    recursive subroutine postorder(n)
        type(node), pointer, intent(in) :: n
        if (.not. associated(n)) return         ! base case: null pointer
        call postorder(n%left)                  ! recurse left
        call postorder(n%right)                 ! recurse right
        write(*,'(i0," ")', advance='no') n%val ! print this node last
    end subroutine postorder

    ! ------------------------------------------------------------------
    ! level_order(root_node)  --  iterative, breadth-first
    !
    ! Algorithm (standard BFS with a FIFO queue):
    !   1. Enqueue the root.
    !   2. While the queue is non-empty:
    !        a. Dequeue the front node.
    !        b. Print its value.
    !        c. Enqueue its left  child if it exists.
    !        d. Enqueue its right child if it exists.
    !
    ! Queue implementation: a fixed-size array of node_ptr wrappers.
    !   head  = index of the next item to dequeue (front of queue)
    !   tail  = index of the next free slot        (back  of queue)
    !   The queue holds at most 100 pointers; plenty for this 9-node tree.
    !   head < tail  means the queue is non-empty.
    ! ------------------------------------------------------------------
    subroutine level_order(root_node)
        type(node), pointer, intent(in) :: root_node
        type(node_ptr) :: queue(100)    ! fixed-size array-based FIFO queue
        type(node),  pointer :: cur     ! node being processed this iteration
        integer :: head                 ! index of front element (next dequeue)
        integer :: tail                 ! index of next free slot (next enqueue)

        ! Initialise queue with just the root
        head = 1
        tail = 1
        queue(tail)%p => root_node      ! enqueue root at position 1
        tail = tail + 1                 ! tail now points to next free slot (2)

        ! Process until the queue is drained
        do while (head < tail)          ! head == tail means queue is empty
            cur => queue(head)%p        ! dequeue: read the front element
            head = head + 1             ! advance head (slot is now "consumed")

            write(*,'(i0," ")', advance='no') cur%val  ! visit: print value

            ! Enqueue left child if it exists
            if (associated(cur%left)) then
                queue(tail)%p => cur%left
                tail = tail + 1
            end if

            ! Enqueue right child if it exists
            if (associated(cur%right)) then
                queue(tail)%p => cur%right
                tail = tail + 1
            end if
        end do
    end subroutine level_order

end program tree_traversal
