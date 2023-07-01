module avl_trees
  !
  ! References:
  !
  !   * Niklaus Wirth, 1976. Algorithms + Data Structures =
  !     Programs. Prentice-Hall, Englewood Cliffs, New Jersey.
  !
  !   * Niklaus Wirth, 2004. Algorithms and Data Structures. Updated
  !     by Fyodor Tkachov, 2014.
  !

  implicit none
  private

  ! The type for an AVL tree.
  public :: avl_tree_t

  ! The type for a pair of pointers to key and data within the tree.
  ! (Be careful with these!)
  public :: avl_pointer_pair_t

  ! Insertion, replacement, modification, etc.
  public :: avl_insert_or_modify

  ! Insert or replace.
  public :: avl_insert

  ! Is the key in the tree?
  public :: avl_contains

  ! Retrieve data from a tree.
  public :: avl_retrieve

  ! Delete data from a tree. This is a generic function.
  public :: avl_delete

  ! Implementations of avl_delete.
  public :: avl_delete_with_found
  public :: avl_delete_without_found

  ! How many nodes are there in the tree?
  public :: avl_size

  ! Return a list of avl_pointer_pair_t for the elements in the
  ! tree. The list will be in order.
  public :: avl_pointer_pairs

  ! Print a representation of the tree to an output unit.
  public :: avl_write

  ! Check the AVL condition (that the heights of the two branches from
  ! a node should differ by zero or one). ERROR STOP if the condition
  ! is not met.
  public :: avl_check

  ! Procedure types.
  public :: avl_less_than_t
  public :: avl_insertion_t
  public :: avl_key_data_writer_t

  type :: avl_node_t
     class(*), allocatable :: key, data
     type(avl_node_t), pointer :: left
     type(avl_node_t), pointer :: right
     integer :: bal             ! bal == -1, 0, 1
  end type avl_node_t

  type :: avl_tree_t
     type(avl_node_t), pointer :: p => null ()
   contains
     final :: avl_tree_t_final
  end type avl_tree_t

  type :: avl_pointer_pair_t
     class(*), pointer :: p_key, p_data
     class(avl_pointer_pair_t), pointer :: next => null ()
   contains
     final :: avl_pointer_pair_t_final
  end type avl_pointer_pair_t

  interface avl_delete
     module procedure avl_delete_with_found
     module procedure avl_delete_without_found
  end interface avl_delete

  interface
     function avl_less_than_t (key1, key2) result (key1_lt_key2)
       !
       ! The ordering predicate (‘<’).
       !
       ! Two keys a,b are considered equivalent if neither a<b nor
       ! b<a.
       !
       class(*), intent(in) :: key1, key2
       logical key1_lt_key2
     end function avl_less_than_t

     subroutine avl_insertion_t (key, data, p_is_new, p)
       !
       ! Insertion or modification of a found node.
       !
       import avl_node_t
       class(*), intent(in) :: key, data
       logical, intent(in) :: p_is_new
       type(avl_node_t), pointer, intent(inout) :: p
     end subroutine avl_insertion_t

     subroutine avl_key_data_writer_t (unit, key, data)
       !
       ! Printing the key and data of a node.
       !
       integer, intent(in) :: unit
       class(*), intent(in) :: key, data
     end subroutine avl_key_data_writer_t
  end interface

