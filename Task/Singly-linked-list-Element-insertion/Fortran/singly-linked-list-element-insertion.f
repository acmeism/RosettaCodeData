elemental subroutine addAfter(nodeBefore,value)
   type (node), intent(inout) :: nodeBefore
   real, intent(in)           :: value
   type (node), pointer       :: newNode

   allocate(newNode)
   newNode%data = value
   newNode%next => nodeBefore%next
   nodeBefore%next => newNode
end subroutine addAfter
