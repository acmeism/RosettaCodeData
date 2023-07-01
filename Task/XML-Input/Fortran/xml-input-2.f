program fox_rosetta
   use FoX_dom
   use FoX_sax
   implicit none
   integer :: i
   type(Node), pointer :: doc => null()
   type(Node), pointer :: p1 => null()
   type(Node), pointer :: p2 => null()
   type(NodeList), pointer :: pointList => null()
   character(len=100) :: name

   doc => parseFile("rosetta.xml")
   if(.not. associated(doc)) stop "error doc"

   p1 => item(getElementsByTagName(doc, "Students"), 0)
   if(.not. associated(p1)) stop "error p1"
   ! write(*,*) getNodeName(p1)

   pointList => getElementsByTagname(p1, "Student")
   ! write(*,*) getLength(pointList), "Student elements"

   do i = 0, getLength(pointList) - 1
      p2 => item(pointList, i)
      call extractDataAttribute(p2, "Name", name)
      write(*,*) name
   enddo

   call destroy(doc)
end program fox_rosetta
