module fifo_nodes
  type fifo_node
     integer :: datum
     ! the next part is not variable and must be present
     type(fifo_node), pointer :: next
     logical :: valid
  end type fifo_node
end module fifo_nodes

program FIFOTest
  use fifo
  implicit none

  type(fifo_head) :: thehead
  type(fifo_node), dimension(5) :: ex, xe
  integer :: i

  call new_fifo(thehead)

  do i = 1, 5
     ex(i)%datum = i
     call fifo_enqueue(thehead, ex(i))
  end do

  i = 1
  do
     call fifo_dequeue(thehead, xe(i))
     print *, xe(i)%datum
     i = i + 1
     if ( fifo_isempty(thehead) ) exit
  end do

end program FIFOTest