contains

  subroutine avl_tree_t_final (tree)
    type(avl_tree_t), intent(inout) :: tree

    type(avl_node_t), pointer :: p

    p => tree%p
    call free_the_nodes (p)

  contains

    recursive subroutine free_the_nodes (p)
      type(avl_node_t), pointer, intent(inout) :: p

      if (associated (p)) then
         call free_the_nodes (p%left)
         call free_the_nodes (p%right)
         deallocate (p)
      end if
    end subroutine free_the_nodes

  end subroutine avl_tree_t_final

  recursive subroutine avl_pointer_pair_t_final (node)
    type(avl_pointer_pair_t), intent(inout) :: node

    if (associated (node%next)) deallocate (node%next)
  end subroutine avl_pointer_pair_t_final

  function avl_contains (less_than, key, tree) result (found)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key
    class(avl_tree_t), intent(in) :: tree
    logical :: found

    found = avl_contains_recursion (less_than, key, tree%p)
  end function avl_contains

  recursive function avl_contains_recursion (less_than, key, p) result (found)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key
    type(avl_node_t), pointer, intent(in) :: p
    logical :: found

    if (.not. associated (p)) then
       found = .false.
    else if (less_than (key, p%key)) then
       found = avl_contains_recursion (less_than, key, p%left)
    else if (less_than (p%key, key)) then
       found = avl_contains_recursion (less_than, key, p%right)
    else
       found = .true.
    end if
  end function avl_contains_recursion

  subroutine avl_retrieve (less_than, key, tree, found, data)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key
    class(avl_tree_t), intent(in) :: tree
    logical, intent(out) :: found
    class(*), allocatable, intent(inout) :: data

    call avl_retrieve_recursion (less_than, key, tree%p, found, data)
  end subroutine avl_retrieve

  recursive subroutine avl_retrieve_recursion (less_than, key, p, found, data)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key
    type(avl_node_t), pointer, intent(in) :: p
    logical, intent(out) :: found
    class(*), allocatable, intent(inout) :: data

    if (.not. associated (p)) then
       found = .false.
    else if (less_than (key, p%key)) then
       call avl_retrieve_recursion (less_than, key, p%left, found, data)
    else if (less_than (p%key, key)) then
       call avl_retrieve_recursion (less_than, key, p%right, found, data)
    else
       found = .true.
       data = p%data
    end if
  end subroutine avl_retrieve_recursion

  subroutine avl_insert (less_than, key, data, tree)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key, data
    class(avl_tree_t), intent(inout) :: tree

    call avl_insert_or_modify (less_than, insert_or_replace, key, data, tree)
  end subroutine avl_insert

  subroutine insert_or_replace (key, data, p_is_new, p)
    class(*), intent(in) :: key, data
    logical, intent(in) :: p_is_new
    type(avl_node_t), pointer, intent(inout) :: p

    p%data = data
  end subroutine insert_or_replace

  subroutine avl_insert_or_modify (less_than, insertion, key, data, tree)
    procedure(avl_less_than_t) :: less_than
    procedure(avl_insertion_t) :: insertion ! Or modification in place.
    class(*), intent(in) :: key, data
    class(avl_tree_t), intent(inout) :: tree

    logical :: fix_balance

    fix_balance = .false.
    call insertion_search (less_than, insertion, key, data, tree%p, fix_balance)
  end subroutine avl_insert_or_modify

  recursive subroutine insertion_search (less_than, insertion, key, data, p, fix_balance)
    procedure(avl_less_than_t) :: less_than
    procedure(avl_insertion_t) :: insertion
    class(*), intent(in) :: key, data
    type(avl_node_t), pointer, intent(inout) :: p
    logical, intent(inout) :: fix_balance

    type(avl_node_t), pointer :: p1, p2

    if (.not. associated (p)) then
       ! The key was not found. Make a new node.
       allocate (p)
       p%key = key
       p%left => null ()
       p%right => null ()
       p%bal = 0
       call insertion (key, data, .true., p)
       fix_balance = .true.
    else if (less_than (key, p%key)) then
       ! Continue searching.
       call insertion_search (less_than, insertion, key, data, p%left, fix_balance)
       if (fix_balance) then
          ! A new node has been inserted on the left side.
          select case (p%bal)
          case (1)
             p%bal = 0
             fix_balance = .false.
          case (0)
             p%bal = -1
          case (-1)
             ! Rebalance.
             p1 => p%left
             select case (p1%bal)
             case (-1)
                ! A single LL rotation.
                p%left => p1%right
                p1%right => p
                p%bal = 0
                p => p1
                p%bal = 0
                fix_balance = .false.
             case (0, 1)
                ! A double LR rotation.
                p2 => p1%right
                p1%right => p2%left
                p2%left => p1
                p%left => p2%right
                p2%right => p
                p%bal = -(min (p2%bal, 0))
                p1%bal = -(max (p2%bal, 0))
                p => p2
                p%bal = 0
                fix_balance = .false.
             case default
                error stop
             end select
          case default
             error stop
          end select
       end if
    else if (less_than (p%key, key)) then
       call insertion_search (less_than, insertion, key, data, p%right, fix_balance)
       if (fix_balance) then
          ! A new node has been inserted on the right side.
          select case (p%bal)
          case (-1)
             p%bal = 0
             fix_balance = .false.
          case (0)
             p%bal = 1
          case (1)
             ! Rebalance.
             p1 => p%right
             select case (p1%bal)
             case (1)
                ! A single RR rotation.
                p%right => p1%left
                p1%left => p
                p%bal = 0
                p => p1
                p%bal = 0
                fix_balance = .false.
             case (-1, 0)
                ! A double RL rotation.
                p2 => p1%left
                p1%left => p2%right
                p2%right => p1
                p%right => p2%left
                p2%left => p
                p%bal = -(max (p2%bal, 0))
                p1%bal = -(min (p2%bal, 0))
                p => p2
                p%bal = 0
                fix_balance = .false.
             case default
                error stop
             end select
          case default
             error stop
          end select
       end if
    else
       ! The key was found. The pointer p points to an existing node.
       call insertion (key, data, .false., p)
    end if
  end subroutine insertion_search

  subroutine avl_delete_with_found (less_than, key, tree, found)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key
    class(avl_tree_t), intent(inout) :: tree
    logical, intent(out) :: found

    logical :: fix_balance

    fix_balance = .false.
    call deletion_search (less_than, key, tree%p, fix_balance, found)
  end subroutine avl_delete_with_found

  subroutine avl_delete_without_found (less_than, key, tree)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key
    class(avl_tree_t), intent(inout) :: tree

    logical :: found

    call avl_delete_with_found (less_than, key, tree, found)
  end subroutine avl_delete_without_found

  recursive subroutine deletion_search (less_than, key, p, fix_balance, found)
    procedure(avl_less_than_t) :: less_than
    class(*), intent(in) :: key
    type(avl_node_t), pointer, intent(inout) :: p
    logical, intent(inout) :: fix_balance
    logical, intent(out) :: found

    type(avl_node_t), pointer :: q

    if (.not. associated (p)) then
       ! The key is not in the tree.
       found = .false.
    else if (less_than (key, p%key)) then
       call deletion_search (less_than, key, p%left, fix_balance, found)
       if (fix_balance) call balance_for_shrunken_left (p, fix_balance)
    else if (less_than (p%key, key)) then
       call deletion_search (less_than, key, p%right, fix_balance, found)
       if (fix_balance) call balance_for_shrunken_right (p, fix_balance)
    else
       q => p
       if (.not. associated (q%right)) then
          p => q%left
          fix_balance = .true.
       else if (.not. associated (q%left)) then
          p => q%right
          fix_balance = .true.
       else
          call del (q%left, q, fix_balance)
          if (fix_balance) call balance_for_shrunken_left (p, fix_balance)
       end if
       deallocate (q)
       found = .true.
    end if
  end subroutine deletion_search

  recursive subroutine del (r, q, fix_balance)
    type(avl_node_t), pointer, intent(inout) :: r, q
    logical, intent(inout) :: fix_balance

    if (associated (r%right)) then
       call del (r%right, q, fix_balance)
       if (fix_balance) call balance_for_shrunken_right (r, fix_balance)
    else
       q%key = r%key
       q%data = r%data
       q => r
       r => r%left
       fix_balance = .true.
    end if
  end subroutine del

  subroutine balance_for_shrunken_left (p, fix_balance)
    type(avl_node_t), pointer, intent(inout) :: p
    logical, intent(inout) :: fix_balance

    ! The left side has lost a node.

    type(avl_node_t), pointer :: p1, p2

    if (.not. fix_balance) error stop

    select case (p%bal)
    case (-1)
       p%bal = 0
    case (0)
       p%bal = 1
       fix_balance = .false.
    case (1)
       ! Rebalance.
       p1 => p%right
       select case (p1%bal)
       case (0)
          ! A single RR rotation.
          p%right => p1%left
          p1%left => p
          p%bal = 1
          p1%bal = -1
          p => p1
          fix_balance = .false.
       case (1)
          ! A single RR rotation.
          p%right => p1%left
          p1%left => p
          p%bal = 0
          p1%bal = 0
          p => p1
          fix_balance = .true.
       case (-1)
          ! A double RL rotation.
          p2 => p1%left
          p1%left => p2%right
          p2%right => p1
          p%right => p2%left
          p2%left => p
          p%bal = -(max (p2%bal, 0))
          p1%bal = -(min (p2%bal, 0))
          p => p2
          p2%bal = 0
       case default
          error stop
       end select
    case default
       error stop
    end select
  end subroutine balance_for_shrunken_left

  subroutine balance_for_shrunken_right (p, fix_balance)
    type(avl_node_t), pointer, intent(inout) :: p
    logical, intent(inout) :: fix_balance

    ! The right side has lost a node.

    type(avl_node_t), pointer :: p1, p2

    if (.not. fix_balance) error stop

    select case (p%bal)
    case (1)
       p%bal = 0
    case (0)
       p%bal = -1
       fix_balance = .false.
    case (-1)
       ! Rebalance.
       p1 => p%left
       select case (p1%bal)
       case (0)
          ! A single LL rotation.
          p%left => p1%right
          p1%right => p
          p1%bal = 1
          p%bal = -1
          p => p1
          fix_balance = .false.
       case (-1)
          ! A single LL rotation.
          p%left => p1%right
          p1%right => p
          p1%bal = 0
          p%bal = 0
          p => p1
          fix_balance = .true.
       case (1)
          ! A double LR rotation.
          p2 => p1%right
          p1%right => p2%left
          p2%left => p1
          p%left => p2%right
          p2%right => p
          p%bal = -(min (p2%bal, 0))
          p1%bal = -(max (p2%bal, 0))
          p => p2
          p2%bal = 0
       case default
          error stop
       end select
    case default
       error stop
    end select
  end subroutine balance_for_shrunken_right

  function avl_size (tree) result (size)
    class(avl_tree_t), intent(in) :: tree
    integer :: size

    size = traverse (tree%p)

  contains

    recursive function traverse (p) result (size)
      type(avl_node_t), pointer, intent(in) :: p
      integer :: size

      if (associated (p)) then
         ! The order of traversal is arbitrary.
         size = 1 + traverse (p%left) + traverse (p%right)
      else
         size = 0
      end if
    end function traverse

  end function avl_size

  function avl_pointer_pairs (tree) result (lst)
    class(avl_tree_t), intent(in) :: tree
    type(avl_pointer_pair_t), pointer :: lst

    ! Reverse in-order traversal of the tree, to produce a CONS-list
    ! of pointers to the contents.

    lst => null ()
    if (associated (tree%p)) lst => traverse (tree%p, lst)

  contains

    recursive function traverse (p, lst1) result (lst2)
      type(avl_node_t), pointer, intent(in) :: p
      type(avl_pointer_pair_t), pointer, intent(in) :: lst1
      type(avl_pointer_pair_t), pointer :: lst2

      type(avl_pointer_pair_t), pointer :: new_entry

      lst2 => lst1
      if (associated (p%right)) lst2 => traverse (p%right, lst2)
      allocate (new_entry)
      new_entry%p_key => p%key
      new_entry%p_data => p%data
      new_entry%next => lst2
      lst2 => new_entry
      if (associated (p%left)) lst2 => traverse (p%left, lst2)
    end function traverse

  end function avl_pointer_pairs

  subroutine avl_write (write_key_data, unit, tree)
    procedure(avl_key_data_writer_t) :: write_key_data
    integer, intent(in) :: unit
    class(avl_tree_t), intent(in) :: tree

    character(len = *), parameter :: tab = achar (9)

    type(avl_node_t), pointer :: p

    p => tree%p
    if (.not. associated (p)) then
       continue
    else
       call traverse (p%left, 1, .true.)
       call write_key_data (unit, p%key, p%data)
       write (unit, '(2A, "depth = ", I0, "  bal = ", I0)') tab, tab, 0, p%bal
       call traverse (p%right, 1, .false.)
    end if

  contains

    recursive subroutine traverse (p, depth, left)
      type(avl_node_t), pointer, intent(in) :: p
      integer, value :: depth
      logical, value :: left

      if (.not. associated (p)) then
         continue
      else
         call traverse (p%left, depth + 1, .true.)
         call pad (depth, left)
         call write_key_data (unit, p%key, p%data)
         write (unit, '(2A, "depth = ", I0, "  bal = ", I0)') tab, tab, depth, p%bal
         call traverse (p%right, depth + 1, .false.)
      end if
    end subroutine traverse

    subroutine pad (depth, left)
      integer, value :: depth
      logical, value :: left

      integer :: i

      do i = 1, depth
         write (unit, '(2X)', advance = 'no')
      end do
    end subroutine pad

  end subroutine avl_write

  subroutine avl_check (tree)
    use, intrinsic :: iso_fortran_env, only: error_unit
    class(avl_tree_t), intent(in) :: tree

    type(avl_node_t), pointer :: p
    integer :: height_L, height_R

    p => tree%p
    call get_heights (p, height_L, height_R)
    call check_heights (height_L, height_R)

  contains

    recursive subroutine get_heights (p, height_L, height_R)
      type(avl_node_t), pointer, intent(in) :: p
      integer, intent(out) :: height_L, height_R

      integer :: height_LL, height_LR
      integer :: height_RL, height_RR

      height_L = 0
      height_R = 0
      if (associated (p)) then
         call get_heights (p%left, height_LL, height_LR)
         call check_heights (height_LL, height_LR)
         height_L = height_LL + height_LR
         call get_heights (p%right, height_RL, height_RR)
         call check_heights (height_RL, height_RR)
         height_R = height_RL + height_RR
      end if
    end subroutine get_heights

    subroutine check_heights (height_L, height_R)
      integer, value :: height_L, height_R

      if (2 <= abs (height_L - height_R)) then
         write (error_unit, '("*** AVL condition violated ***")')
         error stop
      end if
    end subroutine check_heights

  end subroutine avl_check

