!-----------------------------------------------------------------------
!  Nest --> Indent tree conversion  (pretty-print version)
!-----------------------------------------------------------------------
module tree_m
  implicit none

  !-------------- nested (recursive) representation ------------------
  type :: nest_node
    character(len=:), allocatable :: name
    type(nest_node), allocatable  :: children(:)
  contains
    procedure :: to_string => nest_to_string
    procedure :: to_indent => nest_to_indent
    procedure :: print_nest
  end type nest_node

  !-------------- flat (indent-level) representation ---------------
  type :: indent_node
    integer                       :: level = 0
    character(len=:), allocatable :: name
  end type indent_node

contains

!=======================================================================
!  nest -> character string  (compact bracket form)
!=======================================================================
  recursive function nest_to_string(this) result(s)
    class(nest_node), intent(in) :: this
    character(len=:), allocatable :: s
    integer :: i
    s = trim(this%name)
    if (allocated(this%children)) then
      s = s // '('
      do i = 1, size(this%children)
        s = s // trim(this%children(i)%to_string())
        if (i < size(this%children)) s = s // ','
      end do
      s = s // ')'
    end if
  end function nest_to_string

!=======================================================================
!  pretty print nest tree in outline form
!=======================================================================
  recursive subroutine print_nest(this, depth)
    class(nest_node), intent(in) :: this
    integer, intent(in), optional :: depth
    integer :: d, i
    d = 0; if (present(depth)) d = depth
    print '(a)', repeat('    ',d) // trim(this%name)
    if (allocated(this%children)) then
      do i = 1, size(this%children)
        call this%children(i)%print_nest(d+1)
      end do
    end if
  end subroutine print_nest

!=======================================================================
!  nest -> list of indent_node  (depth-first walk)
!=======================================================================
  recursive subroutine nest_to_indent(this, list, depth)
    class(nest_node), intent(in)               :: this
    type(indent_node), allocatable, intent(inout) :: list(:)
    integer, intent(in), optional              :: depth
    integer :: d, n
    d = 0; if (present(depth)) d = depth
    if (.not. allocated(list)) allocate(list(0))
    n = size(list)
    list = [list, indent_node(d, this%name)]
    if (allocated(this%children)) then
      do n = 1, size(this%children)
        call this%children(n)%to_indent(list, d+1)
      end do
    end if
  end subroutine nest_to_indent

!=======================================================================
!  indent list -> nest tree
!=======================================================================
  function indent_to_nest(list) result(root)
    type(indent_node), intent(in) :: list(:)
    type(nest_node), pointer      :: root

    type :: tagged
      type(nest_node), allocatable :: node
      integer                      :: level = 0
    end type tagged

    type(tagged), allocatable :: stack(:)
    integer :: i, top

    top = 0
    allocate(stack(0))

    do i = 1, size(list)
      block
        type(tagged),target :: fresh
        allocate(fresh%node)
        fresh%node%name = list(i)%name
        fresh%level     = list(i)%level

        do while (top > 0 .and. stack(top)%level >= list(i)%level)
          top = top - 1
        end do

        if (top == 0) then
          root => fresh%node
        else
          if (.not. allocated(stack(top)%node%children)) &
               allocate(stack(top)%node%children(0))
          stack(top)%node%children = [stack(top)%node%children, fresh%node]
        end if

        top = top + 1
        if (top > size(stack)) stack = [stack, fresh]
        stack(top) = fresh
      end block
    end do
  end function indent_to_nest

!=======================================================================
!  pretty print indent list
!=======================================================================
  subroutine print_indent(list)
    type(indent_node), intent(in) :: list(:)
    integer :: i
    do i = 1, size(list)
      print '(i0,1x,a)', list(i)%level, list(i)%name
    end do
  end subroutine print_indent

end module tree_m

!#######################################################################
!  Demonstration
!#######################################################################
program demo
  use tree_m
  implicit none
  type(nest_node), pointer :: root, final
  type(indent_node), allocatable :: flat(:)

  !------------------------------------------------------------------
  ! 1.  Build the example tree by hand (nest form)
  !------------------------------------------------------------------
  allocate(root)
  root%name = "RosettaCode"
  allocate(root%children(2))

  root%children(1)%name = "rocks"
  allocate(root%children(1)%children(3))
  root%children(1)%children(1)%name = "code"
  root%children(1)%children(2)%name = "comparison"
  root%children(1)%children(3)%name = "wiki"

  root%children(2)%name = "mocks"
  allocate(root%children(2)%children(1))
  root%children(2)%children(1)%name = "trolling"

  !------------------------------------------------------------------
  ! 2.  Initial nest form (outline)
  !------------------------------------------------------------------
  print *, "==Nest form=="
  call root%print_nest()
  print *

  !------------------------------------------------------------------
  ! 3.  Convert to indent form and display
  !------------------------------------------------------------------
  call root%to_indent(flat)
  print *, "==Indent form=="
  call print_indent(flat)
  print *

  !------------------------------------------------------------------
  ! 4.  Convert back to nest form and display (outline)
  !------------------------------------------------------------------
  final => indent_to_nest(flat)
  print *, "==Nest form=="
  call final%print_nest()
  print *
  print*, 'They are equal. There is only one data structure that is traversed differently'
end program demo
