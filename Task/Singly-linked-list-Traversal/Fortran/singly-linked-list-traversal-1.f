subroutine traversal(list,proc)
   type(node), target    :: list
   type(node), pointer   :: current
   interface
      subroutine proc(node)
         real, intent(in) :: node
      end subroutine proc
   end interface
   current => list
   do while ( associated(current) )
      call proc(current%data)
      current => current%next
   end do
end subroutine traversal