end module avl_trees

program avl_trees_demo
  use, intrinsic :: iso_fortran_env, only: output_unit
  use, non_intrinsic :: avl_trees

  implicit none

  integer, parameter :: keys_count = 20

  type(avl_tree_t) :: tree
  logical :: found
  class(*), allocatable :: retval
  integer :: the_keys(1:keys_count)
  integer :: i, j

  do i = 1, keys_count
     the_keys(i) = i
  end do
  call fisher_yates_shuffle (the_keys, keys_count)

  call avl_check (tree)
  do i = 1, keys_count
     call avl_insert (lt, the_keys(i), real (the_keys(i)), tree)
     call avl_check (tree)
     if (avl_size (tree) /= i) error stop
     do j = 1, keys_count
        if (avl_contains (lt, the_keys(j), tree) .neqv. (j <= i)) error stop
     end do
     do j = 1, keys_count
        call avl_retrieve (lt, the_keys(j), tree, found, retval)
        if (found .neqv. (j <= i)) error stop
        if (found) then
           ! This crazy way to write ‘/=’ is to quell those tiresome
           ! warnings about using ‘==’ or ‘/=’ with floating point
           ! numbers. Floating point numbers can represent integers
           ! *exactly*.
           if (0 < abs (real_cast (retval) - real (the_keys(j)))) error stop
        end if
        if (found) then
           block
             character(len = 1), parameter :: ch = '*'
             !
             ! Try replacing the data with a character and then
             ! restoring the number.
             !
             call avl_insert (lt, the_keys(j), ch, tree)
             call avl_retrieve (lt, the_keys(j), tree, found, retval)
             if (.not. found) error stop
             if (char_cast (retval) /= ch) error stop
             call avl_insert (lt, the_keys(j), real (the_keys(j)), tree)
             call avl_retrieve (lt, the_keys(j), tree, found, retval)
             if (.not. found) error stop
             if (0 < abs (real_cast (retval) - real (the_keys(j)))) error stop
           end block
        end if
     end do
  end do

  write (output_unit, '(70("-"))')
  call avl_write (int_real_writer, output_unit, tree)
  write (output_unit, '(70("-"))')
  call print_contents (output_unit, tree)
  write (output_unit, '(70("-"))')

  call fisher_yates_shuffle (the_keys, keys_count)
  do i = 1, keys_count
     call avl_delete (lt, the_keys(i), tree)
     call avl_check (tree)
     if (avl_size (tree) /= keys_count - i) error stop
     ! Try deleting a second time.
     call avl_delete (lt, the_keys(i), tree)
     call avl_check (tree)
     if (avl_size (tree) /= keys_count - i) error stop
     do j = 1, keys_count
        if (avl_contains (lt, the_keys(j), tree) .neqv. (i < j)) error stop
     end do
     do j = 1, keys_count
        call avl_retrieve (lt, the_keys(j), tree, found, retval)
        if (found .neqv. (i < j)) error stop
        if (found) then
           if (0 < abs (real_cast (retval) - real (the_keys(j)))) error stop
        end if
     end do
  end do

