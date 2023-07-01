module dlist
  implicit none
  type node
     type(node), pointer :: next => null()
     type(node), pointer :: prev => null()
     integer :: data
  end type node

  type dll
     type(node), pointer :: head => null()
     type(node), pointer :: tail => null()
     integer :: num_nodes = 0
  end type dll

  public  :: node, dll, append, prepend, insert, dump, reverse_dump, tidy
  private :: init

contains
  ! Create a new doubly-linked list
  elemental type(dll) function new_dll()
    new_dll = dll(null(),null(),0)
    return
  end function new_dll

  ! Append an element to the end of the list
  elemental subroutine append(dl2, value)
    type(dll), intent(inout) :: dl2
    integer, intent(in)      :: value

    type(node), pointer :: np

    ! If the list is empty
    if (dl2%num_nodes == 0) then
       call init(dl2, value)
       return
    end if

    ! Add new element to the end
    dl2%num_nodes = dl2%num_nodes + 1
    np => dl2%tail
    allocate(dl2%tail)
    dl2%tail%data = value
    dl2%tail%prev => np
    dl2%tail%prev%next => dl2%tail
  end subroutine append

  ! Prepend an element to the beginning of the list
  elemental subroutine prepend(dl2, value)
    type(dll), intent(inout) :: dl2
    integer, intent(in)      :: value

    type(node), pointer :: np

    if (dl2%num_nodes == 0) then
       call init(dl2, value)
       return
    end if

    dl2%num_nodes = dl2%num_nodes + 1
    np => dl2%head
    allocate(dl2%head)
    dl2%head%data = value
    dl2%head%next => np
    dl2%head%next%prev => dl2%head
  end subroutine prepend

  ! Insert immediately before the given index
  elemental subroutine insert(dl2, index, value)
    type(dll), intent(inout) :: dl2
    integer, intent(in)      :: index
    integer, intent(in)      :: value

    type(node), pointer :: element
    type(node), pointer :: np1, np2
    integer             :: i

    if (dl2%num_nodes == 0) then
       call init(dl2, value)
       return
    end if

    ! If index is beyond the end then append
    if (index > dl2%num_nodes) then
       call append(dl2, value)
       return
    end if

    ! If index is less than 1 then prepend
    if (index <= 1) then
       call prepend(dl2, value)
       return
    end if

    ! Find the node at position 'index' counting from 1
    np1 => dl2%head
    do i=1, index-2
       np1 => np1%next
    end do
    np2 => np1%next

    ! Create the new node
    allocate(element)
    element%data = value

    ! Connect it up
    element%prev => np1
    element%next => np2
    np1%next => element
    np2%prev => element
    dl2%num_nodes = dl2%num_nodes + 1
  end subroutine insert

  subroutine dump(dl2)
    type(dll), intent(in) :: dl2
    type(node), pointer :: current
    integer :: i

    write(*,fmt='(a,i0,a)',advance='no') 'Doubly-linked list has ',dl2%num_nodes,' element - fwd = '
    current => dl2%head
    i = 1
    write(*,fmt='(i0,a)',advance='no') current%data,', '
    do
       current => current%next
       if (.not. associated(current)) then
          exit
       end if
       i = i + 1
       if (i == dl2%num_nodes) then
          write(*,'(i0)') current%data
       else
          write(*,fmt='(i0,a)',advance='no') current%data,', '
       end if
    end do
  end subroutine dump

  subroutine reverse_dump(dl2)
    type(dll), intent(in) :: dl2
    type(node), pointer :: current
    integer :: i

    write(*,fmt='(a,i0,a)',advance='no') 'Doubly-linked list has ',dl2%num_nodes,' element - bwd = '
    current => dl2%tail
    write(*,fmt='(i0,a)',advance='no') current%data,', '
    i = 1
    do
       current => current%prev
       if (.not. associated(current)) then
          exit
       end if
       i = i + 1
       if (i == dl2%num_nodes) then
          write(*,'(i0)') current%data
       else
          write(*,fmt='(i0,a)',advance='no') current%data,', '
       end if
    end do
  end subroutine reverse_dump

  ! Deallocate all allocated memory
  elemental subroutine tidy(dl2)
    type(dll), intent(inout) :: dl2
    type(node), pointer :: current, last

    current => dl2%head
    do
       last => current
       current => current%next
       if (associated(last)) then
          deallocate(last)
       end if
       if (associated(current, dl2%tail)) then
          deallocate(current)
          exit
       end if
    end do
  end subroutine tidy

  elemental subroutine init(dl2, value)
    type(dll), intent(inout) :: dl2
    integer, intent(in)      :: value
    allocate(dl2%head)
    dl2%tail => dl2%head
    dl2%tail%data = value
    dl2%num_nodes = 1
    return
  end subroutine init

end module dlist

program dl
  use dlist
  implicit none

  type(dll) :: mydll

  mydll = new_dll()
  call append(mydll, 5)
  call append(mydll, 7)
  call prepend(mydll, 3)
  call prepend(mydll, 1)
  call insert(mydll, 3, 4)
  call dump(mydll)

  call reverse_dump(mydll)

  call tidy(mydll)
end program dl
