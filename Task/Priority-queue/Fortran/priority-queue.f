module priority_queue_mod
implicit none

type node
  character (len=100)              :: task
  integer                          :: priority
end type

type queue
  type(node), allocatable :: buf(:)
  integer                 :: n = 0
contains
  procedure :: top
  procedure :: enqueue
  procedure :: siftdown
end type

contains

subroutine siftdown(this, a)
  class (queue)           :: this
  integer                 :: a, parent, child
  associate (x => this%buf)
  parent = a
  do while(parent*2 <= this%n)
    child = parent*2
    if (child + 1 <= this%n) then
      if (x(child+1)%priority > x(child)%priority ) then
        child = child +1
      end if
    end if
    if (x(parent)%priority < x(child)%priority) then
      x([child, parent]) = x([parent, child])
      parent = child
    else
      exit
    end if
  end do
  end associate
end subroutine

function top(this) result (res)
  class(queue) :: this
  type(node)   :: res
  res = this%buf(1)
  this%buf(1) = this%buf(this%n)
  this%n = this%n - 1
  call this%siftdown(1)
end function

subroutine enqueue(this, priority, task)
  class(queue), intent(inout) :: this
  integer                     :: priority
  character(len=*)            :: task
  type(node)                  :: x
  type(node), allocatable     :: tmp(:)
  integer                     :: i
  x%priority = priority
  x%task = task
  this%n = this%n +1
  if (.not.allocated(this%buf)) allocate(this%buf(1))
  if (size(this%buf)<this%n) then
    allocate(tmp(2*size(this%buf)))
    tmp(1:this%n-1) = this%buf
    call move_alloc(tmp, this%buf)
  end if
  this%buf(this%n) = x
  i = this%n
  do
    i = i / 2
    if (i==0) exit
    call this%siftdown(i)
  end do
end subroutine
end module

program main
  use priority_queue_mod

  type (queue) :: q
  type (node)  :: x

  call q%enqueue(3, "Clear drains")
  call q%enqueue(4, "Feed cat")
  call q%enqueue(5, "Make Tea")
  call q%enqueue(1, "Solve RC tasks")
  call q%enqueue(2, "Tax return")

  do while (q%n >0)
    x = q%top()
    print "(g0,a,a)", x%priority, " -> ", trim(x%task)
  end do

end program

! Output:
! 5 -> Make Tea
! 4 -> Feed cat
! 3 -> Clear drains
! 2 -> Tax return
! 1 -> Solve RC tasks