contains

  subroutine fisher_yates_shuffle (keys, n)
    integer, intent(inout) :: keys(*)
    integer, intent(in) :: n

    integer :: i, j
    real :: randnum
    integer :: tmp

    do i = 1, n - 1
       call random_number (randnum)
       j = i + floor (randnum * (n - i + 1))
       tmp = keys(i)
       keys(i) = keys(j)
       keys(j) = tmp
    end do
  end subroutine fisher_yates_shuffle

  function int_cast (u) result (v)
    class(*), intent(in) :: u
    integer :: v

    select type (u)
    type is (integer)
       v = u
    class default
       ! This case is not handled.
       error stop
    end select
  end function int_cast

  function real_cast (u) result (v)
    class(*), intent(in) :: u
    real :: v

    select type (u)
    type is (real)
       v = u
    class default
       ! This case is not handled.
       error stop
    end select
  end function real_cast

  function char_cast (u) result (v)
    class(*), intent(in) :: u
    character(len = 1) :: v

    select type (u)
    type is (character(*))
       v = u
    class default
       ! This case is not handled.
       error stop
    end select
  end function char_cast

  function lt (u, v) result (u_lt_v)
    class(*), intent(in) :: u, v
    logical :: u_lt_v

    select type (u)
    type is (integer)
       select type (v)
       type is (integer)
          u_lt_v = (u < v)
       class default
          ! This case is not handled.
          error stop
       end select
    class default
       ! This case is not handled.
       error stop
    end select
  end function lt

  subroutine int_real_writer (unit, key, data)
    integer, intent(in) :: unit
    class(*), intent(in) :: key, data

    write (unit, '("(", I0, ", ", F0.1, ")")', advance = 'no') &
         & int_cast(key), real_cast(data)
  end subroutine int_real_writer

  subroutine print_contents (unit, tree)
    integer, intent(in) :: unit
    class(avl_tree_t), intent(in) :: tree

    type(avl_pointer_pair_t), pointer :: ppairs, pp

    write (unit, '("tree size = ", I0)') avl_size (tree)
    ppairs => avl_pointer_pairs (tree)
    pp => ppairs
    do while (associated (pp))
       write (unit, '("(", I0, ", ", F0.1, ")")') &
            & int_cast (pp%p_key), real_cast (pp%p_data)
       pp => pp%next
    end do
    if (associated (ppairs)) deallocate (ppairs)
  end subroutine print_contents

end program avl_trees_demo
