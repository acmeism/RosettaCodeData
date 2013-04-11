program Pointpoly
  use Points_Module
  use Ray_Casting_Algo
  implicit none

  character(len=16), dimension(4) :: names
  type(polygon), dimension(4) :: polys
  type(point), dimension(14) :: pts
  type(point), dimension(7) :: p

  integer :: i, j

  pts = (/ point(0,0), point(10,0), point(10,10), point(0,10), &
           point(2.5,2.5), point(7.5,2.5), point(7.5,7.5), point(2.5,7.5), &
           point(0,5), point(10,5), &
           point(3,0), point(7,0), point(7,10), point(3,10) /)

  polys(1) = create_polygon(pts, (/ 1,2, 2,3, 3,4, 4,1 /) )
  polys(2) = create_polygon(pts, (/ 1,2, 2,3, 3,4, 4,1, 5,6, 6,7, 7,8, 8,5 /) )
  polys(3) = create_polygon(pts, (/ 1,5, 5,4, 4,8, 8,7, 7,3, 3,2, 2,5 /) )
  polys(4) = create_polygon(pts, (/ 11,12, 12,10, 10,13, 13,14, 14,9, 9,11 /) )

  names = (/ "square", "square hole", "strange", "exagon" /)

  p = (/ point(5,5), point(5, 8), point(-10, 5), point(0,5), point(10,5), &
         point(8,5), point(10,10) /)

  do j = 1, size(p)
     do i = 1, size(polys)
        write(*, "('point (',F8.2,',',F8.2,') is inside ',A,'? ', L)") &
             p(j)%x, p(j)%y, names(i), point_is_inside(p(j), polys(i))
     end do
     print *, ""
  end do

  do i = 1, size(polys)
     call free_polygon(polys(i))
  end do

end program Pointpoly
