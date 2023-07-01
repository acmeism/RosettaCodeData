! output:
! d-> 00000, t-> 00001, h-> 0001, s-> 0010,
! c-> 00110, x-> 00111, m-> 0100, o-> 0101,
! n-> 011, u-> 10000, l-> 10001, a-> 1001,
! r-> 10100, g-> 101010, p-> 101011,
! e-> 1011, i-> 1100, f-> 1101,  -> 111
!
! 00001|0001|1100|0010|111|1100|0010|111|1001|011|
! 111|1011|00111|1001|0100|101011|10001|1011|111|
! 1101|0101|10100|111|0001|10000|1101|1101|0100|
! 1001|011|111|1011|011|00110|0101|00000|1100|011|101010|
!
module huffman
implicit none
type node
  character (len=1 ), allocatable :: sym(:)
  character (len=10), allocatable :: code(:)
  integer                         :: freq
contains
  procedure                       :: show => show_node
end type

type queue
  type(node), allocatable :: buf(:)
  integer                 :: n = 0
contains
  procedure :: extractmin
  procedure :: append
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
      if (x(child+1)%freq < x(child)%freq ) then
        child = child +1
      end if
    end if
    if (x(parent)%freq > x(child)%freq) then
      x([child, parent]) = x([parent, child])
      parent = child
    else
      exit
    end if
  end do
  end associate
end subroutine

function extractmin(this) result (res)
  class(queue) :: this
  type(node)   :: res
  res = this%buf(1)
  this%buf(1) = this%buf(this%n)
  this%n = this%n - 1
  call this%siftdown(1)
end function

subroutine append(this, x)
  class(queue), intent(inout) :: this
  type(node)                  :: x
  type(node), allocatable     :: tmp(:)
  integer                     :: i
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

function join(a, b) result(c)
  type(node)             :: a, b, c
  integer                :: i, n, n1
  n1 = size(a%sym)
  n = n1 + size(b%sym)
  c%freq = a%freq + b%freq
  allocate (c%sym(n), c%code(n))
  do i = 1, n1
    c%sym(i) = a%sym(i)
    c%code(i) = "0" // trim(a%code(i))
  end do
  do i = 1, size(b%sym)
    c%sym(i+n1) = b%sym(i)
    c%code(i+n1) = "1" // trim(b%code(i))
  end do
end function

subroutine show_node(this)
  class(node) :: this
  integer     :: i
  write(*, "(*(g0,'-> ',g0,:,', '))", advance="no") &
   (this%sym(i), trim(this%code(i)), i=1,size(this%sym))
  print *
end subroutine

function create(letter, freq) result (this)
  character :: letter
  integer   :: freq
  type(node) :: this
  allocate(this%sym(1), this%code(1))
  this%sym(1) = letter ; this%code(1) = ""
  this%freq = freq
end function
end module

program main
  use huffman
  character (len=*), parameter   :: txt = &
   "this is an example for huffman encoding"
  integer                        :: i, freq(0:255) = 0
  type(queue)                    :: Q
  type(node)                     :: x
  do i = 1, len(txt)
    freq(ichar(txt(i:i))) = freq(ichar(txt(i:i))) + 1
  end do
  do i = 0, 255
    if (freq(i)>0) then
      call Q%append(create(char(i), freq(i)))
    end if
  end do
  do i = 1, Q%n-1
    call Q%append(join(Q%extractmin(),Q%extractmin()))
  end do
  x = Q%extractmin()
  call x%show()
  do i = 1, len(txt)
    do k = 1, size(x%sym)
      if (x%sym(k)==txt(i:i)) exit
     end do
     write (*, "(a,'|')", advance="no")  trim(x%code(k))
  end do
  print *
end program
