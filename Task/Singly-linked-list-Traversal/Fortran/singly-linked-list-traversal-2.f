subroutine printNode(data)
   real, intent(in)  :: data
   write (*,*) data
end subroutine

subroutine printAll(list)
   type(node), intent(in)  :: list
   call traversal(list,printNode)
end subroutine printAll
