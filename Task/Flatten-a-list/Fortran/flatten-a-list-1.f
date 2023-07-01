! input   : [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
! flatten : [1, 2, 3, 4, 5, 6, 7, 8 ]

module flat
  implicit none

  type n
     integer                             :: a
     type(n), dimension(:), pointer      :: p => null()
     logical                             :: empty = .false.
  end type

contains

  recursive subroutine del(this)
  type(n), intent(inout) :: this
  integer                :: i
  if (associated(this%p)) then
    do i = 1, size(this%p)
       call del(this%p(i))
    end do
  end if
  end subroutine

  function join(xs) result (r)
  type(n), dimension(:), target :: xs
  type(n)                       :: r
  integer                       :: i
  if (size(xs)>0) then
    allocate(r%p(size(xs)), source=xs)
    do i = 1, size(xs)
      r%p(i) = xs(i)
    end do
  else
    r%empty = .true.
  end if
  end function

  recursive subroutine flatten1(x,r)
  integer, dimension (:), allocatable, intent(inout) :: r
  type(n), intent(in)                                :: x
  integer, dimension (:), allocatable                :: tmp
  integer                                            :: i
  if (associated(x%p)) then
    do i = 1, size(x%p)
      call flatten1(x%p(i), r)
    end do
  elseif (.not. x%empty) then
    allocate(tmp(size(r)+1))
    tmp(1:size(r)) = r
    tmp(size(r)+1) = x%a
    call move_alloc(tmp, r)
  end if
  end subroutine

  function flatten(x) result (r)
  type(n), intent(in)                                :: x
  integer, dimension(:), allocatable                 :: r
  allocate(r(0))
  call flatten1(x,r)
  end function

  recursive subroutine show(x)
  type(n)   :: x
  integer   :: i
  if (x%empty) then
    write (*, "(a)", advance="no") "[]"
  elseif (associated(x%p)) then
    write (*, "(a)", advance="no") "["
    do i = 1, size(x%p)
      call show(x%p(i))
      if (i<size(x%p)) then
        write (*, "(a)", advance="no") ", "
      end if
    end do
    write (*, "(a)", advance="no") "]"
  else
    write (*, "(g0)", advance="no") x%a
  end if
  end subroutine

  function fromString(line) result (r)
  character(len=*)                      :: line
  type (n)                              :: r
  type (n), dimension(:), allocatable   :: buffer, buffer1
  integer, dimension(:), allocatable    :: stack, stack1
  integer                               :: sp,i0,i,j, a, cur, start
  character                             :: c

  if (.not. allocated(buffer)) then
    allocate (buffer(5)) ! will be re-allocated if more is needed
  end if
  if (.not. allocated(stack)) then
    allocate (stack(5))
  end if

  sp = 1; cur = 1; i = 1
  do
    if ( i > len_trim(line) ) exit
    c = line(i:i)
    if (c=="[") then
      if (sp>size(stack)) then
        allocate(stack1(2*size(stack)))
        stack1(1:size(stack)) = stack
        call move_alloc(stack1, stack)
      end if
      stack(sp) = cur;  sp = sp + 1; i = i+1
    elseif (c=="]") then
      sp = sp - 1; start = stack(sp)
      r = join(buffer(start:cur-1))
      do j = start, cur-1
        call del(buffer(j))
      end do
      buffer(start) = r; cur = start+1; i = i+1
    elseif (index(" ,",c)>0) then
      i = i + 1; continue
    elseif (index("-123456789",c)>0) then
      i0 = i
      do
        if ((i>len_trim(line)).or. &
            index("1234567890",line(i:i))==0) then
          read(line(i0:i-1),*) a
          if (cur>size(buffer)) then
            allocate(buffer1(2*size(buffer)))
            buffer1(1:size(buffer)) = buffer
            call move_alloc(buffer1, buffer)
          end if
          buffer(cur) = n(a); cur = cur + 1; exit
        else
          i = i+1
        end if
      end do
    else
       stop "input corrupted"
    end if
  end do
  end function
end module

program main
  use flat
  type (n)  :: x
  x = fromString("[[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]")
  write(*, "(a)", advance="no") "input   : "
  call show(x)
  print *
  write (*,"(a)", advance="no") "flatten : ["
  write (*, "(*(i0,:,:', '))", advance="no") flatten(x)
  print *, "]"
end program
