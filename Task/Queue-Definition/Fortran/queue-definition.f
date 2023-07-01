module FIFO
  use fifo_nodes
! fifo_nodes must define the type fifo_node, with the two field
! next and valid, for queue handling, while the field datum depends
! on the usage (see [[FIFO (usage)]] for an example)
!  type fifo_node
!     integer :: datum
!     ! the next part is not variable and must be present
!     type(fifo_node), pointer :: next
!     logical :: valid
!  end type fifo_node

  type fifo_head
     type(fifo_node), pointer :: head, tail
  end type fifo_head

contains

  subroutine new_fifo(h)
    type(fifo_head), intent(out) :: h
    nullify(h%head)
    nullify(h%tail)
  end subroutine new_fifo

  subroutine fifo_enqueue(h, n)
    type(fifo_head), intent(inout) :: h
    type(fifo_node), intent(inout), target :: n

    if ( associated(h%tail) ) then
       h%tail%next => n
       h%tail => n
    else
       h%tail => n
       h%head => n
    end if

    nullify(n%next)
  end subroutine fifo_enqueue

  subroutine fifo_dequeue(h, n)
    type(fifo_head), intent(inout) :: h
    type(fifo_node), intent(out), target :: n

    if ( associated(h%head) ) then
       n = h%head
       if ( associated(n%next) ) then
          h%head => n%next
       else
          nullify(h%head)
          nullify(h%tail)
       end if
       n%valid = .true.
    else
       n%valid = .false.
    end if
    nullify(n%next)
  end subroutine fifo_dequeue

  function fifo_isempty(h) result(r)
    logical :: r
    type(fifo_head), intent(in) :: h
    if ( associated(h%head) ) then
       r = .false.
    else
       r = .true.
    end if
  end function fifo_isempty

end module FIFO
