module mod_stack

  implicit none
  type node
    ! data entry in each node
    real*8, private :: data
    ! pointer to the next node of the linked list
    type(node), pointer, private :: next
  end type node
  private node

  type stack
    ! pointer to first element of stack.
    type(node), pointer, private :: first
    ! size of stack
    integer, private :: len=0
  contains
    procedure :: pop
    procedure :: push
    procedure :: peek
    procedure :: getSize
    procedure :: clearStack
    procedure :: isEmpty
  end type stack

contains

  function pop(this) result(x)
    class(stack) :: this
    real*8 :: x
    type(node), pointer :: tmp
    if ( this%len == 0 ) then
      print*, "popping from empty stack"
      !stop
    end if
    tmp => this%first
    x = this%first%data
    this%first => this%first%next
    deallocate(tmp)
    this%len = this%len -1
  end function pop

  subroutine push(this, x)
    real*8 :: x
    class(stack), target :: this
    type(node), pointer :: new, tmp
    allocate(new)
    new%data = x
    if (.not. associated(this%first)) then
      this%first => new
    else
      tmp => this%first
      this%first => new
      this%first%next => tmp
    end if
    this%len = this%len + 1
  end subroutine push

  function peek(this) result(x)
    class(stack) :: this
    real*8 :: x
    x = this%first%data
  end function peek

  function getSize(this) result(n)
    class(stack) :: this
    integer :: n
    n = this%len
  end function getSize

  function isEmpty(this) result(empty)
    class(stack) :: this
    logical :: empty
    if ( this%len > 0 ) then
      empty = .FALSE.
    else
      empty = .TRUE.
    end if
  end function isEmpty

  subroutine clearStack(this)
    class(stack) :: this
    type(node), pointer :: tmp
    integer :: i
    if ( this%len == 0 ) then
      return
    end if
    do i = 1, this%len
      tmp => this%first
      if ( .not. associated(tmp)) exit
      this%first => this%first%next
      deallocate(tmp)
    end do
    this%len = 0
  end subroutine clearStack
end module mod_stack

program main
  use mod_stack
  type(stack) :: my_stack
  integer :: i
  real*8 :: dat
  do i = 1, 5, 1
    dat = 1.0 * i
    call my_stack%push(dat)
  end do
  do while ( .not. my_stack%isEmpty() )
    print*, my_stack%pop()
  end do
  call my_stack%clearStack()
end program main
